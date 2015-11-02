open Nodejs

module type App = sig

  class type app = object
    (* method on_will_finish_launching : (unit -> unit) -> unit *)
    method on_ready : (unit -> unit) -> unit
    method on_window_all_closed : (unit -> unit) -> unit
    (* method on_before_quit : (Events.event -> unit) -> unit *)

    method quit : unit
    method version : string
    method name : string

  end
end

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

module type Browser_window = sig

  type opts = {width: int; height : int}
  class type browser_window = object
    method on_closed : (unit -> unit) -> unit
    method load_url : string -> unit
    method open_dev_tools : unit
  end

end

module Browser_window = struct

  type opts = {width: int; height : int}

  let of_opts
      {width = w;
       height = h} =
    obj_of_alist [("width", i w); ("height", i h)]
    |> stringify

  class browser_window opts = object

    val raw_js =
      (Printf.sprintf
         "new (require(\"browser-window\"))(%s)" (of_opts opts))
      |> Js.Unsafe.eval_string

    method load_url (s : string) : unit =
      m raw_js "loadUrl" [|i (Js.string s)|]

    method open_dev_tools : unit =
      m raw_js "openDevTools" [||]

    method on_closed (f : (unit -> unit)) : unit =
      m raw_js "on" [|i "closed"; i f|]

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

module Session = struct
end

module Web_contents = struct
end

module Tray = struct
end
