(** These modules are allowed in use for both the main process and
    render processes of electron *)

module Clipboard = struct
  include Clipboard
end

module Crash_reporter = struct
  include Crash_reporter
end

module Native_image = struct
  include Native_image
end

module Screen = struct
  include Screen
end

module Shell = struct
  include Shell
end
