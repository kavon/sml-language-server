
(* current implementation uses blocking I/O, and stdin/stdout *)

structure Connection : sig

    type ty
    
    datatype kind
        = StdIO

    val start : kind -> ty
    val stop : ty -> unit
    
    val recv : ty -> JSON.value
    val send : (ty * JSON.value) -> unit

end = struct

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
        
    datatype kind 
        = StdIO

    datatype ty = 
        S of { kind : kind,
               input : TextIO.instream ,
               output : TextIO.outstream }
            
    
    fun start (StdIO) = S { kind = StdIO ,
                            input = TextIO.stdIn ,
                            output = TextIO.stdOut }
                     
    fun stop (S{kind=StdIO,...}) = () (* do nothing. *)
                     
    fun recv (S{input, ...}) = JSONParser.parse input
    
    fun send (S{output, ...}, json) = 
        JSONPrinter.print' {strm = output, pretty = true} json

end
