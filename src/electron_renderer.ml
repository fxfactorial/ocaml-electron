open Nodejs

module Ipc_renderer = struct

end

module Remote = struct


  class remote = object

    val raw_js = require_module "remote"

    method browser_window (o : Electron_main.Browser_window.opts) =
      new Electron_main.Browser_window.browser_window ~remote:true o

  end
end



module Web_frame = struct

end
