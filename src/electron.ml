(** These modules are allowed in use for both the main process and
    render processes of electron *)

open Nodejs

module Clipboard = struct
end

module Crash_reporter = struct
end

module Native_image = struct
end

module Screen = struct

  class screen = object

    val raw_js = require_module "screen"

    method on_display_added
        (f : (Events.event -> Js.Unsafe.any -> unit)) : unit =
      m raw_js "on" [|i (Js.string "display-added"); i f|]

    method on_display_removed
        (f : (Events.event -> Js.Unsafe.any -> unit)) : unit =
      m raw_js "on" [|i (Js.string "display-removed"); i f|]

    (** Emitted when one or more metrics change in a display. The
        array is made up of strings that describe the
        changes. Possible changes are bounds, workArea, scaleFactor
        and rotation.*)
    method on_display_metrics_changed
      (f : (Events.event ->
            Js.Unsafe.any ->
            string Js.js_array-> unit)) : unit =
      m raw_js "on" [|i (Js.string "display-removed"); i f|]

    method get_cursor_screen_point : <x : int; y : int> =
      let rect = m raw_js "getCursorScreenPoint" [||] in
      object method x = rect <!> "x" method y = rect <!> "y" end

  end

end

(** The shell module provides functions related to desktop
    integration.*)
module Shell = struct

  class shell = object

    val raw_js = require_module "shell"

    (** Show the given file in a file manager. If possible, select the
        file. *)
    method show_item_in_folder (s : string) : unit =
      m raw_js "showItemInFolder" [|i (Js.string s)|]

    (** Open the given file in the desktop's default manner. *)
    method show_item (s : string) : unit =
      m raw_js "openItem" [|i (Js.string s)|]

    (** Open the given external protocol URL in the desktop's default
        manner. (For example, mailto: URLs in the user's default mail
        agent.) *)
    method open_external (s : string) : unit =
      m raw_js "openExternal" [|i (Js.string s)|]

    method move_item_to_trash (s : string) : unit =
      m raw_js "moveItemToTrash" [|i (Js.string s)|]

    method beep : unit =
      m raw_js "beep" [||]

  end

end
