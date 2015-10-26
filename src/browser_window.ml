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

  (** Force closing the window, the unload and beforeunload event
      won't be emitted for the web page, and close event will also not be
      emitted for this window, but it guarantees the closed event will be
      emitted.

      You should only use this method when the renderer process (web
      page) has crashed.*)
  method destroy : unit -> unit Js.meth

  (** Try to close the window, this has the same effect with user
      manually clicking the close button of the window. The web page may
      cancel the close though, see the close event.*)
  method close : unit -> unit Js.meth

  (** Focus on the window. *)
  method focus : unit -> unit Js.meth

  method isFocused : unit -> bool Js.meth

  (** Shows and gives focus to the window. *)
  method show : unit -> unit Js.meth

  (** Shows the window but doesn't focus on it. *)
  method showInactive : unit -> unit Js.meth

  (** Hide the window. *)
  method hide : unit -> unit Js.meth

  (** Whether the window is visible to the user. *)
  method isVisible : unit -> bool Js.meth

  (** Focus on the window. *)
  method maximize : unit -> unit Js.meth

  (** Focus on the window. *)
  method unmaximize : unit -> unit Js.meth

  (** Focus on the window. *)
  method isMaximized : unit -> bool Js.meth

  (** Minimizes the window. On some platforms the minimized window
      will be shown in the Dock. *)
  method minimize : unit -> unit Js.meth

  (** Restores the window from minimized state to its previous state. *)
  method restore : unit -> unit Js.meth

  method isMinimized : unit -> bool Js.meth

  (** Sets whether the window should be in fullscreen mode. *)
  method setFullScreen : bool -> unit Js.meth

  (** OS X Only : This will have a window maintain an aspect
      ratio. The extra size allows a developer to have space,
      specified in pixels, not included within the aspect ratio
      calculations. This API already takes into account the difference
      between a window's size and its content size.

      Consider a normal window with an HD video player and associated
      controls. Perhaps there are 15 pixels of controls on the left
      edge, 25 pixels of controls on the right edge and 50 pixels of
      controls below the player. In order to maintain a 16:9 aspect
      ratio (standard aspect ratio for HD @1920x1080) within the
      player itself we would call this function with arguments of 16/9
      and [ 40, 50 ]. The second argument doesn't care where the extra
      width and height are within the content view--only that they
      exist. Just sum any extra width and height areas you have within
      the overall content view. *)
  method setAspectRatio :
    float -> <width : int; height : int> Js.t -> unit Js.meth

  method setBounds :
    <width : int; height : int; x : int; y : int> Js.t ->
    unit Js.meth

  method getBounds :
    unit ->
    <width : int; height : int; x : int; y : int> Js.t Js.meth

  method setSize : int -> int -> unit Js.meth

  method getSize : unit -> int Js.js_array Js.meth

  method setContentSize : int -> int -> unit Js.meth

  method getContentSize : unit -> int Js.js_array Js.meth

  method setMinimumSize : int -> int -> unit Js.meth

  method getMinimumSize : unit -> int Js.js_array Js.meth

  method setMaximumSize : int -> int -> unit Js.meth

  method getMaximumSize : unit -> int Js.js_array Js.meth

  method setResizable : bool -> unit Js.meth

  method isResizable : unit -> bool Js.meth

  (** Sets whether the window should show always on top of other
      windows. After setting this, the window is still a normal window,
      not a toolbox window which can not be focused on. *)
  method setAlwaysOnTop : bool -> unit Js.meth

  method isAlwaysOnTop : unit -> bool Js.meth

  (** Moves window to the center of the screen. *)
  method center : unit -> unit Js.meth

  method setPosition : int -> int -> unit Js.meth

  method getPosition : unit -> int Js.js_array Js.meth

  method setTitle : Js.js_string Js.t -> unit Js.meth

  method getTitle : unit -> Js.js_string Js.t Js.meth

  (** Starts or stops flashing the window to attract user's attention. *)
  method flashFrame : bool -> unit Js.meth

  (** Makes the window not show in the taskbar. *)
  method setSkipTaskbar : bool -> unit Js.meth

end

let browser_window : (<height: int Js.readonly_prop;
                       width: int Js.readonly_prop> Js.t ->
                      browser_window Js.t) Js.constr =
  Js.Unsafe.js_expr "require(\"browser-window\")"

let require () : browser_window Js.t =
  Nodejs_kit.require "browser-window"
