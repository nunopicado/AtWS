unit Obj.SSI.ISoapRequest;

interface

type
  ISoapRequest = interface
  ['{FC51FD4C-35C2-4270-A2A3-8434EBA49DA5}']
    function Send(RequestXML: string): string;
  end;

implementation

end.
