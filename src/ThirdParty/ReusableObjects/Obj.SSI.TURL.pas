unit Obj.SSI.TURL;

interface

uses
    Obj.SSI.IURL
  , Obj.SSI.IValue
  ;

type
  TURL = class(TInterfacedObject, IURL)
  private
    FURL: string;
    FIsValid: IBoolean;
    function DoCheckURL: Boolean;
  public
    constructor Create(const URL: string);
    class function New(const URL: string): IURL;
    function IsValid: Boolean;
  end;

implementation

uses
    Obj.SSI.TValue
  , WinINet
  ;

{ TURL }

constructor TURL.Create(const URL: string);
begin
  FURL     := URL;
  FIsValid := TBoolean.New(DoCheckURL);
end;

function TURL.DoCheckURL: Boolean;
var
  hSession,
  hFile     : hInternet;
  dwIndex,
  dwCodeLen : Cardinal;
  dwCode    : array [1..20] of Char;
  Res       : PChar;
begin
  Result   := False;
  hSession := InternetOpen('InetURL:/1.0', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(hSession) then begin
    hFile     := InternetOpenUrl(hSession, PChar(FURL), nil, 0, INTERNET_FLAG_RELOAD, 0);
    dwIndex   := 0;
    dwCodeLen := 10;
    HttpQueryInfo(hFile, HTTP_QUERY_STATUS_CODE, @dwCode, dwCodeLen, dwIndex);
    Res       := PChar(@dwCode);
    Result    := (Res = '200') or (Res = '302');
    if assigned(hFile) then
      InternetCloseHandle(hFile);
    InternetCloseHandle(hSession);
  end;
end;

function TURL.IsValid: Boolean;
begin
  Result := FIsValid.Value;
end;

class function TURL.New(const URL: string): IURL;
begin
  Result := Create(URL);
end;

end.
