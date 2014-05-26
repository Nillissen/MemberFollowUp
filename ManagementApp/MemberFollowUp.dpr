program MemberFollowUp;

uses
  FMX.Forms,
  UnitFormFamilyEdit in 'Source\UnitFormFamilyEdit.pas' {FormFamilyEdit},
  UnitFormMain in 'Source\UnitFormMain.pas' {FormMain},
  MemberFollowUp.Baas.Families in '..\CommonSource\MemberFollowUp.Baas.Families.pas',
  MemberFollowUp.Baas.Base in '..\CommonSource\MemberFollowUp.Baas.Base.pas',
  MemberFollowUp.Baas.Areas in '..\CommonSource\MemberFollowUp.Baas.Areas.pas',
  MemberFollowUp.Baas.Keys in '..\CommonSource\MemberFollowUp.Baas.Keys.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
