
(* current implementation uses blocking I/O, and stdin/stdout *)

structure Connection : sig

    type socket

    val start : unit -> socket
    val stop : socket -> unit
    
    val recv : socket -> JSON.value option
    val send : (socket * JSON.value) -> unit

end = struct

    datatype socket = 
        S of { input : TextIO.instream ,
               output : TextIO.outstream }
            
    
    fun start () = S { input = TextIO.stdIn ,
                     output = TextIO.stdOut }
                     
    fun stop sock = ()  (* TODO close the real socket. *)
                     
    fun recv (S{input, ...}) = SOME (JSONParser.parse input)
    
    fun send (S{output, ...}, json) = 
        JSONPrinter.print' {strm = output, pretty = true} json

end
