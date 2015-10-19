
class type browser_window = object

  method loadUrl : Js.js_string Js.t -> unit Js.meth
  method openDevTools : unit -> unit Js.meth
  method on :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth
end

(* Hack but useful, not sure how to bind this object yet *)
let make width height : browser_window Js.t =
  Js.Unsafe.eval_string
    (Printf.sprintf "(function(){var brow = require(\"browser-window\");\
                     return new brow({width:%d, height:%d});})()" width height)

let require () : browser_window Js.t =
  Nodejs_globals.require "browser-window"
