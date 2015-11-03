(** These modules are allowed in use for both the main process and
    render processes of electron *)

open Nodejs


module Native_image = struct
end

(** The clipboard module provides methods to perform copy and paste
    operations.  *)
module Clipboard = struct

  class clipboard = object

    val raw_js = require_module "clipboard"

    (** Returns the content in the clipboard as plain text. *)
    method read_text typ : string =
      match typ with
      | None -> m raw_js "readText" [||]
      | Some t -> m raw_js "readText" [|i (Js.string t)|]

    (** Writes the text into the clipboard as plain text. *)
    method write_text ?typ text : unit =
      match typ with
      | None -> m raw_js "writeText" [|i (Js.string text)|]
      | Some t -> m raw_js "writeText" [|i (Js.string text); i (Js.string t)|]

    (** Returns the content in the clipboard as markup. *)
    method read_html typ : string =
      (match typ with
      | None -> m raw_js "readHtml" [||]
      | Some t -> m raw_js "readHtml" [|i (Js.string t)|])
      |> Js.to_string

    (** Writes markup to the clipboard. *)
    method write_html typ markup : unit =
      match typ with
      | None -> m raw_js "writeHtml" [|i (Js.string markup)|]
      | Some t -> m raw_js "writeHtml" [|i (Js.string t);
                                         i (Js.string markup)|]

    (* method read_image *)
    (* method write_image *)
    method clear typ : unit =
      match typ with
      | None -> m raw_js "clear" [||]
      | Some t -> m raw_js "clear" [|i (Js.string t)|]

    method available_formats typ : unit =
      match typ with
      | None -> m raw_js "availableFormats" [||]
      | Some t -> m raw_js "availableFormats" [|i (Js.string t)|]

    (* method has *)
    (* method read *)
    (* method write *)

  end

end

module Crash_reporter = struct

  type opts = {product_name : string;
               company_name : string;
               submit_url : string;
               auto_submit : bool ;
               ignore_system_crash_handler : bool;
               (** An object you can define that will be sent along
                   with the report, only string properties are sent
                   correctly and nested objects are not supported. *)
               extra : Js.Unsafe.any; }

  let of_opts
      {product_name = p_name;
       company_name = c_name;
       submit_url = s_uri;
       auto_submit = a_submit;
       ignore_system_crash_handler = ig;
       extra = e} =
    obj_of_alist [("productName", i (Js.string p_name));
                  ("companyName", i (Js.string c_name));
                  ("submitUrl", i (Js.string s_uri));
                  ("autoSubmit", i (Js.bool a_submit));
                  ("ignoreSystemCrashHandler", i (Js.bool ig));
                  ("extra", i e)]

  let default_opts =
    obj_of_alist [("productName", i (Js.string "Electron"));
                  ("companyName", i (Js.string "GitHub, Inc."));
                  ("submitUrl", i (Js.string "http://54.249.141.255:1127/post"));
                  ("autoSubmit", i (Js.bool true));
                  ("ignoreSystemCrashHandler", i (Js.bool false));
                  ("extra", i (obj_of_alist []))]

  class crash_reporter = object

    val raw_js = require_module "crash-reporter"

    method start opts : unit =
      match opts with
      | None -> m raw_js "start" [|i default_opts|]
      | Some o -> m raw_js "start" [|i (of_opts o)|]

    (* method get_last_crash_report =  *)

    (* method get_uploaded_reports =  *)

  end

end


module Screen = struct

  class screen = object

    val raw_js = require_module "screen"

    method on_display_added
        (f : (Events.event -> Js.Unsafe.any -> unit)) : unit =
      m raw_js "on" [|i (Js.string "display-added"); i !@f|]

    method on_display_removed
        (f : (Events.event -> Js.Unsafe.any -> unit)) : unit =
      m raw_js "on" [|i (Js.string "display-removed"); i !@f|]

    (** Emitted when one or more metrics change in a display. The
        array is made up of strings that describe the
        changes. Possible changes are bounds, workArea, scaleFactor
        and rotation.*)
    method on_display_metrics_changed
      (f : (Events.event ->
            Js.Unsafe.any ->
            string Js.js_array-> unit)) : unit =
      m raw_js "on" [|i (Js.string "display-metrics-changed"); i !@f|]

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

    (** Move the given file to trash and returns a boolean status for
        the operation. *)
    method move_item_to_trash (s : string) : bool =
      m raw_js "moveItemToTrash" [|i (Js.string s)|] |> Js.to_bool

    (** Play the beep sound. *)
    method beep : unit =
      m raw_js "beep" [||]

  end

end
