unit UnitFormEditMember;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Edit,
  //  member followup includes...
  MemberFollowUp.Baas.Base,
  MemberFollowUp.Baas.Classes,
  MemberFollowUp.Baas.MemberGroups,
  MemberFollowUp.Baas.Members;

type
  TFormEditMember = class(TBaasForm)
    ButtonSave: TButton;
    ButtonCancel: TButton;
    Label3: TLabel;
    EditName: TEdit;
    Label1: TLabel;
    EditDateOfBirth: TEdit;
    Label2: TLabel;
    EditMobileNumber: TEdit;
    Label4: TLabel;
    EditEmailAddress: TEdit;
    Label5: TLabel;
    EditYearSpiritFilled: TEdit;
    Label6: TLabel;
    ListBoxGroupMembers: TListBox;
    SearchBox1: TSearchBox;
    EditGroupMemberId: TEdit;
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxGroupMembersDblClick(Sender: TObject);
  protected
    procedure SetSelectedItem(const AItem: TBaasItem); override;
  end;


implementation

{$R *.fmx}

{ TForm1 }

procedure TFormEditMember.SetSelectedItem(const AItem: TBaasItem);
begin
    inherited;
    if AItem <> nil then
    begin
        Self.Caption    := 'Edit Member';
        ButtonSave.Text := 'Update';

        EditName.Text             := (AItem as TMember).Name;
        EditDateOfBirth.Text      := (AItem as TMember).DateOfBirth;
        EditMobileNumber.Text     := (AItem as TMember).MobilePhone;
        EditEmailAddress.Text     := (AItem as TMember).EmailAddress;
        EditYearSpiritFilled.Text := (AItem as TMember).YearSpiritFilled;
        EditGroupMemberId.Text    := (AItem as TMember).MemberGroupObjectId;
    end;
end;

procedure TFormEditMember.ButtonCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TFormEditMember.ButtonSaveClick(Sender: TObject);
var
  LItem : TMember;
begin
    if FSelectedItem = nil then
        LItem := TMember.Create
    else
        LItem := FSelectedItem as TMember;

    LItem.Name                := EditName.Text;
    LItem.DateOfBirth         := EditDateOfBirth.Text;
    LItem.MobilePhone         := EditMobileNumber.Text;
    LItem.EmailAddress        := EditEmailAddress.Text;
    LItem.YearSpiritFilled    := EditYearSpiritFilled.Text;
    LItem.MemberGroupObjectId := EditGroupMemberId.Text;

    if FSelectedItem = nil then
        FOnUpdateItem(Self, TBaasItemNotifyEventType.Add, LItem)
    else
        FOnUpdateItem(Self, TBaasItemNotifyEventType.Update, LItem);

    Self.Close;
end;


procedure TFormEditMember.FormCreate(Sender: TObject);
var
  LMemberGroup : TMemberGroup;
begin
    for LMemberGroup in TMemberFollowUpClasses.GetInstance.MemberGroups do
        ListBoxGroupMembers.Items.AddObject(LMemberGroup.Name +' ('+ LMemberGroup.HeadName +')', LMemberGroup);
end;

procedure TFormEditMember.ListBoxGroupMembersDblClick(Sender: TObject);
begin
    EditGroupMemberId.Text := TMemberFollowUpClasses.GetInstance.MemberGroups.GetObjectId(ListBoxGroupMembers.Items.Objects[ListBoxGroupMembers.ItemIndex] as TMemberGroup);
end;

end.
