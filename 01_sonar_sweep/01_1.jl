f((cur,acc), nxt) = nxt > cur ? (nxt,acc+1) : (nxt,acc)
println(foldl(f, parse.(Int, readlines()); init=(0,0))[2] - 1)
