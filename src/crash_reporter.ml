class type crash_reporter = object

  (** You are required to call this method before using other
      crashReporter APIs. *)
  method start :
    <productName : Js.js_string Js.t;
     companyName : Js.js_string Js.t;
     submitUrl   : Js.js_string Js.t;
     autoSubmit  : bool;
     ignoreSystemCrashHandler : bool;
     (** An Object with only string properties, no nesting *)
     extra : 'a Js.t> Js.t ->
    unit Js.meth

  (* TODO Find out what it does give back in actual crash *)
  method getLastCrashReport : unit -> 'a Js.Opt.t Js.meth

  (* TODO Find out what this actually gives back, an array!? *)
  method getUploadedReports : unit -> 'a Js.js_array Js.meth

end

let require () : crash_reporter Js.t =
  Nodejs_globals.require "crash-reporter"
