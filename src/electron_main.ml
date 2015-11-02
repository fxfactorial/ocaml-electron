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
      m raw_js "on" [|i "on-window-all-closed"; i f|]

    method quit : unit = m raw_js "quit" [||]

    method on_ready (f : (unit -> unit)) : unit =
      m raw_js "on" [|i "ready"; i f|]

  end
end

module Session = struct

  class session raw_js = object

  end

end

module Browser_window = struct

  type browser_opts = {width: int; height : int}

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
      m raw_js "on" [|i (Js.string "did-finish-load"); i f|]

    method on_did_fail_load
        (f : (Events.event -> int -> string -> string -> unit)) : unit =
      m raw_js "on" [|i (Js.string "did-fail-load"); i f|]

    method on_did_frame_finish_load
        (f : (Events.event -> bool -> unit)) : unit =
      m raw_js "on" [|i (Js.string "did-frame-finish-load"); i f|]

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

  end

  class browser_window ?(remote=false) opts = object

    val raw_js =
      match remote with
      | false ->
        (Printf.sprintf
           "new (require(\"browser-window\"))(%s)" (of_opts opts))
        |> Js.Unsafe.eval_string
      |true ->
        (Printf.sprintf
           "new (require(\"remote\").require(\"browser-window\"))(%s)"
           (of_opts opts))
        |> Js.Unsafe.eval_string

    method load_url (s : string) : unit =
      m raw_js "loadUrl" [|i (Js.string s)|]

    method open_dev_tools : unit =
      m raw_js "openDevTools" [||]

    method on_closed (f : (unit -> unit)) : unit =
      m raw_js "on" [|i "closed"; i f|]

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
