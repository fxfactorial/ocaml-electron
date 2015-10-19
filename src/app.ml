class type app = object

  method quit : unit -> unit Js.meth

  method on :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth

end

let require () : app Js.t =
  Nodejs_globals.require "app"
