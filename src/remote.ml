
class type remote = object

end




let require () : remote Js.t =
  Nodejs_globals.require "remote"
