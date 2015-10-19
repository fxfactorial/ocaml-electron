# pkgs := nodejs,socket_io,express

pkgs := electron

# Do not use it breaks the script, very odd!
define colorecho
      @tput setaf 6
      @echo $1
      @tput sgr0
endef

run:all clean
	electron .

all:
	@ocamlfind ocamlc mvp.ml -package $(pkgs) -linkpkg
	@js_of_ocaml --debug-info --pretty a.out -o mvp.js
	@echo "Compiled"

clean:
	@rm -f mvp.cmi mvp.cmo mvp.cmt a.out

.PHONY:clean
