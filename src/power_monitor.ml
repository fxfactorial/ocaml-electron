class type power_monitor = object

  method on_suspend :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth

  method on_resume :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth

  method on_ac :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth

  method on_battery :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth

end

let require () : power_monitor Js.t =
  Nodejs_kit.require "power-monitor"
