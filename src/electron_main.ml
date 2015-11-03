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

  type browser_opts = { width: int;
                        height : int; }

  type url_opts = { http_referrer : string;
                    user_agent : string;
                    extra_headers : string list; }

  let of_opts
      {width = w;
       height = h} =
    obj_of_alist [("width", i w); ("height", i h)]
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

    method load_url (s : string) : unit =
      m raw_js "loadUrl" [|i (Js.string s)|]

    method open_dev_tools : unit =
      m raw_js "openDevTools" [||]

    method on_closed (f : (unit -> unit)) : unit =
      m raw_js "on" [|i "closed"; i !@f|]

    method web_contents : web_contents =
      new web_contents (raw_js <!> "webContents")

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
