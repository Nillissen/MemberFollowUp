unit UnitFormEditArea;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit,
  //  member followup includes...
  MemberFollowUp.Baas.Base,
  MemberFollowUp.Baas.Areas;

type
  TFormEditArea = class(TBaasForm)
    ButtonSave: TButton;
    EditName: TEdit;
    Label3: TLabel;
    ButtonCancel: TButton;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
  protected
    procedure SetSelectedItem(const AItem: TBaasItem); override;
  end;


implementation

{$R *.fmx}

{ TFormEditArea }

procedure TFormEditArea.ButtonCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TFormEditArea.ButtonSaveClick(Sender: TObject);
var
  LItem : TAreaItem;
begin
    if FSelectedItem = nil then
        LItem := TAreaItem.Create
    else
        LItem := FSelectedItem as TAreaItem;

    LItem.Name := EditName.Text;

    if FSelectedItem = nil then
        FOnUpdateItem(Self, TBaasItemNotifyEventType.Add, LItem)
    else
        FOnUpdateItem(Self, TBaasItemNotifyEventType.Update, LItem);

    Self.Close;
end;

procedure TFormEditArea.SetSelectedItem(const AItem: TBaasItem);
begin
    inherited;
    if AItem <> nil then
    begin
        Self.Caption    := 'Edit Area';
        ButtonSave.Text := 'Update';

        EditName.Text := (AItem as TAreaItem).Name;
    end;
end;

end.
