
class type browser_window = object

  method call : 'a Js.t -> browser_window Js.t Js.meth
  method loadUrl : Js.js_string Js.t -> unit Js.meth
  method openDevTools : unit -> unit Js.meth
  method on :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth
end

(* let browser_window_new width height : browser_window Js.t = *)
(*   Js.Unsafe.eval_string *)
(*     "new ((require(\"browser-window\"))({width: 800, height: 600}))" *)
  (* Js.Unsafe.global##_BrowserWindow *)

let require () : browser_window Js.t =
  Nodejs_globals.require "browser-window"
