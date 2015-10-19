let () =
  let app = Electron.App.require () in
  (* let b = Electron.Browser_window.require () in *)
  let main_window = ref Js.null in
  app##on
    (Js.string "window-all-closed")
    (Js.wrap_callback begin fun () ->
        if (Js.to_string Nodejs.Process.process##.platform) <> "darwin"
           then app##quit ()
      end);
  app##on
    (Js.string "ready")
    (Js.wrap_callback begin fun () ->

        main_window := Js.Opt.return (
            (* Hack but useful, not sure how to bind this object yet *)
            Js.Unsafe.eval_string
              "(function(){var brow = require(\"browser-window\");\
               return new brow({width:800, height:600});})()");

        let main_window_now =
          Js.Opt.get !main_window (fun () -> assert false)
        in

        main_window_now##loadUrl
          (Js.string "file:///Users/Edgar/Repos/\
                      ocaml-electron/examples/index.html");
        main_window_now##openDevTools ();

        main_window_now##on
          (Js.string "closed")
          (Js.wrap_callback begin fun () ->
              main_window := Js.null
          end)

      end)
