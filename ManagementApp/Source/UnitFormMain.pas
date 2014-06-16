unit UnitFormMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.StrUtils,
  FMX.Types, FMX.Graphics, FMX.Objects, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView, FMX.Layouts, FMX.Memo, FMX.TabControl,
  FMX.Edit, System.Actions, FMX.ActnList, FMX.Menus, FMX.ListBox, System.Generics.Collections,
  //  member followup includes...
  MemberFollowUp.Baas.Base,
  MemberFollowUp.Baas.Classes,
  MemberFollowUp.Baas.Areas,
  MemberFollowUp.Baas.Followupers,
  MemberFollowUp.Baas.MemberGroups,
  MemberFollowUp.Baas.Members,
  //  local includes...
  UnitFormEditArea,
  UnitFormEditMemberGroup,
  UnitFormEditMember,
  UnitFormEditFollowuper;


type
  TFormMain = class(TForm)
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
    ActionEditMemberGroups: TAction;
    PopupMenuMemberGroups: TPopupMenu;
    MenuItemEdit: TMenuItem;
    ActionNewMemberGroups: TAction;
    ButtonDeleteFamily: TButton;
    ActionDeleteMemberGroups: TAction;
    MenuItemDelete: TMenuItem;
    MenuItem1: TMenuItem;
    ActionRefreshMemberGroups: TAction;
    MenuItemSpacer1: TMenuItem;
    StyleBook: TStyleBook;
    ListBoxMemberGroups: TListBox;
    SearchBox1: TSearchBox;
    TabItemAreas: TTabItem;
    ActionRefreshAreas: TAction;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ListBoxAreas: TListBox;
    SearchBox2: TSearchBox;
    ActionRefreshFollowupers: TAction;
    Panel3: TPanel;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    ListBoxFollowupers: TListBox;
    SearchBox3: TSearchBox;
    ActionRefreshMembers: TAction;
    ListBoxMembers: TListBox;
    SearchBox4: TSearchBox;
    Panel4: TPanel;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    ActionDeleteAreas: TAction;
    ActionEditAreas: TAction;
    ActionNewAreas: TAction;
    ActionNewMember: TAction;
    ActionEditMember: TAction;
    ActionDeleteMembers: TAction;
    ActionNewFollowuper: TAction;
    ActionEditFollowuper: TAction;
    ActionDeleteFollowupers: TAction;
    PopupMenuAreas: TPopupMenu;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    PopupMenuMembers: TPopupMenu;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    PopupMenuFollowupers: TPopupMenu;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    procedure ActionEditMemberGroupsExecute(Sender: TObject);
    procedure ActionNewMemberGroupsExecute(Sender: TObject);
    procedure ActionRefreshMemberGroupsExecute(Sender: TObject);
    procedure ListBoxMemberGroupsDblClick(Sender: TObject);
    procedure ListBoxMemberGroupsChange(Sender: TObject);
    procedure ActionDeleteMemberGroupsExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActionRefreshAreasExecute(Sender: TObject);
    procedure ActionRefreshFollowupersExecute(Sender: TObject);
    procedure ActionRefreshMembersExecute(Sender: TObject);
    procedure ActionDeleteAreasExecute(Sender: TObject);
    procedure ListBoxAreasChange(Sender: TObject);
    procedure ListBoxAreasDblClick(Sender: TObject);
    procedure ListBoxMembersChange(Sender: TObject);
    procedure ListBoxMembersDblClick(Sender: TObject);
    procedure ActionDeleteMembersExecute(Sender: TObject);
    procedure ActionDeleteFollowupersExecute(Sender: TObject);
    procedure ListBoxFollowupersChange(Sender: TObject);
    procedure ListBoxFollowupersDblClick(Sender: TObject);
    procedure ActionNewMemberExecute(Sender: TObject);
    procedure ActionEditMemberExecute(Sender: TObject);
    procedure ActionNewAreasExecute(Sender: TObject);
    procedure ActionEditAreasExecute(Sender: TObject);
    procedure ActionNewFollowuperExecute(Sender: TObject);
    procedure ActionEditFollowuperExecute(Sender: TObject);
  private
    procedure DisplayBaasForm(AForm: TBaasForm; AItem: TBaasItem = nil);

    procedure ProcessBaasItemOnUpdateEvent(ASender: TObject; const EventType: TBaasItemNotifyEventType; const AItem: TBaasItem);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}


