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

  method pause : unit -> unit Js.meth

  method resume : unit -> unit Js.meth

  method cancel : unit -> unit Js.meth

  method getUrl : unit -> Js.js_string Js.t Js.meth

  method getMimeType : unit -> Js.js_string Js.t Js.meth

  method hasUserGesture : unit -> bool Js.meth

  method getFilename : unit -> Js.js_string Js.t Js.meth

  method getTotalBytes : unit -> int Js.meth

  method getReceivedBytes : unit -> int Js.meth

  method getContentDisposition : unit -> Js.js_string Js.t Js.meth

end

class type session = object

  method on_willDownload :
    Js.js_string Js.t ->
    (* TODO Find way to change 'a into web_contents *)
    (Nodejs.Events.event Js.t -> download_item Js.t -> 'a Js.t -> unit) Js.callback ->
    unit Js.meth

  method clearCache : (unit -> unit) Js.callback -> unit Js.meth

  (** Sets download saving directory. By default, the download
      directory will be the Downloads under the respective app
      folder. *)
  method setDownloadPath : Js.js_string Js.t -> unit Js.meth

  method enableNetworkEmulation :
    <offline : bool;
     latency: int;
     downloadThroughput : int;
     uploadThroughput : int> Js.t ->
    unit Js.meth

  method disableNetworkEmulation : unit -> unit Js.meth

end

class type web_contents = object

  method on :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth

  method getUrl : unit -> Js.js_string Js.t Js.meth

  method session : session Js.t Js.readonly_prop

  method getTitle : unit -> Js.js_string Js.t Js.meth

  method isLoading : unit -> bool Js.meth

  method isWaitingForResponse : unit -> bool Js.meth

  method stop : unit -> unit Js.meth

  method reload : unit -> unit Js.meth

  method reloadIgnoringCache : unit -> unit Js.meth

  method canGoBack : unit -> bool Js.meth

  method canGoForard : unit -> bool Js.meth

  method canGoToOffset : int -> bool Js.meth

  method clearHistory : unit -> unit Js.meth

  method goBack : unit -> unit Js.meth

  method goForward : unit -> unit Js.meth

  method goToIndex : int -> unit Js.meth

  method goToOffset : int -> unit Js.meth

  method isCrashed : unit -> bool Js.meth

  method setUserAgent : Js.js_string Js.t -> unit Js.meth

  method getUserAgent : unit -> Js.js_string Js.t Js.meth

  method insertCSS : Js.js_string Js.t -> unit Js.meth

  method executeJavaScript : Js.js_string Js.t -> unit Js.meth

  method executeJavaScript_withBool : Js.js_string Js.t -> bool -> unit Js.meth

  method setAudioMuted : bool -> unit Js.meth

  method isAudioMuted : unit -> bool Js.meth

  method undo : unit -> unit Js.meth

  method redo : unit -> unit Js.meth

  method cut : unit -> unit Js.meth

  method copy : unit -> unit Js.meth

  method paste : unit -> unit Js.meth

  method pasteAndMatchStyle : unit -> unit Js.meth

  method delete : unit -> unit Js.meth

  method selectAll : unit -> unit Js.meth

  method unselect : unit -> unit Js.meth

  method replace : Js.js_string Js.t -> unit Js.meth

  method replaceMisspelling : Js.js_string Js.t -> unit Js.meth

  method print : <silent : bool; printBackground : bool> Js.t -> unit Js.meth

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
