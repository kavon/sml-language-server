

structure Main : sig 

    val main : (string * string list) -> OS.Process.status

end = struct


    fun main _ = (
        print "hello, world!\n" ;
        OS.Process.success)

end
