open Nodejs_kit

class type shell = object

  (** Show the given file in a file manager. If possible, select the
      file. *)
  method showItemInFolder : js_str -> unit Js.meth

  (** Open the given file in the desktop's default manner.*)
  method openItem : js_str -> unit Js.meth

  (** Open the given external protocol URL in the desktop's default
      manner. (For example, mailto: URLs in the user's default mail
      agent.) *)
  method openExternal : js_str -> unit Js.meth

  (** Move the given file to trash and returns a boolean status for
      the operation. *)
  method moveItemToTrash : js_str -> unit Js.meth

  (** Play the beep sound. *)
  method beep : unit -> unit Js.meth

end

let require () : shell Js.t = require "shell"
