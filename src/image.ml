
class type image = object

end


class type native_image = object

  method createEmpty : unit -> image Js.t Js.meth

  method createFromPath : Js.js_string Js.t -> image Js.meth

  (* method createFromBuffer *)

  method createFromDataUrl : Js.js_string Js.t -> unit Js.meth

end

let require () : native_image Js.t =
  Nodejs_globals.require "native-image"
