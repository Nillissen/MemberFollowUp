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
  FMX.Edit, UnitFormFamilyEdit, System.Actions, FMX.ActnList, FMX.Menus, FMX.ListBox,
  REST.Backend.Providers,
  //  member followup includes...
  MemberFollowUp.Baas.Keys,
  MemberFollowUp.Baas.Areas,
  MemberFollowUp.Baas.Families;


type
  TFormMain = class(TForm)
    ParseProvider: TParseProvider;
    BackendQuery: TBackendQuery;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Followups: TTabItem;
    TabItem3: TTabItem;
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
    procedure ActionEditFamilyExecute(Sender: TObject);
    procedure ActionAddFamilyExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActionRefreshFamilyExecute(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1Change(Sender: TObject);
    procedure ActionDeleteFamilyExecute(Sender: TObject);
  private
    FAreas    : TAreaCollection;
    FFamilies : TFamilyCollection;

    procedure ProcessFamilyOnAddEvent(ASender: TObject; const AItem: TFamilyItem);
    procedure ProcessFamilyOnUpdateEvent(ASender: TObject; const AItem: TFamilyItem);
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
    ParseProvider.MasterKey     := MEMBERFOLLOWUP_PARSE_MASTERKEY;
    ParseProvider.RestApiKey    := MEMBERFOLLOWUP_PARSE_RESTAPIKEY;

    FAreas    := TAreaCollection.Create(ParseProvider.ProviderID, BackendStorage);
    FFamilies := TFamilyCollection.Create(ParseProvider.ProviderID, BackendStorage);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
    FFamilies.Free;
    FAreas.Free;
end;

procedure TFormMain.ActionAddFamilyExecute(Sender: TObject);
var
  LWindow : TFormFamilyEdit;
begin
    LWindow := TFormFamilyEdit.Create(Self);
    try
        LWindow.OnAddItem := ProcessFamilyOnAddEvent;
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

procedure TFormMain.ProcessFamilyOnAddEvent(ASender: TObject; const AItem: TFamilyItem);
begin
    FFamilies.AddBackendItem(AItem);
end;

procedure TFormMain.ProcessFamilyOnUpdateEvent(ASender: TObject; const AItem: TFamilyItem);
begin
    FFamilies.UpdateBackendItem(AItem);
end;

procedure TFormMain.ActionDeleteFamilyExecute(Sender: TObject);
begin
    try
        FFamilies.DeleteBackendItem(Listbox1.Selected.Data as TFamilyItem);
        ListBox1.Items.Delete(Listbox1.Selected.Index);
    except
        on E: Exception do
            ShowMessage('Error deleting Family ('+ E.Message +')');
    end;
end;

procedure TFormMain.ActionEditFamilyExecute(Sender: TObject);
var
  LWindow : TFormFamilyEdit;
begin
    LWindow := TFormFamilyEdit.Create(Self);
    try
        LWindow.OnUpdateItem := ProcessFamilyOnUpdateEvent;
        LWindow.Item := Listbox1.Selected.Data as TFamilyItem;
        LWindow.ShowModal;
    finally
        LWindow.Free;
    end;
end;

procedure TFormMain.ActionRefreshFamilyExecute(Sender: TObject);
var
  LFamilyItem  : TFamilyItem;
  LListBoxItem : TListBoxItem;
begin
    try
        FFamilies.Refresh;

        ListBox1.Clear;
        for LFamilyItem in FFamilies do
        begin
            LListBoxItem := TListBoxItem.Create(nil);
            LListBoxItem.Parent := ListBox1;
            LListBoxItem.StyleLookup := 'ListBoxItem1Style1';
            LListBoxItem.Text := LFamilyItem.Name +' ('+ LFamilyItem.HeadName +')';
            LListBoxItem.StylesData['detailtext'] := LFamilyItem.FullAddress;
            LListBoxItem.Data := LFamilyItem;
        end;
    except
        on E: Exception do
            ShowMessage('Error refreshing Families ('+ E.Message +')');
    end;
end;

end.
