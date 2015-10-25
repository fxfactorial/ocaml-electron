
(** The role property can have following values:
    undo
    redo
    cut
    copy
    paste
    selectall
    minimize - Minimize current window
    close - Close current window

    On OS X role can also have following additional values:

    about - Map to the orderFrontStandardAboutPanel action
    hide - Map to the hide action
    hideothers - Map to the hideOtherApplications action
    unhide - Map to the unhideAllApplications action
    front - Map to the arrangeInFront action
    window - The submenu is a "Window" menu
    help - The submenu is a "Help" menu
    services - The submenu is a "Services" menu *)
type role = Js.js_string Js.t

class type menu = object

end

class type menu_item = object

end

let menu_item :
  (<click : (menu_item -> Browser_window.browser_window -> unit) Js.callback;
    role : role;
    (* Not sure how to do this now, cause type is OCaml keyword *)
    (* type : Js.js_string Js.t; *)
    label : Js.js_string Js.t;
    sublabel : Js.js_string Js.t;
    accelerator: Shortcut.accelerator;
    (* icon : Electron.Image.native_image; *)

   > Js.t ->
   menu_item Js.t) Js.constr =
  Js.Unsafe.js_expr "require(\"menu-item\")"

let require () : menu Js.t =
  Nodejs_kit.require "menu"
