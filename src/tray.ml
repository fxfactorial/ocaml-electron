class type tray = object

  method destroy : unit -> unit Js.meth

  method setImage : Image.image Js.t -> unit Js.meth

  (** OS X Only *)
  method setPressedImage : Image.image Js.t -> unit Js.meth

  method setToolTip : Js.js_string Js.t -> unit Js.meth

  (** OS X Only *)
  method setTitle : Js.js_string Js.t -> unit Js.meth

  (** OS X Only *)
  method setHighlightMode : bool -> unit Js.meth

  (** Windows Only *)
  method displayBallon :
    <icon : Image.image Js.t;
     title : Js.js_string Js.t;
     content : Js.js_string Js.t> Js.t ->
    unit Js.meth

  (** OS X & Windows *)
  method popUpContextMenu_withPos :
    <x : int; y: int> Js.t -> unit Js.meth

  method popUpContextMenu :
    unit -> unit Js.meth

  method setContextMenu : Menu.menu Js.t -> unit Js.meth

end

let tray : (Image.image -> tray Js.t) Js.constr =
  Js.Unsafe.js_expr "require(\"tray\")"

let require () : tray Js.t =
  Nodejs_globals.require "tray"
