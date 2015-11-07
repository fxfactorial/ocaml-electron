(** These are modules mainly intended for usage from the main
    process *)

open Nodejs

module App = struct

  class app = object
    val raw_js = require_module "app"

    method version : string =
      m raw_js "getVersion" [||] |> Js.to_string

    method name : string =
      m raw_js "getName" [||] |> Js.to_string


    method on_window_all_closed (f : (unit -> unit)) : unit =
      m raw_js "on" [|i "on-window-all-closed"; i !@f|]

    method quit : unit = m raw_js "quit" [||]

    method on_ready (f : (unit -> unit)) : unit =
      m raw_js "on" [|i "ready"; i !@f|]

  end
end

module Session = struct

  class cookies raw_js = object

    method name =
      raw_js <!> "name" |> Js.to_string

    method value =
      raw_js <!> "value" |> Js.to_string

    method domain =
      raw_js <!> "domain" |> Js.to_string

    method host_only =
      raw_js <!> "host_only" |> Js.to_string

    method path =
      raw_js <!> "path" |> Js.to_string

    method secure =
      raw_js <!> "secure" |> Js.to_bool

    method http_only =
      raw_js <!> "http_only" |> Js.to_bool

    method session =
      raw_js <!> "session" |> Js.to_bool

    method expiration_date =
      raw_js <!> "expirationDate" |> Js.to_float

  end

  type details = {url : string;
                  name : string;
                  domain : string;
                  path : string;
                  secure : bool;
                  session : bool;
                  callback : (Error.error -> cookies -> unit);
                  error : Error.error;
                  cookies : cookies array; }

  class download_item = object end

  class session raw_js = object

    (* not sure how to do this mutually recurisve issue...session
       needed in browser_window but web_contents needed in session *)
    (* method on_will_download (f : (Events.event -> download_item)) *)

    (* method cookies_get :  *)
  end

end

