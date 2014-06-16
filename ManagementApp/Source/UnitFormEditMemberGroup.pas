unit UnitFormEditMemberGroup;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, IPPeerClient, REST.Backend.ServiceTypes,
  REST.Backend.MetaTypes, System.JSON, REST.Backend.ParseServices,
  REST.OpenSSL, REST.Backend.ParseProvider, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Backend.BindSource,
  REST.Backend.ServiceComponents, REST.Backend.Providers,
  //  member followup includes...
  MemberFollowUp.Baas.Base,
  MemberFollowUp.Baas.MemberGroups;


type
  TFormEditMemberGroup = class(TBaasForm)
    EditSurname: TEdit;
    EditHeadName: TEdit;
    EditHomePhone: TEdit;
    EditAddress: TEdit;
    EditSuburb: TEdit;
    EditPostCode: TEdit;
    CheckBoxNoHomeVisit: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ButtonSave: TButton;
    ButtonCancel: TButton;
    AniIndicator1: TAniIndicator;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
  protected
    procedure SetSelectedItem(const AItem: TBaasItem); override;
  end;


implementation

{$R *.fmx}


{ TFormFamilyEdit }

procedure TFormEditMemberGroup.SetSelectedItem(const AItem: TBaasItem);
begin
    inherited;
    if AItem <> nil then
    begin
        Self.Caption    := 'Edit Member Family';
        ButtonSave.Text := 'Update';

        EditSurname.Text              := (AItem as TMemberGroup).Name;
        EditHeadName.Text             := (AItem as TMemberGroup).HeadName;
        EditHomePhone.Text            := (AItem as TMemberGroup).HomePhone;
        EditAddress.Text              := (AItem as TMemberGroup).Address;
        EditSuburb.Text               := (AItem as TMemberGroup).Suburb;
        EditPostCode.Text             := (AItem as TMemberGroup).PostCode;
        CheckBoxNoHomeVisit.IsChecked := (AItem as TMemberGroup).NoHomeVisit;
    end;
end;

procedure TFormEditMemberGroup.ButtonSaveClick(Sender: TObject);
var
  LItem : TMemberGroup;
begin
    if FSelectedItem = nil then
        LItem := TMemberGroup.Create
    else
        LItem := FSelectedItem as TMemberGroup;

    LItem.Name         := EditSurname.Text;
    LItem.HeadName     := EditHeadName.Text;
    LItem.HomePhone    := EditHomePhone.Text;
    LItem.Address      := EditAddress.Text;
    LItem.Suburb       := EditSuburb.Text;
    LItem.PostCode     := EditPostCode.Text;
    LItem.NoHomeVisit  := CheckBoxNoHomeVisit.IsChecked;

    if FSelectedItem = nil then
        FOnUpdateItem(Self, TBaasItemNotifyEventType.Add, LItem)
    else
        FOnUpdateItem(Self, TBaasItemNotifyEventType.Update, LItem);

    Self.Close;
end;

procedure TFormEditMemberGroup.ButtonCancelClick(Sender: TObject);
begin
    Self.Close;
end;

end.
