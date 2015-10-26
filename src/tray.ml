open Nodejs_kit

class type tray = object

  method destroy : unit -> unit Js.meth

  method setImage : Native_image.image Js.t -> unit Js.meth

  (** OS X Only *)
  method setPressedImage : Native_image.image Js.t -> unit Js.meth

  method setToolTip : js_str -> unit Js.meth

  (** OS X Only *)
  method setTitle : js_str -> unit Js.meth

  (** OS X Only *)
  method setHighlightMode : bool -> unit Js.meth

  (** Windows Only *)
  method displayBallon :
    <icon : Native_image.image Js.t;
     title : js_str;
     content : js_str> Js.t ->
    unit Js.meth

  (** OS X & Windows *)
  method popUpContextMenu_withPos :
    <x : int; y: int> Js.t -> unit Js.meth

  method popUpContextMenu :
    unit -> unit Js.meth

  method setContextMenu : Menu.menu Js.t -> unit Js.meth

end

let tray : (Native_image.image -> tray Js.t) Js.constr =
  Js.Unsafe.js_expr "require(\"tray\")"

let require () : tray Js.t = require "tray"
