unit MemberFollowUp.Baas.Followupers;

interface

uses
  System.Generics.Collections, System.SysUtils,
  //  member followup includes...
  MemberFollowUp.Baas.Base;


type
  TFollowuper = class(TBaasItem)
  strict private
    FName          : String;
    FContactNumber : String;
    FActive        : Boolean;

  protected
    const BackendClassName = 'Followupers';
    class function BaasClassName: String; override;

    const NameElement      = 'name';
    const ContactNumberElement = 'contactNumber';
    const ActiveElement        = 'active';
  public
    property Name : String read FName write FName;
    property ContactNumber : String read FContactNumber write FContactNumber;
    property Active : Boolean read FActive write FActive;
  end;

type
  TFollowuperCollection = class(TBaasItemCollection<TFollowuper>)
  public
    procedure Refresh; override;
  end;


implementation

uses
  REST.Backend.KinveyProvider, REST.Backend.ParseProvider;


{ TFollowuper }

class function TFollowuper.BaasClassName: String;
begin
    inherited;
    Result := BackendClassName;
end;



{ TFollowuperCollection }

procedure TFollowuperCollection.Refresh;
var
  LQuery : TArray<string>;
begin
    inherited;
    try
        if SameText(FProviderID, TKinveyProvider.ProviderID) then
            LQuery := TArray<string>.Create(Format('sort=%s', [TFollowuper.NameElement]))
        else if SameText(FProviderID, TParseProvider.ProviderID) then
            LQuery := TArray<string>.Create(Format('order=%s', [TFollowuper.NameElement]))
        else
            raise Exception.Create('Unknown provider');

        DoLoadItems(LQuery);
    except
        raise;
    end;
end;

end.
