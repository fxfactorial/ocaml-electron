open Nodejs_kit

class type app = object

  method getVersion : unit -> unit Js.meth
  method quit : unit -> unit Js.meth
  method getName : unit -> unit Js.meth

  method on :
    js_str ->
    (unit -> unit) Js.callback ->
    unit Js.meth

end

let require () : app Js.t = require "app"
