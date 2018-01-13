
(* current implementation uses blocking I/O, and stdin/stdout *)

structure Connection : sig

    type socket

    val start : unit -> socket
    val stop : socket -> unit
    
    val recv : socket -> JSON.value
    val send : (socket * JSON.value) -> unit

end = struct

    (* TODO the transport layer, aka, unix sockets or
       stdin/stdout is not defined by the LSP. Some IDEs
       may use different transport systems. Thus, it is worth
       abstracting this module into a functor so that it works
       regardless of the transport layer.
       
       FWIW: most IDEs use stdin/stdout (Atom) or sockets.
       
       https://github.com/atom/atom-languageclient
    *)

    (* TODO the protocol specifies that a header
       precedes the JSON object. we have to manually
       parse this header from the stream to determine:
       - content length (bytes)
       - encoding, etc.
       to then yank out the JSON object. A header should also
       be prepended to any responses as well.
       
       It seems simple enough to handle the header 
       parsing/insertion directly in this module.
       
       For some examples, see here:
       
       https://github.com/eclipse/lsp4j/tree/026cb14c2218f6e8a9fb1d8464f38b49a9d7177a/org.eclipse.lsp4j.jsonrpc/src/main/java/org/eclipse/lsp4j/jsonrpc/json
       
       In particular, StreamMessageConsumer and StreamMessageProducer.
       
        *)

    datatype socket = 
        S of { input : TextIO.instream ,
               output : TextIO.outstream }
            
    
    fun start () = S { input = TextIO.stdIn ,
                     output = TextIO.stdOut }
                     
    fun stop sock = ()  (* TODO close the real socket. *)
                     
    fun recv (S{input, ...}) = JSONParser.parse input
    
    fun send (S{output, ...}, json) = 
        JSONPrinter.print' {strm = output, pretty = true} json

end
