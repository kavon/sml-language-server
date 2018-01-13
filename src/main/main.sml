

structure Main : sig 

    val main : (string * string list) -> OS.Process.status

end = struct

    structure EM = ErrorMsg
    
    (* setup elaborator *)
    structure EvalEntity = EvalEntityFn (structure I = Instantiate)
    structure SigMatch = SigMatchFn (structure EV = EvalEntity)
    structure ElabMod = ElabModFn (structure SM = SigMatch)
    structure ElabTop = ElabTopFn (structure ElabMod = ElabMod)
    
    local 
        val stampGen = Stamps.newGenerator
    in                              
        fun mkCompInfo { source, transform } =
            CompInfo.mkCompInfo { source = source,
                                  transform = transform,
                                  mkMkStamp = stampGen }
                                  
        val say = Control.Print.say
    end

    fun parseAndElab fileName = let
       (* open file *)
        val fileStr = TextIO.openIn fileName
        
        (* setup the source *)
        val source = Source.newSource(fileName, fileStr, false, EM.defaultConsumer ())
        
        (* setup cinfo *)
        val cinfo = mkCompInfo { source = source, transform = fn x => x }
        
        (* get the unchecked (concrete) ast *)
        val ast = SmlFile.parse source
    
        (* setup an empty environment *)
        val loc = EnvRef.loc ()
        val base = EnvRef.base ()
        fun getenv () = Environment.layerEnv (#get loc (), #get base ())
        val {static=statenv, dynamic=NOTUSED, symbolic=symenv} = getenv ()
    in
        doElaborate {ast=ast, statenv=statenv, cinfo=cinfo}
    end
    
    and doElaborate {ast, statenv, cinfo} = let
        val (absyn, nenv) = ElabTop.elabTop(ast, statenv, cinfo)
    in
        if CompInfo.anyErrors cinfo
            then (Absyn.SEQdec nil, StaticEnv.empty)
            else (print "successfuly built AbSyn!\n" ; (absyn, nenv))
    end

    fun main (_, argv) = let
        (* val _ = List.app (fn s => (parseAndElab s ; ())) argv *)
        val sock = Connection.start()
        val _ = Connection.send (sock, JSON.BOOL true)
    in
        OS.Process.success
    end

end
