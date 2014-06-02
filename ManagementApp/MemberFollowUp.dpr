program MemberFollowUp;

uses
  madExcept,
  FMX.Forms,
  UnitFormEditMemberGroup in 'Source\UnitFormEditMemberGroup.pas' {FormEditMemberGroup},
  UnitFormMain in 'Source\UnitFormMain.pas' {FormMain},
  MemberFollowUp.Baas.MemberGroups in '..\CommonSource\MemberFollowUp.Baas.MemberGroups.pas',
  MemberFollowUp.Baas.Base in '..\CommonSource\MemberFollowUp.Baas.Base.pas',
  MemberFollowUp.Baas.Areas in '..\CommonSource\MemberFollowUp.Baas.Areas.pas',
  MemberFollowUp.Baas.Keys in '..\CommonSource\MemberFollowUp.Baas.Keys.pas',
  MemberFollowUp.Baas.Followupers in '..\CommonSource\MemberFollowUp.Baas.Followupers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
