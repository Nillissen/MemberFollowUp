unit MemberFollowUp.Baas.Areas;

interface

uses
  System.Generics.Collections, System.SysUtils,
  //  member followup includes...
  MemberFollowUp.Baas.Base;


type
  TAreaItem = class(TBaasItem)
  strict private
    FName : String;

  protected
    const BackendClassName = 'Areas';
    class function BaasClassName: String; override;

    const NameElement = 'Name';
  public
    property Name : String read FName write FName;
  end;

type
  TAreaCollection = class(TBaasItemCollection<TAreaItem>)
  public
    procedure Refresh; override;
  end;


implementation

uses
  REST.Backend.KinveyProvider, REST.Backend.ParseProvider;


{ TAreaItem }

class function TAreaItem.BaasClassName: String;
begin
    inherited;
    Result := BackendClassName;
end;



{ TAreaCollection }

procedure TAreaCollection.Refresh;
var
  LQuery : TArray<string>;
begin
    inherited;
    try
        if SameText(FProviderID, TKinveyProvider.ProviderID) then
            LQuery := TArray<string>.Create(Format('sort=%s', [TAreaItem.NameElement]))
        else if SameText(FProviderID, TParseProvider.ProviderID) then
            LQuery := TArray<string>.Create(Format('order=%s', [TAreaItem.NameElement]))
        else
            raise Exception.Create('Unknown provider');

        DoLoadItems(LQuery);
    except
        raise;
    end;
end;


end.
