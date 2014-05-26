unit UnitFormFamilyEdit;

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
  MemberFollowUp.Baas.Families;

type
  TFamilyOnNotify = procedure(ASender: TObject; const AItem: TFamilyItem) of object;
//  TFamilyOnUpdateEvent = procedure(ASender: TObject; const AItem: TFamilyItem) of object;

type
  TFormFamilyEdit = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
  private
    FSelectedItem : TFamilyItem;

    FOnAddItem    : TFamilyOnNotify;
    FOnUpdateItem : TFamilyOnNotify;

    procedure SetSelectedItem(const AItem: TFamilyItem);
  public
    property Item : TFamilyItem read FSelectedItem write SetSelectedItem;
    property OnAddItem : TFamilyOnNotify read FOnAddItem write FOnAddItem;
    property OnUpdateItem : TFamilyOnNotify read FOnUpdateItem write FOnUpdateItem;
  end;


implementation

{$R *.fmx}


{ TFormFamilyEdit }

procedure TFormFamilyEdit.FormCreate(Sender: TObject);
begin
    FSelectedItem := nil;
    FOnAddItem    := nil;
    FOnUpdateItem := nil;
end;

procedure TFormFamilyEdit.ButtonSaveClick(Sender: TObject);
var
  LItem : TFamilyItem;
begin
    if FSelectedItem = nil then
        LItem := TFamilyItem.Create
    else
        LItem := FSelectedItem;

    LItem.Name         := EditSurname.Text;
    LItem.HeadName     := EditHeadName.Text;
    LItem.HomePhone    := EditHomePhone.Text;
    LItem.Address      := EditAddress.Text;
    LItem.Suburb       := EditSuburb.Text;
    LItem.PostCode     := EditPostCode.Text;
    LItem.NoHomeVisit  := CheckBoxNoHomeVisit.IsChecked;

    if FSelectedItem = nil then
    begin
        if Assigned(FOnAddItem) then
            FOnAddItem(Self, LItem)
    end else
        if Assigned(FOnUpdateItem) then
            FOnUpdateItem(Self, LItem);

    Self.Close;
end;

procedure TFormFamilyEdit.ButtonCancelClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TFormFamilyEdit.SetSelectedItem(const AItem: TFamilyItem);
begin
    FSelectedItem := AItem;

    Self.Caption    := 'Edit Member Family';
    ButtonSave.Text := 'Update';

    EditSurname.Text              := FSelectedItem.Name;
    EditHeadName.Text             := FSelectedItem.HeadName;
    EditHomePhone.Text            := FSelectedItem.HomePhone;
    EditAddress.Text              := FSelectedItem.Address;
    EditSuburb.Text               := FSelectedItem.Suburb;
    EditPostCode.Text             := FSelectedItem.PostCode;
    CheckBoxNoHomeVisit.IsChecked := FSelectedItem.NoHomeVisit;
end;

end.
