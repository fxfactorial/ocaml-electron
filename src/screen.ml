
(* err, where are the docs for this object? *)
class type display = object

  method id : int Js.readonly_prop

end

class type screen = object

  method getCursorScreenPoint : unit -> <x : int; y : int> Js.t Js.meth
  method getPrimaryDisplay : unit -> display Js.t Js.meth
  method getAllDisplays : unit -> display Js.js_array Js.meth
  method getDisplayNearestPoint : <x : int; y : int> Js.t -> display Js.t Js.meth
  method getDisplayMatching :
    <x : int; y : int; width : int; height : int> Js.t ->
    display Js.t Js.meth

end

let require () : screen Js.t =
  Nodejs_globals.require "screen"
