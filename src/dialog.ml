class type dialog = object

  method showOpenDialog : unit -> unit Js.meth

end

let require () : dialog Js.t =
  Nodejs_globals.require "dialog"
