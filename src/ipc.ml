
class type event = object

  method returnValue : 'a Js.t Js.prop

  method sender : Browser_window.web_contents Js.t Js.readonly_prop

  method send : Js.js_string Js.t -> 'a Js.js_array -> unit Js.meth

end

class type ipc = object

  method on :
    Js.js_string Js.t ->
    (event Js.t -> 'a Js.t -> unit) Js.callback ->
    unit Js.meth

end

let require () : ipc Js.t =
  Nodejs_globals.require "ipc"
