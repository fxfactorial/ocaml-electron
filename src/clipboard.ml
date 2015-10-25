
class type clipboard = object

  method readText : unit -> Js.js_string Js.t Js.meth

  method readText_withType :
    Js.js_string Js.t -> Js.js_string Js.t Js.meth

  method writeText : Js.js_string Js.t -> unit Js.meth

  method writeText_withType :
    Js.js_string Js.t -> Js.js_string Js.t -> unit Js.meth

  method readHtml : unit -> Js.js_string Js.t Js.meth

  method readHtml_withType:
    Js.js_string Js.t -> Js.js_string Js.t Js.meth

end

let require () : clipboard Js.t =
  Nodejs_kit.require "dialog"
