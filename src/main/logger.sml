

structure Logger : sig

    val setEnabled : bool -> unit

    (* does _not_ output an additional newline. *)
    val out : string -> unit
    
    (* outputs a newline at the end. *)
    val outLn : string -> unit
    
    val out1 : char -> unit

end = struct
    
    val enabled = ref false
    val logFile : TextIO.outstream option ref = ref NONE
    
    fun openLog () = TextIO.openAppend "server.log"
    
    
    (* public interface *)
    
    fun out s = 
        if !enabled
            then TextIO.output(valOf (!logFile), s)
            else ()
            
    fun out1 c =
        if !enabled
            then TextIO.output1(valOf (!logFile), c)
            else ()
            
    fun outLn s = (out s; out1 #"\n")
    
    fun setEnabled flag = (
        enabled := flag ; 
        
        (* open if needed *)
        (case (flag, !logFile)
            of (true, NONE) => logFile := SOME (openLog ())
             | _            => ()
            (* end case *)) ;
        
        out "\n-- logging enabled --\n"
        )

end
