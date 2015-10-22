
class type browser_window = object

  method loadUrl : Js.js_string Js.t -> unit Js.meth
  method openDevTools : unit -> unit Js.meth
  method on :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth
end

let browser_window : (<height: int Js.readonly_prop;
                       width: int Js.readonly_prop> Js.t ->
                      browser_window Js.t) Js.constr =
  Js.Unsafe.js_expr "require(\"browser-window\")"

let require () : browser_window Js.t =
  Nodejs_globals.require "browser-window"
