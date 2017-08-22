unit Obj.SSI.IRSASignature;

interface

type
  TPubKeySource = (pksFile, pksString);

  IRSASignature = interface
  ['{39ABD6BE-F243-48AC-9793-A2599F9C9307}']
    function AsString: string;
  end;

implementation

end.
