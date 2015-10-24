class type dialog = object

  (* Not correct *)
  method showOpenDialog : unit -> 'a Js.js_array Js.meth

  method showErrorBox : Js.js_string Js.t -> Js.js_string Js.t -> unit Js.meth

end

let require () : dialog Js.t =
  Nodejs_globals.require "dialog"
