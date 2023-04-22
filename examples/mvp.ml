open Js_of_ocaml
open Nodejs

let () =
  let app = new Electron_main.App.app in
  let main_window = ref Js.null in

  (*
  let proc = new process in
  app#on_window_all_closed (fun () -> if proc#platform <> Darwin then app#quit);
*)

  app#on_ready
    (fun () ->
       main_window :=
         Js.Opt.return (new Electron_main.Browser_window.browser_window None);

    let main_window_now =
      Js.Opt.get !main_window (fun () -> assert false)
    in

    main_window_now#load_url
         (Printf.sprintf "file://%s/index.html" (Js.to_string @@ __dirname ()));

    main_window_now#open_dev_tools;

    main_window_now#on_closed (fun () -> main_window := Js.null))
