unit Obj.SSI.TZDate;

interface

uses
    Obj.SSI.IZDate
  , Obj.SSI.ISNTPTime
  , Obj.SSI.IValue
  ;

type
  TZDate = class(TInterfacedObject, IZDate)
  private
    FTZInfo: string;
    FSNTPTime: ISNTPTime;
    FZDate: IString;
    function GetZDate: string;
  public
    constructor Create(const TimeZoneInfo: string; const SNTPTime: ISNTPTime);
    class function New(const TimeZoneInfo: string; const SNTPTime: ISNTPTime): IZDate;
    function AsString: string;
  end;

implementation

uses
    Obj.SSI.TValue
  , Soap.XSBuiltIns
  , DateUtils
  , TZDB
  ;

{ TZDate }

function TZDate.AsString: string;
begin
  Result := FZDate.Value;
end;

constructor TZDate.Create(const TimeZoneInfo: string; const SNTPTime: ISNTPTime);
begin
  FTZInfo   := TimeZoneInfo;
  FSNTPTime := SNTPTime;
  FZDate    := TString.New(GetZDate);
end;

function TZDate.GetZDate: string;
var
  XSDate : TXSDatetime;
  TZ     : TTimeZone;
begin
  TZ := TBundledTimeZone.GetTimeZone(FTZInfo);
  XSDate := TXSDatetime.Create;
  try
    XSDate.AsUTCDateTime := TZ.ToUniversalTime(FSNTPTime.Now.Value);
  finally
    Result := XSDate.NativeToXS;
    XSDate.Free;
  end;
end;

class function TZDate.New(const TimeZoneInfo: string; const SNTPTime: ISNTPTime): IZDate;
begin
  Result := Create(TimeZoneInfo, SNTPTime);
end;

end.
