

structure Responder : sig
    
    val begin : Connection.socket -> unit

end = struct 


    fun handleReq (req, env) = 
        (SOME(JSON.STRING "--> implement handler"), ())

    fun mainLoop sock = let
        fun nextRequest env = let
            val req = Connection.recv sock
            val (response, env') = handleReq (req, env)
        in (
            (* TODO: responses are always required. *)
            (case response
                of SOME msg => Connection.send (sock, msg)
                 | NONE     => ()
             (* end case *))
             ;
             nextRequest env'
            )
        end
    in
        nextRequest ()
    end

    fun begin sock = mainLoop sock
    
    
end
