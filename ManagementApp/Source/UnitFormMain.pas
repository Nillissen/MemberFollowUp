unit UnitFormMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Objects, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  IPPeerClient, REST.OpenSSL, REST.Backend.ParseProvider,
  REST.Backend.ServiceTypes, REST.Backend.MetaTypes, System.JSON,
  REST.Backend.ParseServices, FMX.ListView.Types, FMX.ListView,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Backend.BindSource,
  REST.Backend.ServiceComponents, FMX.Layouts, FMX.Memo, FMX.TabControl,
  FMX.Edit, System.Actions, FMX.ActnList, FMX.Menus, FMX.ListBox,
  REST.Backend.Providers,
  //  member followup includes...
  MemberFollowUp.Baas.Keys,
  MemberFollowUp.Baas.Areas,
  MemberFollowUp.Baas.MemberGroups,
  MemberFollowUp.Baas.Followupers,
  //  local includes...
  UnitFormEditMemberGroup;


type
  TFormMain = class(TForm)
    ParseProvider: TParseProvider;
    TabControl1: TTabControl;
    TabItemFamilies: TTabItem;
    TabItemPersons: TTabItem;
    TabItemFollowups: TTabItem;
    TabItemFollowupers: TTabItem;
    Panel1: TPanel;
    ButtonRefreshFamilies: TButton;
    ButtonAddFamily: TButton;
    ButtonEditFamily: TButton;
    ActionList: TActionList;
    ActionEditFamily: TAction;
    PopupMenuFamilies: TPopupMenu;
    MenuItemEdit: TMenuItem;
    ActionAddFamily: TAction;
    BackendStorage: TBackendStorage;
    ButtonDeleteFamily: TButton;
    ActionDeleteFamily: TAction;
    MenuItemDelete: TMenuItem;
    MenuItem1: TMenuItem;
    ActionRefreshFamily: TAction;
    MenuItemSpacer1: TMenuItem;
    StyleBook: TStyleBook;
    ListBox1: TListBox;
    SearchBox1: TSearchBox;
    TabItemAreas: TTabItem;
    procedure ActionEditFamilyExecute(Sender: TObject);
    procedure ActionAddFamilyExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActionRefreshFamilyExecute(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1Change(Sender: TObject);
    procedure ActionDeleteFamilyExecute(Sender: TObject);
  private
    FAreas        : TAreaCollection;
    FMemberGroups : TMemberGroupCollection;
    FFollowupers  : TFollowuperCollection;

    procedure ProcessMemberGroupOnAddEvent(ASender: TObject; const AItem: TBaasItem);
    procedure ProcessMemberGroupOnUpdateEvent(ASender: TObject; const AItem: TBaasItem);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}


function GetJsonValue(AObject: TJSONValue; const AName: String; const ADefaultValue: String = ''): String;
var
  LJsonPair : TJSONPair;
begin
    LJsonPair := (AObject as TJSONObject).Get(AName);
    if LJsonPair <> nil then
        Result := LJsonPair.JsonValue.Value
    else
        Result := ADefaultValue;
end;


{ TFormMain }

procedure TFormMain.FormCreate(Sender: TObject);
begin
    ParseProvider.ApplicationID := MEMBERFOLLOWUP_PARSE_APPLICATIONID;
    ParseProvider.RestApiKey    := MEMBERFOLLOWUP_PARSE_RESTAPIKEY;

    FAreas        := TAreaCollection.Create(ParseProvider.ProviderID, BackendStorage);
    FMemberGroups := TMemberGroupCollection.Create(ParseProvider.ProviderID, BackendStorage);
    FFollowupers  := TFollowuperCollection.Create(ParseProvider.ProviderID, BackendStorage);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
    FFollowupers.Free;
    FMemberGroups.Free;
    FAreas.Free;
end;

procedure TFormMain.ActionAddFamilyExecute(Sender: TObject);
var
  LWindow : TFormEditMemberGroup;
begin
    LWindow := TFormEditMemberGroup.Create(Self);
    try
        LWindow.OnAddItem := ProcessMemberGroupOnAddEvent;
        LWindow.ShowModal;
    finally
        LWindow.Free;
    end;
end;

procedure TFormMain.ListBox1Change(Sender: TObject);
begin
    ActionEditFamily.Enabled   := (ListBox1.Selected <> nil);
    ActionDeleteFamily.Enabled := (ListBox1.Selected <> nil);
end;

procedure TFormMain.ListBox1DblClick(Sender: TObject);
begin
    ActionEditFamily.Execute;
end;

procedure TFormMain.ProcessMemberGroupOnAddEvent(ASender: TObject; const AItem: TBaasItem);
begin
    FMemberGroups.AddBackendItem(AItem);
end;

procedure TFormMain.ProcessMemberGroupOnUpdateEvent(ASender: TObject; const AItem: TBaasItem);
begin
    FMemberGroups.UpdateBackendItem(AItem);
end;

procedure TFormMain.ActionDeleteFamilyExecute(Sender: TObject);
begin
    try
        FMemberGroups.DeleteBackendItem(Listbox1.Selected.Data as TMemberGroup);
        ListBox1.Items.Delete(Listbox1.Selected.Index);
    except
        on E: Exception do
            ShowMessage('Error deleting Family ('+ E.Message +')');
    end;
end;

procedure TFormMain.ActionEditFamilyExecute(Sender: TObject);
var
  LWindow : TFormEditMemberGroup;
begin
    LWindow := TFormEditMemberGroup.Create(Self);
    try
        LWindow.OnUpdateItem := ProcessMemberGroupOnUpdateEvent;
        LWindow.Item := Listbox1.Selected.Data as TMemberGroup;
        LWindow.ShowModal;
    finally
        LWindow.Free;
    end;
end;

procedure TFormMain.ActionRefreshFamilyExecute(Sender: TObject);
var
  LMemberGroup : TMemberGroup;
  LListBoxItem : TListBoxItem;
begin
    try
        FAreas.Refresh;
        FMemberGroups.Refresh;

        ListBox1.Clear;
        for LMemberGroup in FMemberGroups do
        begin
            LListBoxItem := TListBoxItem.Create(nil);
            LListBoxItem.Parent                   := ListBox1;
            LListBoxItem.StyleLookup              := 'ListBoxItem1Style1';
            LListBoxItem.Text                     := LMemberGroup.Name +' ('+ LMemberGroup.HeadName +')';
            LListBoxItem.StylesData['detailtext'] := LMemberGroup.FullAddress;
            LListBoxItem.Data                     := LMemberGroup;
        end;
    except
        on E: Exception do
            ShowMessage('Error refreshing Families ('+ E.Message +')');
    end;
end;

end.