module Browser_window = struct

  type window_t = Desktop | Dock | Toolbar | Splash | Notification

  (** OS X - specifies the style of window title bar. This option is
      supported on OS X 10.10 Yosemite and newer. *)
  type title_bar_t =
    (** standard gray opaque Mac title bar. *)
      Default
    (** results in a hidden title bar and a full size content window,
        yet the title bar still has the standard window controls ("traffic
        lights") in the top left. *)
    | Hidden
    (** results in a hidden title bar with an alternative look where
        the traffic light buttons are slightly more inset from the window
        edge. *)
    | Hidden_inset

  let string_of_window = function
    | Desktop -> "desktop"
    | Dock -> "dock"
    | Toolbar -> "toolbar"
    | Splash -> "splash"
    | Notification -> "notification"

  (** Settings of web page's features *)
  type web_pref_t =
    { (** Whether node integration is enabled *)
      node_integration : bool;
      (** Specifies a script that will be loaded before other scripts
          run in the page. This script will always have access to node APIs no
          matter whether node integration is turned on for the page, and the
          path of preload script has to be absolute path.*)
      preload : string option;
      (** Sets the session used by the page. If partition starts with
          persist:, the page will use a persistent session available to
          all pages in the app with the same partition. if there is no
          persist: prefix, the page will use an in-memory session. By
          assigning the same partition, multiple pages can share the same
          session. If the partition is None then default session of the
          app will be used. *)
      partition : string option;
      (** The default zoom factor of the page, 3.0 represents 300%. *)
      zoom_factor : float option;
      javascript : bool;
      (** When setting false, it will disable the same-origin policy
          (Usually using testing websites by people), and set
          allow_displaying_insecure_content and
          allow_running_insecure_content to true if these two options are
          not set by user. *)
      web_security : bool;
      (** Allow an https page to display content like images from http
          URLs. *)
      allow_display_insecure_content : bool;
      (** Allow a https page to run JavaScript, CSS or plugins from
          http URLs. *)
      allow_running_insecure_content : bool;
      images : bool;
      java : bool;
      text_areas_are_resizable : bool;
      webgl : bool;
      web_audio : bool;
      (** Whether plugins should be enabled. *)
      plugins : bool;
      experimental_features : bool;
      experimental_canvas_features : bool;
      overlay_scrollbars : bool;
      overlay_fullscreen_video : bool;
      shared_worker : bool;
      (** Whether the DirectWrite font rendering system on Windows is
          enabled. *)
      direct_write : bool;
      (** Page would be forced to be always in visible or hidden state
          once set, instead of reflecting current window's
          visibility. Users can set it to true to prevent throttling of
          DOM timers. *)
      page_visibility : bool; }


  type browser_opts =
    {(** Window's width. *)
      width: int;
      (** Window's height. *)
      height : int;
      (** Window's left offset from screen. *)
      x_offset : int;
      (** Window's top offset from screen *)
      y_offset : int;
      (** The width and height would be used as web page's size, which
          means the actual window's size will include window frame's size
          and be slightly larger. *)
      use_content_size : bool;
      (** Show window in the center of the screen. *)
      center : bool;
      (** Window's minimum width. *)
      min_width: int;
      (** Window's minimum height *)
      min_height: int;
      (** Window's maximum width. *)
      max_width: int;
      (** Window's maximum height. *)
      max_height : int;
      (** Whether window is resizable. *)
      resizable : bool;
      (** Whether the window should always stay on top of other windows. *)
      always_on_top : bool;
      (** Whether the window should show in fullscreen. When set to
          false the fullscreen button will be hidden or disabled on OS X. *)
      fullscreen : bool;
      (** Whether to show the window in taskbar. *)
      skip_taskbar : bool;
      (** The kiosk mode. *)
      kiosk : bool;
      (** Default window title. *)
      title : string;
      (* icon : Electron.Native *)
      (** Whether window should be shown when created. *)
      show : bool;
      (** Specify false to create a Frameless Window. *)
      be_frameless : bool;
      (** Whether the web view accepts a single mouse-down event that
          simultaneously activates the window. *)
      accept_first_mouse : bool;
      (**  Whether to hide cursor when typing. *)
      disable_auto_hide_cursor : bool;
      (** Auto hide the menu bar unless the Alt key is pressed. *)
      auto_hide_menu_bar : bool;
      (** Enable the window to be resized larger than screen. *)
      enable_larger_than_screen : bool;
      (** Window's background color as Hexadecimal value, like #66CD00
          or #FFF. This is only implemented on Linux and Windows. *)
      background_color : string;
      (** Forces using dark theme for the window, only works on some
          GTK+3 desktop environments. *)
      dark_theme : bool;
      (** Makes the window transparent. *)
      transparent : bool;
      (**  Specifies the type of the window, this only works on Linux *)
      window_type : window_t;
      (** Uses the OS X's standard window instead of the textured
          window. *)
      standard_window : bool;
      (** OS X - specifies the style of window title bar. This option
          is supported on OS X 10.10 Yosemite and newer. *)
      title_bar_style : title_bar_t;
      (** Settings of web page's features. *)
      web_preferences : web_pref_t; }

  type url_opts = { http_referrer : string;
                    user_agent : string;
                    extra_headers : string list; }

  let of_opts
      {width = w;
       height = h;
       x_offset = x;
       y_offset = y;
       use_content_size = ucs;
       center = c;
       min_height = min_h;
       min_width = min_w;
       max_width = max_w;
       max_height = max_h;
       resizable = r;
       always_on_top = a_o_t;
       fullscreen = f_screen;
       skip_taskbar = sk;
       kiosk = k;
       title = t;
       (* icon = i *)
       show = s;
       be_frameless = f;
      } =
    obj_of_alist [("width", i w); ("height", i h); ("x", i x);
                  ("y", i y); ("use-content-size", i ucs);
                  ("center", i c); ("min-width", i min_w);
                  ("min-height", i min_h); ("max-width", i max_w);
                  ("max-height", i max_h); ("resizable", i r);
                  ("always-on-top", i a_o_t); ("fullscreen", i f_screen);
                  ("skip-taskbar", i sk); ("kiosk", i k);
                  ("title", to_js_str t); ("show", i s); ("frame", i f);
                 ]
    |> stringify

  class web_contents raw_js = object

    method on_did_finish_load (f : (unit -> unit)) : unit =
      m raw_js "on" [|i (Js.string "did-finish-load"); i !@f|]

    method on_did_fail_load
        (f : (Events.event -> int -> string -> string -> unit)) : unit =
      m raw_js "on" [|i (Js.string "did-fail-load"); i !@f|]

    method on_did_frame_finish_load
        (f : (Events.event -> bool -> unit)) : unit =
      m raw_js "on" [|i (Js.string "did-frame-finish-load"); i !@f|]

    (* method on_did_start_loading :  *)

    (* method on_did_stop_loading :  *)

    (* method on_did_get_response_details:  *)

    (* method on_did_get_redirect_request :  *)

    (* method on_dom_ready :  *)

    (* method on_page_favicon_updated :  *)

    (* method on_new_window  *)

    (* method on_will_navigate  *)

    (* method on_crashed  *)

    (* method on_plugin_crashed *)

    (* method on_destroyed:  *)

    (* method on_devtools_opened *)

    (* method on_devtools_closed : *)

    (* method on_devtools_focused  *)

    (* method on_login  *)

    method session : Session.session =
      new Session.session raw_js <!> "session"

    method load_url ?opts url : unit =
      match opts with
      | None -> m raw_js "loadUrl" [|i (Js.string url)|]
      | Some {http_referrer = r;
              user_agent = a;
              extra_headers = h} ->
        let obj = obj_of_alist [("httpReferrer", r);
                                ("userAgent", a);
                                ("extraHeaders", String.concat "\n" h)] in
        m raw_js "loadUrl" [|i (Js.string url); i obj|]

    method get_url =
      m raw_js "getUrl" [||] |> Js.to_string

    method get_title =
      m raw_js "getTitle" [||] |> Js.to_string

    method is_loading =
      m raw_js "isLoading" [||] |> Js.to_bool

    method is_waiting_for_response =
      m raw_js "isWaitingForResponse" [||] |> Js.to_bool

    method stop : unit =
      m raw_js "stop" [||]

    method reload : unit =
      m raw_js "reload" [||]

    method reload_ignoring_cache : unit =
      m raw_js "reloadIgnoringCache" [||]

    method can_go_back =
      m raw_js "canGoBack" [||] |> Js.to_bool

    method can_go_forward =
      m raw_js "canGoForward" [||] |> Js.to_bool

    method can_go_to_offset (j : int) =
      m raw_js "canGoToOffset" [|i j|] |> Js.to_bool

    method clear_history : unit =
      m raw_js "clearHistory" [||]

    method go_back : unit =
      m raw_js "goBack" [||]

    method go_forward : unit =
      m raw_js "goForward" [||]

    method go_to_index (j : int) : unit =
      m raw_js "goToIndex" [|i j|]

    method go_to_offset (j : int) : unit =
      m raw_js "goToOffset" [|i j|]

    method is_crashed =
      m raw_js "isCrashed" [||] |> Js.to_bool

    method set_user_agent (s : string) : unit =
      m raw_js "setUserAgent" [|i (Js.string s)|]

    method get_user_agent =
      m raw_js "getUserAgent" [||] |> Js.to_string

    method insert_css (css : string) : unit =
      m raw_js "insertCss" [|i (Js.string css)|]

    method execute_javascript
        ?(user_gesture : bool option)
        (code : string) : unit =
      match user_gesture with
      | None -> m raw_js "executeJavaScript" [|i (Js.string code)|]
      | Some b -> m raw_js "executeJavaScript" [|i (Js.string code); i b|]

    method set_audio_muted (b : bool) : unit =
      m raw_js "setAudioMuted" [|i b|]

    method is_audio_muted : bool =
      m raw_js "isAudioMuted" [||] |> Js.to_bool

    method undo : unit =
      m raw_js "undo" [||]

    method redo : unit =
      m raw_js "redo" [||]

    method cut : unit =
      m raw_js "cut" [||]

    method copy : unit =
      m raw_js "copy" [||]

    method paste : unit =
      m raw_js "paste" [||]

    method paste_and_match_style : unit =
      m raw_js "pasteAndMatchStyle" [||]

    method delete : unit =
      m raw_js "delete" [||]

    method select_all : unit =
      m raw_js "selectAll" [||]

    method unselect : unit =
      m raw_js "unselect" [||]

    method replace (s : string) : unit =
      m raw_js "replace" [|i (Js.string s)|]

  end

  class browser_window ?(remote=false) ?opts existing = object

    val raw_js =
      let result = match opts with
        | None -> ""
        | Some o -> "(" ^ of_opts o ^ ")"
      in
      match existing with
      | None ->
        (match remote with
         | false ->
           (Printf.sprintf
              "new (require(\"browser-window\"))%s" result)
           |> Js.Unsafe.eval_string
         |true ->
           (Printf.sprintf
              "new (require(\"remote\").require(\"browser-window\"))%s" result)
           |> Js.Unsafe.eval_string)
      | Some e -> e

    method load_url (s : string) : unit = m raw_js "loadUrl" [|i (Js.string s)|]

    method open_dev_tools : unit = m raw_js "openDevTools" [||]

    method on_closed (f : (unit -> unit)) : unit =
      m raw_js "on" [|i "closed"; i !@f|]

    method web_contents : web_contents =
      new web_contents (raw_js <!> "webContents")

    method id : int = raw_js <!> "id"

    (** Force closing the window, the unload and beforeunload event
        won't be emitted for the web page, and close event will also not
        be emitted for this window, but it guarantees the closed event
        will be emitted.

        You should only use this method when the renderer process (web
        page) has crashed.*)
    method destory : unit = m raw_js "destroy" [||]

    (** Try to close the window, this has the same effect with user
        manually clicking the close button of the window. The web page may
        cancel the close though, see the close event.*)
    method close : unit = m raw_js "close" [||]

    method focus : unit = m raw_js "focus" [||]

    method is_focused : bool = m raw_js "isFocused" [||]

    method show : unit = m raw_js "show" [||]

    method show_inactive : unit = m raw_js "showInactive" [||]

    method hide : unit = m raw_js "hide" [||]

    method is_visible : bool = m raw_js "isVisible" [||]

    method maximize : unit = m raw_js "maximize" [||]

    method unmaximize : unit = m raw_js "unmaximize" [||]

    method is_maximized : bool = m raw_js "unmaximize" [||]

    method minimize : unit = m raw_js "minimize" [||]

    method set_fullscreen b : unit =
      if b then m raw_js "setFullScreen" [|i true|]
      else m raw_js "setFullScreen" [|i false|]

    method is_fullscreen : bool = m raw_js "isFullScreen" [||]

    method set_title s : unit = m raw_js "setTitle" [|to_js_str s|]

    method title = m raw_js "getTitle" [||] |> Js.to_string

    method flash_frame b : unit =
      if b then m raw_js "flashFrame" [|i true|]
      else m raw_js "flashFrame" [|i false|]
  end

end

module Auto_updater = struct
end

module Content_tracing = struct
end

module Dialog = struct
end

module Global_shortcut = struct
end

module Ipc_main = struct
end

module Menu = struct
end

module Power_monitor = struct
end

module Power_save_blocker = struct
end

module Protocol = struct
end


module Web_contents = struct
end

module Tray = struct
end
