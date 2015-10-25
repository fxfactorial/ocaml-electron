class type download_item = object

  method on_updated :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth

  method on_done :
    Js.js_string Js.t ->
    (** The second argument can be one of "completed", "cancelled", or
        "interrupted" *)
    (Nodejs.Events.event -> Js.js_string Js.t -> unit) Js.callback ->
    unit Js.meth

  method setSavePath :
    Js.js_string Js.t ->
    unit Js.meth

end

class type session = object

  method on_willDownload :
    Js.js_string Js.t ->
    (* TODO Find way to change 'a into web_contents *)
    (Nodejs.Events.event Js.t -> download_item Js.t -> 'a Js.t -> unit) Js.callback ->
    unit Js.meth

end

class type web_contents = object

  method on :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth

  method getUrl : unit -> Js.js_string Js.t Js.meth

  method session : session Js.t Js.readonly_prop

end

class type browser_window = object

  method loadUrl : Js.js_string Js.t -> unit Js.meth

  method openDevTools : unit -> unit Js.meth

  method webContents : web_contents Js.t Js.readonly_prop

  method on :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth

end

let browser_window : (<height: int Js.readonly_prop;
                       width: int Js.readonly_prop> Js.t ->
                      browser_window Js.t) Js.constr =
  Js.Unsafe.js_expr "require(\"browser-window\")"

let require () : browser_window Js.t =
  Nodejs_globals.require "browser-window"
