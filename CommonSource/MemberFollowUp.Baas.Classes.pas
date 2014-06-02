unit MemberFollowUp.Baas.Classes;

interface

uses
  REST.Backend.ParseProvider, REST.Backend.KinveyProvider, REST.Backend.ServiceComponents,

  MemberFollowUp.Baas.Base,
  MemberFollowUp.Baas.Areas,
  MemberFollowUp.Baas.Followupers,
  MemberFollowUp.Baas.Members,
  MemberFollowUp.Baas.MemberGroups;

{$include 'Source\ApplicationSettings.inc'}

type
  TMemberFollowUpClasses = class
  strict private
    {$IFDEF PARSE}
    FBaasProvider   : TParseProvider;
    {$ENDIF}
    {$IFDEF KINVEY}
    FBaasProvider   : TKinveyProvider;
    {$ENDIF}
    FBackendStorage : TBackendStorage;

    FAreas          : TAreaCollection;
    FMemberGroups   : TMemberGroupCollection;
    FFollowupers    : TFollowuperCollection;
    FMembers        : TMembersCollection;

    class var _Instance : TMemberFollowUpClasses;
    class destructor ClassDestroy;
  public
    constructor Create;
    destructor Destroy; override;

    class function GetInstance: TMemberFollowUpClasses;

    property Areas: TAreaCollection read FAreas;
    property MemberGroups: TMemberGroupCollection read FMemberGroups;
    property Followupers: TFollowuperCollection read FFollowupers;
    property Members: TMembersCollection read FMembers;
  end;


implementation

uses
  MemberFollowUp.Baas.Keys;


{ TMemberFollowUpClasses }

class destructor TMemberFollowUpClasses.ClassDestroy;
begin
    if _Instance <> nil then
        _Instance.Free;
end;

constructor TMemberFollowUpClasses.Create;
begin
    {$IFDEF PARSE}
    FBaasProvider := TParseProvider.Create(nil);
    FBaasProvider.ApplicationID := TApplicationKeys.APPLICATIONID;
    FBaasProvider.RestApiKey    := TApplicationKeys.RESTAPIKEY;
    {$ENDIF}

    {$IFDEF KINVEY}
    FBaasProvider := TKinveyProvider.Create(nil);
    FBaasProvider.AppKey       := //TODO;
    FBaasProvider.MasterSecret := //TODO;
    {$ENDIF}

    FBackendStorage := TBackendStorage.Create(nil);
    FBackendStorage.Provider := FBaasProvider;

    FAreas        := TAreaCollection.Create(FBaasProvider.ProviderID, FBackendStorage);
    FMemberGroups := TMemberGroupCollection.Create(FBaasProvider.ProviderID, FBackendStorage);
    FFollowupers  := TFollowuperCollection.Create(FBaasProvider.ProviderID, FBackendStorage);
    FMembers      := TMembersCollection.Create(FBaasProvider.ProviderID, FBackendStorage);
end;

destructor TMemberFollowUpClasses.Destroy;
begin
    FMembers.Free;
    FFollowupers.Free;
    FMemberGroups.Free;
    FAreas.Free;
    inherited;
end;

class function TMemberFollowUpClasses.GetInstance: TMemberFollowUpClasses;
begin
     if _Instance = nil then
        _Instance := TMemberFollowUpClasses.Create;
    Result := _Instance;
end;

end.