procedure TFormMain.DisplayBaasForm(AForm: TBaasForm; AItem: TBaasItem = nil);
begin
    try
        AForm.OnUpdateItem := ProcessBaasItemOnUpdateEvent;
        AForm.Item         := AItem;
        AForm.ShowModal;
    finally
        AForm.Free;
    end;
end;


{ TFormMain }

procedure TFormMain.ActionNewAreasExecute(Sender: TObject);
begin
    DisplayBaasForm(TFormEditArea.Create(Self));
end;

procedure TFormMain.ActionEditAreasExecute(Sender: TObject);
begin
    DisplayBaasForm(TFormEditArea.Create(Self), ListBoxAreas.Selected.Data as TBaasItem);
end;

procedure TFormMain.ActionNewMemberExecute(Sender: TObject);
begin
    DisplayBaasForm(TFormEditMember.Create(Self));
end;

procedure TFormMain.ActionEditMemberExecute(Sender: TObject);
begin
    DisplayBaasForm(TFormEditMember.Create(Self), ListBoxMembers.Selected.Data as TBaasItem);
end;

procedure TFormMain.ActionNewMemberGroupsExecute(Sender: TObject);
begin
    DisplayBaasForm(TFormEditMemberGroup.Create(Self));
end;

procedure TFormMain.ActionEditMemberGroupsExecute(Sender: TObject);
begin
    DisplayBaasForm(TFormEditMemberGroup.Create(Self), ListBoxMemberGroups.Selected.Data as TBaasItem);
end;

procedure TFormMain.ActionNewFollowuperExecute(Sender: TObject);
begin
    DisplayBaasForm(TFormEditFollowuper.Create(Self));
end;

procedure TFormMain.ActionEditFollowuperExecute(Sender: TObject);
begin
    DisplayBaasForm(TFormEditFollowuper.Create(Self), ListBoxFollowupers.Selected.Data as TBaasItem);
end;

procedure TFormMain.ListBoxAreasChange(Sender: TObject);
begin
    ActionEditAreas.Enabled   := (ListBoxAreas.Selected <> nil);
    ActionDeleteAreas.Enabled := (ListBoxAreas.Selected <> nil);
end;

procedure TFormMain.ListBoxAreasDblClick(Sender: TObject);
begin
    ActionEditAreas.Execute;
end;

procedure TFormMain.ListBoxFollowupersChange(Sender: TObject);
begin
    ActionEditFollowuper.Enabled    := (ListBoxFollowupers.Selected <> nil);
    ActionDeleteFollowupers.Enabled := (ListBoxFollowupers.Selected <> nil);
end;

procedure TFormMain.ListBoxFollowupersDblClick(Sender: TObject);
begin
    ActionEditFollowuper.Execute;
end;

procedure TFormMain.ListBoxMemberGroupsChange(Sender: TObject);
begin
    ActionEditMemberGroups.Enabled   := (ListBoxMemberGroups.Selected <> nil);
    ActionDeleteMemberGroups.Enabled := (ListBoxMemberGroups.Selected <> nil);
end;

procedure TFormMain.ListBoxMemberGroupsDblClick(Sender: TObject);
begin
    ActionEditMemberGroups.Execute;
end;

procedure TFormMain.ListBoxMembersChange(Sender: TObject);
begin
    ActionEditMember.Enabled    := (ListBoxMembers.Selected <> nil);
    ActionDeleteMembers.Enabled := (ListBoxMembers.Selected <> nil);
end;

procedure TFormMain.ListBoxMembersDblClick(Sender: TObject);
begin
    ActionEditMember.Execute;
end;

