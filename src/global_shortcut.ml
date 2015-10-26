
(** Accelerator An accelerator is a string that represents a keyboard
    shortcut. It can contain multiple modifiers and key codes, combined by
    the + character.

    Examples:

    Command+A
    Ctrl+Shift+Z
    Platform notice

    On Linux and Windows, the Command key does not have any effect so
    use CommandOrControl which represents Command on OS X and Control
    on Linux and Windows to define some accelerators.

    The Super key is mapped to the Windows key on Windows and Linux
    and Cmd on OS X.

    Available modifiers:

    Command (or Cmd for short)
    Control (or Ctrl for short)
    CommandOrControl (or CmdOrCtrl for short)
    Alt
    Shift
    Super

    Available key codes:

    0 to 9
    A to Z
    F1 to F24
    Punctuations like ~, !, @, #, $, etc.
    Plus
    Space
    Backspace
    Delete
    Insert
    Return (or Enter as alias)
    Up, Down, Left and Right
    Home and End
    PageUp and PageDown
    Escape (or Esc for short)
    VolumeUp, VolumeDown and VolumeMute
    MediaNextTrack, MediaPreviousTrack, MediaStop and MediaPlayPause *)
type accelerator = Js.js_string Js.t

class type shortcut = object

  method register :
    accelerator ->
    (unit -> unit) Js.callback ->
    unit Js.meth

  method isRegistered : accelerator -> bool Js.meth

  method unregister : accelerator -> unit Js.meth

  method unregisterAll : unit -> unit Js.meth

end


let require () : shortcut Js.t =
  Nodejs_kit.require "global-shortcut"
