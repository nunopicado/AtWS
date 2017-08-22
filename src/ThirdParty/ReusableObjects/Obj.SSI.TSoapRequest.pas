unit Obj.SSI.TSoapRequest;

interface

uses
    SoapHTTPTrans
  , Obj.SSI.ISoapRequest
  ;

type
  TSoapRequest = class(THTTPReqResp, ISoapRequest)
  public
    constructor Create(const aURL, aAction: string; BeforePostEvent: TBeforePostEvent; const TimeOut: Word = 12000);
    class function New(const aURL, aAction: string; BeforePostEvent: TBeforePostEvent; const TimeOut: Word = 12000): ISoapRequest;
    function Send(RequestXML: string): string;
  end;


implementation

uses
    Classes
  ;

{ TDTRequest }

constructor TSoapRequest.Create(const aURL, aAction: string;
  BeforePostEvent: TBeforePostEvent; const TimeOut: Word = 12000);
begin
  inherited Create(nil);
  OnBeforePost    := BeforePostEvent;
  URL             := aURL;
  SoapAction      := aAction;
  UseUTF8InHeader := True;
  ConnectTimeout  := TimeOut;
  ReceiveTimeout  := TimeOut;
  SendTimeout     := TimeOut;
end;

class function TSoapRequest.New(const aURL, aAction: string;
  BeforePostEvent: TBeforePostEvent; const TimeOut: Word = 12000): ISoapRequest;
begin
  Result := Create(aURL, aAction, BeforePostEvent);
end;

function TSoapRequest.Send(RequestXML: string): string;
var
  Stream: TStringStream;
begin
  Result := '';
  Stream := TStringStream.Create;
  try
    Execute(RequestXML, Stream);
    Result := Stream.DataString;
  finally
    Stream.Free;
  end;
end;

end.
