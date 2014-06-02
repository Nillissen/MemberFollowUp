unit MemberFollowUp.Baas.Base;

interface

uses
  System.Generics.Collections, System.SysUtils,
  REST.Backend.MetaTypes, REST.Backend.ServiceComponents, REST.Backend.ServiceTypes,
  REST.Backend.KinveyProvider, REST.Backend.ParseProvider;


type
  TBaasItem = class(TObject)
  protected
    class function BaasClassName: String; virtual; abstract;
  end;

type
  TBaasItemCollection<TValue: TBaasItem, constructor> = class
  private
    FProviderId     : string;
    FBackendStorage : TBackendStorage;
    FBackendList    : TBackendObjectList<TValue>;

  protected
    procedure DoLoadItems(const AQuery: TArray<string>);

  public
    constructor Create(const AProviderID: string; const ABackendStorage: TBackendStorage);
    destructor Destroy; override;

    procedure Refresh; virtual; abstract;

    procedure AddBackendItem(const AItem: TValue);
    procedure UpdateBackendItem(const AItem: TValue);
    procedure DeleteBackendItem(const AItem: TValue);

    function GetEnumerator: TEnumerator<TValue>;
  end;

type
  TBassItemNotifyEventType = (Add, Update, Delete);
type
  TBaasItemNotify = procedure(ASender: TObject; const EventType: TBassItemNotifyEventType; const AItem: TBaasItem) of object;


implementation


{ TBaasItemCollection }

constructor TBaasItemCollection<TValue>.Create(const AProviderID: string; const ABackendStorage: TBackendStorage);
begin
    FProviderId     := AProviderID;
    FBackendStorage := ABackendStorage;
    FBackendList    := TBackendObjectList<TValue>.Create;
end;

destructor TBaasItemCollection<TValue>.Destroy;
begin
    FBackendList.Free;
    inherited;
end;

procedure TBaasItemCollection<TValue>.DoLoadItems(const AQuery: TArray<string>);
var
  LItemList: TBackendObjectList<TValue>;
begin
    LItemList := TBackendObjectList<TValue>.Create;
    try
        FBackendStorage.Storage.QueryObjects<TValue>(TValue.BaasClassName, AQuery, LItemList);
        FBackendList.Free;
        FBackendList := LItemList;
    except
        LItemList.Free;
        raise;
    end;
end;

procedure TBaasItemCollection<TValue>.AddBackendItem(const AItem: TValue);
var
  LEntity: TBackendEntityValue;
begin
    FBackendStorage.Storage.CreateObject<TValue>(TValue.BaasClassName, AItem, LEntity);
    FBackendList.Add(AItem, LEntity);
end;

procedure TBaasItemCollection<TValue>.DeleteBackendItem(const AItem: TValue);
var
  LEntity : TBackendEntityValue;
begin
    LEntity := FBackendList.EntityValues[AItem];
    FBackendStorage.Storage.DeleteObject(LEntity);
end;

procedure TBaasItemCollection<TValue>.UpdateBackendItem(const AItem: TValue);
var
  LEntity: TBackendEntityValue;
  LUpdate: TBackendEntityValue;
begin
    LEntity := FBackendList.EntityValues[AItem];
    FBackendStorage.Storage.UpdateObject<TValue>(LEntity, AItem, LUpdate);
end;

function TBaasItemCollection<TValue>.GetEnumerator: TEnumerator<TValue>;
begin
    Result := FBackendList.GetEnumerator;
end;

end.
