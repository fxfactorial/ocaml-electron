(lang dune 3.0)

(name electron)

(license BSD-3-clause)

(authors
 "Edgar Aroutiounnian <edgar.factorial@gmail.com>")

(maintainers
 "Edgar Aroutiounnian <edgar.factorial@gmail.com>")

(source
 (github fxfactorial/ocaml-electron))

(generate_opam_files true)

(package
 (name electron)
 (synopsis "js_of_ocaml bindings for electron")
 (description
   "js_of_ocaml bindings to electron, build electron based
cross-platform applications with all the latest and greatest web
technologies along with the type safety and joy of OCaml.

Use the package electron.main_process for your main processing code
and the package eletron.renderer for your render side code. The root
package electron contains modules allowed in both the main and
renderer processes.")
 (depends
  ocaml
  nodejs
  (js_of_ocaml
   (>= 2.5.2))))
