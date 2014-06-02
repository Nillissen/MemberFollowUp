unit MemberFollowUp.Baas.Keys;

interface

{$include 'Source\ApplicationSettings.inc'}

{ WARNING: DO NOT INCLUDE THIS IN THE REPOSITORY COMMITS THIS IS YOUR APPLICATION SPECIFIC SETTINGS }

{$IFDEF PARSE}
type
  TApplicationKeys = record
//    public const PROVIDER_ID   = 'Parse';
    public const APPLICATIONID = 'xC5gDkiH6d3gjlmoU8PeowZiND4PxF3oOwuOEP2w';
    public const RESTAPIKEY    = 'MiVqXaD5TMac355FZDOEpaDksVCdHRcXtxEt21WK';
  end;
{$ENDIF}

{$IFDEF KINVEY}
type
  TApplicationKeys = record
//    public const PROVIDER_ID   = 'Kinvey';
    public const APPLICATIONID = '';
    public const MASTERKEY     = '';
  end;
{$ENDIF}


implementation

end.
