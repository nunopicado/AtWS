unit AtWSvcIntf;

interface

type
  IAtWSvc = interface
  ['{5119FAB4-F5BB-458E-99F0-96CF75F58981}']
    function Send(const XMLData: WideString): WideString;
  end;

implementation

end.
