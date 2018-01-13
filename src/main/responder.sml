

structure Responder : sig

    type t
    
    val new : Connection.socket -> t

end = struct 

    type t = unit

    fun new _ = raise Fail "todo"

end
