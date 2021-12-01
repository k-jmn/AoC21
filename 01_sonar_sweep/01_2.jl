f(((a,b,c),acc), nxt) = b + c + nxt > a + b + c ? ((b,c,nxt),acc+1) : ((b,c,nxt),acc)
println(foldl(f, parse.(Int, readlines()); init=((0,0,0),0))[2] - 3)
