unit MemberFollowUp.Baas.Members;

interface

uses
  System.Generics.Collections, System.SysUtils,
  //  member followup includes...
  MemberFollowUp.Baas.Base;


type
  TMember = class(TBaasItem)
  strict private
    FName                : String;
    FMemberGroupObjectId : String;
    FSurname             : String;
    FMobilePhone         : String;
    FDateOfBirth         : String;
    FEmailAddress        : String;
    FYearSpiritFilled    : String;

  protected
    const BackendClassName = 'Members';
    class function BaasClassName: String; override;

    const NameElement                = 'Name';
    const MemberGroupObjectIdElement = 'MemberGroup_ObjectId';
    const SurnameElement             = 'Surname';
    const MobilePhoneElement         = 'MobilePhone';
    const DateOfBirthElement         = 'DateOfBirth';
    const EmailAddressElement        = 'EmailAddress';
    const YearSpiritFilledElement    = 'YearSpiritFilled';

  public

    property Name : String read FName write FName;
    property MemberGroup_ObjectId : String read FMemberGroupObjectId write FMemberGroupObjectId;
    property Surname : String read FSurname write FSurname;
    property MobilePhone : String read FMobilePhone write FMobilePhone;
    property DateOfBirth : String read FDateOfBirth write FDateOfBirth;
    property EmailAddress : String read FEmailAddress write FEmailAddress;
    property YearSpiritFilled : String read FYearSpiritFilled write FYearSpiritFilled;
  end;

type
  TMembersCollection = class(TBaasItemCollection<TMember>)
  public
    procedure Refresh; override;
  end;


 implementation

 uses
  REST.Backend.KinveyProvider, REST.Backend.ParseProvider;


{ TMembers }

class function TMember.BaasClassName: String;
begin
    inherited;
    Result := BackendClassName;
end;


{ TMembersCollection }

procedure TMembersCollection.Refresh;
var
  LQuery : TArray<string>;
begin
    inherited;
    try
        if SameText(FProviderID, TKinveyProvider.ProviderID) then
            LQuery := TArray<string>.Create(Format('sort=%s', [TMember.NameElement]))
        else if SameText(FProviderID, TParseProvider.ProviderID) then
            LQuery := TArray<string>.Create(Format('order=%s', [TMember.NameElement]))
        else
            raise Exception.Create('Unknown provider');

        DoLoadItems(LQuery);
    except
        raise;
    end;
end;

end.