procedure TFormMain.ProcessBaasItemOnUpdateEvent(ASender: TObject; const EventType: TBaasItemNotifyEventType; const AItem: TBaasItem);
begin
    if AItem is TAreaItem then
    begin
        case EventType of
          Add:    TMemberFollowUpClasses.GetInstance.Areas.AddBackendItem(AItem);
          Update: TMemberFollowUpClasses.GetInstance.Areas.UpdateBackendItem(AItem);
        end;
        ActionRefreshAreas.Execute;

    end else if AItem is TMember then
    begin

        case EventType of
          Add:    TMemberFollowUpClasses.GetInstance.Members.AddBackendItem(AItem);
          Update: TMemberFollowUpClasses.GetInstance.Members.UpdateBackendItem(AItem);
        end;
        ActionRefreshMembers.Execute;

    end else if AItem is TMemberGroup then
    begin
        case EventType of
          Add:    TMemberFollowUpClasses.GetInstance.MemberGroups.AddBackendItem(AItem);
          Update: TMemberFollowUpClasses.GetInstance.MemberGroups.UpdateBackendItem(AItem);
        end;
        ActionRefreshMemberGroups.Execute;

    end else if AItem is TFollowuper then
    begin
        case EventType of
          Add:    TMemberFollowUpClasses.GetInstance.Followupers.AddBackendItem(AItem);
          Update: TMemberFollowUpClasses.GetInstance.Followupers.UpdateBackendItem(AItem);
        end;
        ActionRefreshFollowupers.Execute;
    end;
end;

