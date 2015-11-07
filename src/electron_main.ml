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

  let string_of_title_bar = function
    | Default -> "default"
    | Hidden -> "hidden"
    | Hidden_inset -> "hidden-inset"

  (** Settings of web page's features *)
  type web_pref_t =
    { (** Whether node integration is enabled *)
      node_integration : bool option;
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
      javascript : bool option;
      (** When setting false, it will disable the same-origin policy
          (Usually using testing websites by people), and set
          allow_displaying_insecure_content and
          allow_running_insecure_content to true if these two options are
          not set by user. *)
      web_security : bool option;
      (** Allow an https page to display content like images from http
          URLs. *)
      allow_display_insecure_content : bool option;
      (** Allow a https page to run JavaScript, CSS or plugins from
          http URLs. *)
      allow_running_insecure_content : bool option;
      images : bool option;
      java : bool option;
      text_areas_are_resizable : bool option;
      webgl : bool option;
      web_audio : bool option;
      (** Whether plugins should be enabled. *)
      plugins : bool option;
      experimental_features : bool option;
      experimental_canvas_features : bool option;
      overlay_scrollbars : bool option;
      overlay_fullscreen_video : bool option;
      shared_worker : bool option;
      (** Whether the DirectWrite font rendering system on Windows is
          enabled. *)
      direct_write : bool option;
      (** Page would be forced to be always in visible or hidden state
          once set, instead of reflecting current window's
          visibility. Users can set it to true to prevent throttling of
          DOM timers. *)
      page_visibility : bool option; }

  type browser_opts =
    {(** Window's width. *)
      width: int;
      (** Window's height. *)
      height : int;
      (** Window's left offset from screen. *)
      x_offset : int option;
      (** Window's top offset from screen *)
      y_offset : int option;
      (** The width and height would be used as web page's size, which
          means the actual window's size will include window frame's size
          and be slightly larger. *)
      use_content_size : bool option;
      (** Show window in the center of the screen. *)
      center : bool option;
      (** Window's minimum width. *)
      min_width: int option;
      (** Window's minimum height *)
      min_height: int option;
      (** Window's maximum width. *)
      max_width: int option;
      (** Window's maximum height. *)
      max_height : int option;
      (** Whether window is resizable. *)
      resizable : bool option;
      (** Whether the window should always stay on top of other windows. *)
      always_on_top : bool option;
      (** Whether the window should show in fullscreen. When set to
          false the fullscreen button will be hidden or disabled on OS X. *)
      fullscreen : bool option;
      (** Whether to show the window in taskbar. *)
      skip_taskbar : bool option;
      (** The kiosk mode. *)
      kiosk : bool option;
      (** Default window title. *)
      title : string option;
      (** The Icon for the application *)
      icon : string option;
      (** Whether window should be shown when created. *)
      show : bool option;
      (** Specify false to create a Frameless Window. *)
      be_frameless : bool option;
      (** Whether the web view accepts a single mouse-down event that
          simultaneously activates the window. *)
      accept_first_mouse : bool option;
      (**  Whether to hide cursor when typing. *)
      disable_auto_hide_cursor : bool option;
      (** Auto hide the menu bar unless the Alt key is pressed. *)
      auto_hide_menu_bar : bool option;
      (** Enable the window to be resized larger than screen. *)
      enable_larger_than_screen : bool option;
      (** Window's background color as Hexadecimal value, like #66CD00
          or #FFF. This is only implemented on Linux and Windows. *)
      background_color : string option;
      (** Forces using dark theme for the window, only works on some
          GTK+3 desktop environments. *)
      dark_theme : bool option;
      (** Makes the window transparent. *)
      transparent : bool option;
      (**  Specifies the type of the window, this only works on Linux *)
      window_type : window_t option;
      (** Uses the OS X's standard window instead of the textured
          window. *)
      standard_window : bool option;
      (** OS X - specifies the style of window title bar. This option
          is supported on OS X 10.10 Yosemite and newer. *)
      title_bar_style : title_bar_t option;
      (** Settings of web page's features. *)
      web_preferences : web_pref_t option; }

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
       icon = ic;
       show = s;
       be_frameless = f;
       accept_first_mouse = a_f_m;
       disable_auto_hide_cursor = d_a_h_c;
       auto_hide_menu_bar = a_h_m_b;
       enable_larger_than_screen = e_l_t_s;
       background_color = bg_color;
       dark_theme = dt;
       window_type = w_t;
       standard_window = s_w;
       title_bar_style = t_style;
       web_preferences = w_pref;
      } =
    let extract key = function None -> [] | Some g -> [(key, i g)] in
    let extract_str key = function None -> [] | Some g -> [(key, to_js_str g)] in
    let extract_win key = function
      | None -> []
      | Some win -> [(key, to_js_str (string_of_window win))]
    in
    let extract_title key = function
      | None -> []
      | Some t_bar -> [(key, to_js_str (string_of_title_bar t_bar))]
    in
    let extract_web_prefs key = function
      | None -> []
      | Some {node_integration = n; preload = p;
              partition = par; zoom_factor = z;
              javascript = js; web_security = ws;
              allow_display_insecure_content = a_d_i_c;
              allow_running_insecure_content = a_r_i_c;
              images = i; java = j; text_areas_are_resizable = t_a_a_r;
              webgl = gl; web_audio = w_a; plugins = pl;
              experimental_features = e_f;
              experimental_canvas_features = e_c_f;
              overlay_scrollbars = o_s; overlay_fullscreen_video = o_f_v;
              shared_worker = s_w; direct_write = dw;
              page_visibility = pv} ->
        [extract "node-integration" n; extract_str "preload" p;
         extract_str "partition" par; extract "zoom-factor" z;
         extract "javascript" js; extract "web-security" ws;
         extract "allow-displaying-insecure-content" a_d_i_c;
         extract "allow-running-insecure-content" a_r_i_c;
         extract "images" i; extract "java" j;
         extract "text-areas-are-resizable" t_a_a_r; extract "webgl" gl;
         extract "webaudio" w_a; extract "plugins" pl;
         extract "experimental-features" e_f;
         extract "experimental-canvas-features" e_c_f;
         extract "overlay-scrollbars" o_s;
         extract "overlay-fullscreen-video" o_f_v; extract "shared-worker" s_w;
         extract "direct-write" dw; extract "page-visibility" pv]
        |> List.flatten
    in
    [[("width", i w); ("height", i h)];
     extract "x" x; extract "y" y; extract "use-content-size" ucs;
     extract "center" c; extract "min-height" min_h; extract "min-width" min_w;
     extract "max-height" max_h; extract "max-width" max_w;
     extract "resizable" r; extract "always-on-top" a_o_t;
     extract "fullscreen" f_screen; extract "skip-taskbar" sk;
     extract "kiosk" k; extract_str "title" t; extract "show" s;
     extract "frame" f; extract "accept-first-mouse" a_f_m;
     extract "disable-auto-hide-cursor" d_a_h_c; extract "icon" ic;
     extract "auto-hide-menu-bar" a_h_m_b;
     extract "enable-larger-than-screen" e_l_t_s;
     extract "background-color" bg_color;
     extract "dark-theme" dt; extract_win "type" w_t;
     extract "standard-window" s_w; extract_title "title-bar-style" t_style;
     extract_web_prefs "web-preferences" w_pref]
    |> List.flatten |> obj_of_alist
    |> stringify

  let simple_web_prefs =
    {node_integration = Some true; preload = None; partition = None;
     zoom_factor = None; javascript = Some true; web_security = Some true;
     allow_running_insecure_content = None;
     allow_display_insecure_content = None;
     images = Some true; java = Some false; text_areas_are_resizable = Some true;
     webgl = Some false; web_audio = Some false; plugins = Some false;
     experimental_features = Some true; experimental_canvas_features = Some false;
     overlay_scrollbars = None; overlay_fullscreen_video = None;
     shared_worker = None; direct_write = None; page_visibility = None}

  let simple_b_win_opts w h =
    {width = w; height = h; x_offset = None; y_offset = None;
     use_content_size = None; center = None; min_width = None;
     min_height = None; max_width = None; max_height = None;
     resizable = Some true; always_on_top = Some false;
     fullscreen = Some false; skip_taskbar = None;
     kiosk = None; title = None; show = Some true;
     be_frameless = None; accept_first_mouse = None;
     disable_auto_hide_cursor = None; auto_hide_menu_bar = None;
     enable_larger_than_screen = None; icon = None;
     background_color = None; dark_theme = None;
     transparent = None; window_type = None; standard_window = None;
     title_bar_style = None; web_preferences = Some simple_web_prefs}

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
      m raw_js "on" [|to_js_str "closed"; i !@f|]

    method on_close (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "close"; i !@f|]

    method on_unresponsive (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "unresponsive"; i !@f|]

    method on_responsive (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "responsive"; i !@f|]

    method on_blur (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "blur"; i !@f|]

    method on_focus (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "focus"; i !@f|]

    method on_maximize (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "maximize"; i !@f|]

    method on_unmaximize (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "unmaximize"; i !@f|]

    method on_minimize (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "minimize"; i !@f|]

    method on_restore (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "restore"; i !@f|]

    method on_resize (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "resize"; i !@f|]

    method on_move (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "move"; i !@f|]

    method on_movd (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "moved"; i !@f|]

    method on_enter_full_screen (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "enter-full-screen"; i !@f|]

    method on_leave_full_screen (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "leave-full-screen"; i !@f|]

    method on_enter_html_full_screen (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "enter-html-full-screen"; i !@f|]

    method on_leave_html_full_screen (f : (unit -> unit)) : unit =
      m raw_js "on" [|to_js_str "leave-html-full-screen"; i !@f|]

    (* This callback needs to be object wrapped correctly *)
    method on_app_command (f : (Events.event -> string -> unit)) : unit =
      m raw_js "on" [|to_js_str "app-command"; i !@f|]

    method on_page_title_updated (f : (Events.event -> unit)) : unit =
      m raw_js "on" [|to_js_str "page-title-updated"; i !@f|]

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

  let all_windows () =
    let h = require_module "browser-window" in
    m h "getAllWindows" [||] |> Js.to_array
    |> Array.map (fun existing -> new browser_window (Some existing))
    |> Array.to_list

  let focused_window () =
    let h = require_module "browser-window" in
    new browser_window (m h "getFocusedWindow" [||])

  let from_id (j : int) =
    let h = require_module "browser-window" in
    new browser_window (m h "fromId" [|i j|])

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
