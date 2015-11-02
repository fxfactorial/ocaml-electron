These are `js_of_ocaml` bindings to [Electron](https://github.com/atom/electron). This is a great way to
write cross platform `OCaml` GUI programs with the latest and greatest
web based technologies.

# Example

This is an electron program built at a hackathon using basecamp's Trix
editor and these bindings.

![img](./electron_working.gif)

The source code for this program is, **main process** first:

```ocaml
 1  open Nodejs
 2  
 3  module B = Electron_main.Browser_window
 4  
 5  let () =
 6    let main_window = ref Js.null in
 7    let app = new Electron_main.App.app in
 8    let p = new process in
 9  
10    Printf.sprintf "Running %s %s on %s" app#name app#version p#platform
11    |> print_endline;
12  
13    app#on_window_all_closed (fun () -> if p#platform <> "darwin" then app#quit);
14  
15    app#on_ready begin fun () ->
16  
17      let b = new B.browser_window B.({width = 800; height = 600}) in
18      main_window := Js.Opt.return b;
19  
20      b#load_url (Printf.sprintf "file://%s/index.html" (__dirname ()));
21  
22      b#on_closed (fun () -> main_window := Js.null )
23  
24    end
```

And the **renderer process**:

```ocaml
 1  let (>>$) = Js.Opt.bind
 2  
 3  module R = Electron_renderer.Remote
 4  
 5  let getElementsByClassName (name : string)
 6    : Dom_html.element Dom.nodeList Js.t =
 7    Js.Unsafe.meth_call
 8      Dom_html.document "getElementsByClassName" [|Js.Unsafe.inject (Js.string name)|]
 9  
10  let renderer_program () =
11    let script = Dom_html.createScript Dom_html.document in
12    script##.src := (Js.string "client/vendor/trix.js");
13    Dom.appendChild Dom_html.document##.head script;
14  
15    let publish_buttons = getElementsByClassName "editor--publish-button" in
16  
17    match Dom.list_of_nodeList publish_buttons with
18    | button :: _ ->
19      Dom_html.CoerceTo.button button >>$ fun b ->
20      Lwt.async begin fun () ->
21        Lwt_js_events.clicks b begin fun ev thread ->
22  
23          let remote =
24            (new R.remote)#browser_window
25              Electron_main.Browser_window.({width = 800; height = 600})
26          in
27          remote#open_dev_tools;
28  
29          Lwt.return ()
30        end
31      end;
32  
33      Js.Opt.return ()
34    | _ -> assert false
35  
36  let () = ignore (renderer_program ())
```

Pretty amazing.