procedure TFormMain.ActionDeleteAreasExecute(Sender: TObject);
begin
    try
        if MessageDlg('Are you sure you want to delete the selected item(s)', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
        begin
            TMemberFollowUpClasses.GetInstance.Areas.DeleteBackendItem(ListBoxAreas.Selected.Data as TBaasItem);
            ListBoxAreas.Items.Delete(ListBoxAreas.Selected.Index);
        end;
    except
        on E: Exception do
            ShowMessage('Error deleting Area ('+ E.Message +')');
    end;
end;

procedure TFormMain.ActionDeleteFollowupersExecute(Sender: TObject);
begin
    try
        if MessageDlg('Are you sure you want to delete the selected item(s)', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
        begin
            TMemberFollowUpClasses.GetInstance.Followupers.DeleteBackendItem(ListBoxFollowupers.Selected.Data as TBaasItem);
            ListBoxFollowupers.Items.Delete(ListBoxFollowupers.Selected.Index);
        end;
    except
        on E: Exception do
            ShowMessage('Error deleting Member Group ('+ E.Message +')');
    end;
end;

procedure TFormMain.ActionDeleteMemberGroupsExecute(Sender: TObject);
begin
    try
        if MessageDlg('Are you sure you want to delete the selected item(s)', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
        begin
            TMemberFollowUpClasses.GetInstance.MemberGroups.DeleteBackendItem(ListBoxMemberGroups.Selected.Data as TBaasItem);
            ListBoxMemberGroups.Items.Delete(ListBoxMemberGroups.Selected.Index);
        end;
    except
        on E: Exception do
            ShowMessage('Error deleting Member Group ('+ E.Message +')');
    end;
end;

procedure TFormMain.ActionDeleteMembersExecute(Sender: TObject);
begin
    try
        if MessageDlg('Are you sure you want to delete the selected item(s)', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
        begin
            TMemberFollowUpClasses.GetInstance.Members.DeleteBackendItem(ListBoxMembers.Selected.Data as TBaasItem);
            ListBoxMembers.Items.Delete(ListBoxMembers.Selected.Index);
        end;
    except
        on E: Exception do
            ShowMessage('Error deleting Member ('+ E.Message +')');
    end;
end;

procedure TFormMain.ActionRefreshFollowupersExecute(Sender: TObject);

    procedure AddItem(AListBox: TListBox; const AItem: TFollowuper);
    var
      LListBoxItem : TListBoxItem;
    begin
        LListBoxItem := TListBoxItem.Create(nil);
        LListBoxItem.Parent                   := AListBox;
        LListBoxItem.StyleLookup              := 'ListBoxItem1Style1';
        LListBoxItem.Text                     := AItem.Name +' ('+ AItem.ContactNumber +')';
        LListBoxItem.StylesData['detailtext'] := IFThen(AItem.Active, 'Active', 'Not Active');
        LListBoxItem.Data                     := AItem;
    end;

var
  LItem : TFollowuper;
begin
    try
        ListBoxFollowupers.Clear;
        for LItem in TMemberFollowUpClasses.GetInstance.Followupers do
            AddItem(ListBoxFollowupers, LItem);
    except
        on E: Exception do
            ShowMessage('Error refreshing Families ('+ E.Message +')');
    end;
end;

procedure TFormMain.ActionRefreshAreasExecute(Sender: TObject);

    procedure AddItem(AListBox: TListBox; const AItem: TAreaItem);
    var
      LListBoxItem : TListBoxItem;
    begin
        LListBoxItem := TListBoxItem.Create(nil);
        LListBoxItem.Parent      := AListBox;
//        LListBoxItem.StyleLookup := 'ListBoxItem1Style1';
        LListBoxItem.Text        := AItem.Name;
        LListBoxItem.Data        := AItem;
    end;

var
  LItem : TAreaItem;
begin
    try
        ListBoxAreas.Clear;
        for LItem in TMemberFollowUpClasses.GetInstance.Areas do
            AddItem(ListBoxAreas, LItem);
    except
        on E: Exception do
            ShowMessage('Error refreshing Families ('+ E.Message +')');
    end;
end;

procedure TFormMain.ActionRefreshMemberGroupsExecute(Sender: TObject);

    procedure AddItem(AListBox: TListBox; const AItem: TMemberGroup);
    var
      LListBoxItem : TListBoxItem;
    begin
        LListBoxItem := TListBoxItem.Create(nil);
        LListBoxItem.Parent                   := AListBox;
        LListBoxItem.StyleLookup              := 'ListBoxItem1Style1';
        LListBoxItem.Text                     := AItem.Name +' ('+ AItem.HeadName +')';
        LListBoxItem.StylesData['detailtext'] := AItem.FullAddress;
        LListBoxItem.Data                     := AItem;
    end;

var
  LItem : TMemberGroup;
begin
    try
        ListBoxMemberGroups.Clear;
        for LItem in TMemberFollowUpClasses.GetInstance.MemberGroups do
            AddItem(ListBoxMemberGroups, LItem);
    except
        on E: Exception do
            ShowMessage('Error refreshing Families ('+ E.Message +')');
    end;
end;

procedure TFormMain.ActionRefreshMembersExecute(Sender: TObject);

    procedure AddItem(AListBox: TListBox; const AItem: TMember);
    var
      LListBoxItem : TListBoxItem;
    begin
        LListBoxItem := TListBoxItem.Create(nil);
        LListBoxItem.Parent                   := AListBox;
        LListBoxItem.StyleLookup              := 'ListBoxItem1Style1';
        LListBoxItem.Text                     := AItem.Surname +', '+ AItem.Name +' ('+ AItem.MobilePhone +')';
        LListBoxItem.StylesData['detailtext'] := AItem.EmailAddress;
        LListBoxItem.Data                     := AItem;
    end;

var
  LItem : TMember;
begin
    try
        ListBoxMembers.Clear;
        for LItem in TMemberFollowUpClasses.GetInstance.Members do
            AddItem(ListBoxMembers, LItem);
    except
        on E: Exception do
            ShowMessage('Error refreshing Families ('+ E.Message +')');
    end;

end;

procedure TFormMain.FormShow(Sender: TObject);
begin
    TMemberFollowUpClasses.GetInstance.Areas.Refresh;
    TMemberFollowUpClasses.GetInstance.MemberGroups.Refresh;
    TMemberFollowUpClasses.GetInstance.Followupers.Refresh;
    TMemberFollowUpClasses.GetInstance.Members.Refresh;
end;

end.
