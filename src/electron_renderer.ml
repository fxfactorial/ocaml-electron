(** These are modules intended for usage from the renderer process,
    aka your actual page *)

open Nodejs

module B = Electron_main.Browser_window

module Ipc_renderer = struct

end

module Remote = struct

  type b_opts = Electron_main.Browser_window.opts

  class remote = object

    val raw_js = require_module "remote"

    method browser_window (o : b_opts) = new B.browser_window ~remote:true o

    (* method get_current_window :  *)

    (* method get_current_web_contents  *)

    method get_global (s : string) : Js.Unsafe.any =
      m raw_js "getGlobal" [|i (Js.string s)|]

    method process : process =
      raw_js <!> "process"

  end
end

module Web_frame = struct

end
