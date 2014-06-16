unit UnitFormEditFollowuper;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit,
  //  member followup includes...
  MemberFollowUp.Baas.Base,
  MemberFollowUp.Baas.Followupers;

type
  TFormEditFollowuper = class(TBaasForm)
    Label3: TLabel;
    EditName: TEdit;
    Label4: TLabel;
    EditContactNumber: TEdit;
    CheckBoxActive: TCheckBox;
    ButtonSave: TButton;
    ButtonCancel: TButton;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
  protected
    procedure SetSelectedItem(const AItem: TBaasItem); override;
  end;


implementation

{$R *.fmx}

{ TFormEditFollowuper }

procedure TFormEditFollowuper.ButtonCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TFormEditFollowuper.ButtonSaveClick(Sender: TObject);
var
  LItem : TFollowuper;
begin
    if FSelectedItem = nil then
        LItem := TFollowuper.Create
    else
        LItem := FSelectedItem as TFollowuper;

    LItem.Name          := EditName.Text;
    LItem.ContactNumber := EditContactNumber.Text;
    LItem.Active        := CheckBoxActive.IsChecked;

    if FSelectedItem = nil then
        FOnUpdateItem(Self, TBaasItemNotifyEventType.Add, LItem)
    else
        FOnUpdateItem(Self, TBaasItemNotifyEventType.Update, LItem);

    Self.Close;
end;

procedure TFormEditFollowuper.SetSelectedItem(const AItem: TBaasItem);
begin
    inherited;
    if AItem <> nil then
    begin
        Self.Caption    := 'Edit Area';
        ButtonSave.Text := 'Update';

        EditName.Text            := (AItem as TFollowuper).Name;
        EditContactNumber.Text   := (AItem as TFollowuper).ContactNumber;
        CheckBoxActive.IsChecked := (AItem as TFollowuper).Active;
    end;
end;

end.
