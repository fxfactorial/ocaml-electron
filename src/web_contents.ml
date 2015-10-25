class type web_contents = object

  (* method on_finishLoad : *)
  method on :
    Js.js_string Js.t ->
    (unit -> unit) Js.callback ->
    unit Js.meth

  method getUrl : unit -> Js.js_string Js.t Js.meth

  (* method toString : unit -> Js.js_string Js.t Js.meth *)

  (* method on_didFailLoad : *)
  (*   Js.js_string Js.t -> *)
  (*   ('a Js.t -> *)
  (*    int -> *)
  (*    Js.js_string Js.t -> *)
  (*    Js.js_string Js.t -> unit) Js.callback -> *)
  (*   unit Js.meth *)

end
