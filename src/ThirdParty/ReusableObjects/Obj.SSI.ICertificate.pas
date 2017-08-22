unit Obj.SSI.ICertificate;

interface

type
  ICertificate = interface
  ['{A90214F2-64DE-49C2-8611-3B235812330A}']
    function AsPCCert_Context: Pointer;
    function ContextSize: Cardinal;
    function IsValid: Boolean;
    function SerialNumber: string;
    function NotAfter: TDateTime;
  end;

implementation

end.
