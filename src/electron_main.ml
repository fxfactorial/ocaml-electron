
module Electron = struct

  include Electron

  module App = struct
    include App
  end

  module Browser_window = struct
    include Browser_window
  end

  module Power_monitor = struct
    include Power_monitor
  end
end
