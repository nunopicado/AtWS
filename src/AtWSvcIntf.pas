(******************************************************************************)
(** Suite         : AtWS                                                     **)
(** Object        : IAtWSvc                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IAtWSvc                                                  **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Sends a XML request to a webservice, and returns its     **)
(**                 response                                                 **)
(******************************************************************************)
(** Licence       : MIT (https://opensource.org/licenses/MIT)                **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**	                terms                                                    **)
(******************************************************************************)

unit AtWSvcIntf;

interface

type
  IAtWSvc = interface
  ['{5119FAB4-F5BB-458E-99F0-96CF75F58981}']
    function Send(const XMLData: WideString): WideString;
  end;

implementation

end.
