

structure Main : sig 

    val main : (string * string list) -> OS.Process.status

end = struct

    fun parse fileName = let
        val fileStr = TextIO.openIn fileName
        
        (* setup the file *)
        val source = Source.newSource(fileName, fileStr, false, ErrorMsg.defaultConsumer ())
        
        (* get the unchecked (concrete) ast *)
        val ast = SmlFile.parse source
    in
        (print "parse successful!\n" ; Source.closeSource source)
    end

    fun main (_, argv) = (List.app parse argv ; OS.Process.success)
end
