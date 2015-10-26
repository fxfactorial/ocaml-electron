

class type menu = object

end

let require () : menu Js.t =
  Nodejs_kit.require "menu"
