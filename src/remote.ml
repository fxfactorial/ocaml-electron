class type remote = object

  (** Returns the object returned by require(module) in the main
      process. *)
  method require : Js.js_string Js.t -> 'a Js.t Js.meth

  method getCurrentWindow : unit -> Browser_window.browser_window Js.t Js.meth

  method getCurrentWebContents : unit -> Browser_window.web_contents Js.t Js.meth

  (** Returns the global variable of name (e.g. global[name]) in the
      main process. *)
  method getGlobal : Js.js_string Js.t -> 'a Js.t Js.meth

  (** Returns the process object in the main process. This is the same
      as remote.getGlobal('process') but is cached. *)
  method process : Nodejs.Process.process Js.readonly_prop

end

let require () : remote Js.t =
  Nodejs_globals.require "remote"
