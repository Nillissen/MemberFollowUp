unit MemberFollowUp.Baas.Base;

interface

uses
  System.Generics.Collections, System.Classes, System.SysUtils,
  FMX.Forms,
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
    FBackendList    : TBackendObjectList<TValue>;

  protected
    FProviderId     : string;
    FBackendStorage : TBackendStorage;

    procedure DoLoadItems(const AQuery: TArray<string>);

  public
    constructor Create(const AProviderID: string; const ABackendStorage: TBackendStorage);
    destructor Destroy; override;

    procedure Refresh; virtual; abstract;

    procedure AddBackendItem(const AItem: TBaasItem);
    procedure UpdateBackendItem(const AItem: TBaasItem);
    procedure DeleteBackendItem(const AItem: TBaasItem);

    function GetObjectId(AItem: TBaasItem): string;
    function Count: Cardinal;
    function GetEnumerator: TEnumerator<TValue>;
  end;

type
  TBaasItemNotifyEventType = (Add, Update, Delete);
type
  TBaasItemNotify = procedure(ASender: TObject; const EventType: TBaasItemNotifyEventType; const AItem: TBaasItem) of object;

type
  TBaasForm = class(TForm)
  protected
    FSelectedItem : TBaasItem;
    FOnUpdateItem : TBaasItemNotify;

    function GetSelectedItem: TBaasItem;
    procedure SetSelectedItem(const AItem: TBaasItem); virtual;
  public
    constructor Create(AOwner: TComponent); override;

    property Item : TBaasItem read GetSelectedItem write SetSelectedItem;
    property OnUpdateItem : TBaasItemNotify read FOnUpdateItem write FOnUpdateItem;
  end;


implementation

uses
  MemberFollowUp.Baas.Keys;


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

procedure TBaasItemCollection<TValue>.AddBackendItem(const AItem: TBaasItem);
var
  LEntity: TBackendEntityValue;
begin
    FBackendStorage.Storage.CreateObject<TValue>(TValue.BaasClassName, AItem, LEntity);
    FBackendList.Add(AItem, LEntity);
end;

procedure TBaasItemCollection<TValue>.UpdateBackendItem(const AItem: TBaasItem);
var
  LEntity: TBackendEntityValue;
  LUpdate: TBackendEntityValue;
begin
    LEntity := FBackendList.EntityValues[AItem];
    FBackendStorage.Storage.UpdateObject<TValue>(LEntity, AItem, LUpdate);
end;

procedure TBaasItemCollection<TValue>.DeleteBackendItem(const AItem: TBaasItem);
var
  LEntity : TBackendEntityValue;
begin
    LEntity := FBackendList.EntityValues[AItem];
    FBackendStorage.Storage.DeleteObject(LEntity);
end;

function TBaasItemCollection<TValue>.GetEnumerator: TEnumerator<TValue>;
begin
    Result := FBackendList.GetEnumerator;
end;


function TBaasItemCollection<TValue>.GetObjectId(AItem: TBaasItem): string;
var
  LEntity : TBackendEntityValue;
begin
    LEntity := FBackendList.EntityValues[AItem];
    Result := LEntity.ObjectID;
end;

function TBaasItemCollection<TValue>.Count: Cardinal;
begin
    Result := FBackendList.Count;
end;

{ TBaasForm }

constructor TBaasForm.Create(AOwner: TComponent);
begin
    inherited;
    FSelectedItem := nil;
    FOnUpdateItem := nil;
end;

function TBaasForm.GetSelectedItem: TBaasItem;
begin
    Result := FSelectedItem;
end;

procedure TBaasForm.SetSelectedItem(const AItem: TBaasItem);
begin
    FSelectedItem := AItem;
end;

end.
