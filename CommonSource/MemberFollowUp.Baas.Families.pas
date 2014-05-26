unit MemberFollowUp.Baas.Families;

interface

uses
  System.Generics.Collections, System.SysUtils,
  //  member followup includes...
  MemberFollowUp.Baas.Base;


type
  TFamilyItem = class(TBaasItem)
  strict private
    FName         : String;
    FAreaObjectId : String;
    FHeadName     : String;
    FHomePhone    : String;
    FAddress      : String;
    FSuburb       : String;
    FPostCode     : String;
    FNoHomeVisit  : Boolean;

  protected
    const BackendClassName = 'Families';
    class function BaasClassName: String; override;

    const NameElement         = 'Name';
    const AreaObjectIdElement = 'Area_ObjectId';
    const HeadNameElement     = 'HeadName';
    const HomePhoneElement    = 'HomePhone';
    const AddressElement      = 'Address';
    const SuburbElement       = 'Suburb';
    const PostCodeElement     = 'PostCode';
    const NoHomeVisitElement  = 'NoHomeVisit';
  public
    function FullAddress: String;

    property Name : String read FName write FName;
    property AreaObjectId : String read FAreaObjectId write FAreaObjectId;
    property HeadName : String read FHeadName write FHeadName;
    property HomePhone : String read FHomePhone write FHomePhone;
    property Address : String read FAddress write FAddress;
    property Suburb : String read FSuburb write FSuburb;
    property PostCode : String read FPostCode write FPostCode;
    property NoHomeVisit : Boolean read FNoHomeVisit write FNoHomeVisit;
  end;
  PFamilyItem = ^TFamilyItem;

type
  TFamilyCollection = class(TBaasItemCollection<TFamilyItem>)
  public
    procedure Refresh; override;
  end;


implementation

uses
  REST.Backend.KinveyProvider, REST.Backend.ParseProvider;


{ TFamilyItem }

class function TFamilyItem.BaasClassName: String;
begin
    inherited;
    Result := BackendClassName;
end;

function TFamilyItem.FullAddress: String;
begin
    Result := FAddress;
    if FSuburb.Length > 0 then
        Result := Result +', '+ FSuburb;
    if FPostCode.Length > 0 then
        Result := Result +', '+ FPostCode;

    if Result.Trim.Length  = 0 then
        Result := '[Address Not Specified]';
end;


{ TFamilyCollection }

procedure TFamilyCollection.Refresh;
var
  LQuery : TArray<string>;
begin
    inherited;
    try
        if SameText(FProviderID, TKinveyProvider.ProviderID) then
            LQuery := TArray<string>.Create(Format('sort=%s', [TFamilyItem.NameElement]))
        else if SameText(FProviderID, TParseProvider.ProviderID) then
            LQuery := TArray<string>.Create(Format('order=%s', [TFamilyItem.NameElement]))
        else
            raise Exception.Create('Unknown provider');

        DoLoadItems(LQuery);
    except
        raise;
    end;
end;


end.
