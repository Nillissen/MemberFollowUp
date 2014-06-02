unit MemberFollowUp.Baas.MemberGroups;

interface

uses
  System.Generics.Collections, System.SysUtils,
  //  member followup includes...
  MemberFollowUp.Baas.Base, REST.Backend.MetaTypes;


type
  TMemberGroup = class(TBaasItem)
  strict private
    FName        : String;
    FAreaObject  : TBackendMetaObject;
    FHeadName    : String;
    FHomePhone   : String;
    FAddress     : String;
    FSuburb      : String;
    FPostCode    : String;
    FNoHomeVisit : Boolean;

  protected
    const BackendClassName = 'MemberGroups';
    class function BaasClassName: String; override;

    const NameElement         = 'name';
    const AreaObjectIdElement = 'area_ObjectId';
    const HeadNameElement     = 'headName';
    const HomePhoneElement    = 'homePhone';
    const AddressElement      = 'address';
    const SuburbElement       = 'suburb';
    const PostCodeElement     = 'postCode';
    const NoHomeVisitElement  = 'noHomeVisit';
  public
    function FullAddress: String;

    property Name : String read FName write FName;
    property AreaObject : TBackendMetaObject read FAreaObject write FAreaObject;
    property HeadName : String read FHeadName write FHeadName;
    property HomePhone : String read FHomePhone write FHomePhone;
    property Address : String read FAddress write FAddress;
    property Suburb : String read FSuburb write FSuburb;
    property PostCode : String read FPostCode write FPostCode;
    property NoHomeVisit : Boolean read FNoHomeVisit write FNoHomeVisit;
  end;

type
  TMemberGroupCollection = class(TBaasItemCollection<TMemberGroup>)
  public
    procedure Refresh; override;
  end;


implementation

uses
  REST.Backend.KinveyProvider, REST.Backend.ParseProvider;


{ TMemberGroup }

class function TMemberGroup.BaasClassName: String;
begin
    inherited;
    Result := BackendClassName;
end;

function TMemberGroup.FullAddress: String;
begin
    Result := FAddress;
    if FSuburb.Length > 0 then
        Result := Result +', '+ FSuburb;
    if FPostCode.Length > 0 then
        Result := Result +', '+ FPostCode;

    if Result.Trim.Length  = 0 then
        Result := '[Address Not Specified]';
end;


{ TMemberGroupCollection }

procedure TMemberGroupCollection.Refresh;
var
  LQuery : TArray<string>;
begin
    inherited;

    if SameText(FProviderID, TKinveyProvider.ProviderID) then
        LQuery := TArray<string>.Create(Format('sort=%s', [TMemberGroup.NameElement]))
    else if SameText(FProviderID, TParseProvider.ProviderID) then
        LQuery := TArray<string>.Create(Format('order=%s', [TMemberGroup.NameElement]))
    else
        raise Exception.Create('Unknown provider');

    DoLoadItems(LQuery);
end;


end.
