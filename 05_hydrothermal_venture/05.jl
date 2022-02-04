using SparseArrays

parseinput() = map(x -> Tuple(parse.(Int, x)), split.(replace.(readlines(), " -> "=>","), ","))

isorthogonal((ax,ay,bx,by)) = ax == bx || ay == by

pmax(x,y) = max.(x,y)

function findintersections(lines, onlyort)
    indices = onlyort ? filter(i -> isorthogonal(lines[i]), 1:length(lines)) : (1:length(lines))
    m = reduce(pmax, lines[indices], init=(0,0,0,0))
    maxc = (max(m[1], m[3]), max(m[2], m[4]))
    # I tried 3 different data structures - uncomment one, more changes needed elsewhere for Dict
    #linemap = Dict{Tuple{Int, Int}, Bool}() # hashmaps are slow -_-
    #linemap = spzeros(Bool, maxc...) # could be better for less dense inputs? looks pretty when printed out though
    linemap = BitArray(zeros(Bool, maxc...)) # small input makes this the fastest
    intersectionmap = copy(linemap) 
    for (ax, ay, bx, by) = lines[indices]
	step = sign.((bx, by) .- (ax, ay))
	len = maximum(abs.((bx, by) .- (ax, ay)))
	for i = 0:len
	    pos = (ax, ay) .+ i .* step
	    linemap[pos...] == 1 ? intersectionmap[pos...] = 1 : linemap[pos...] = 1
	    #get(linemap, Tuple(pos), 0) == 1 ? intersectionmap[pos...] = 1 : linemap[pos...] = 1 # Dict variant
	end
    end
    intersectionmap
end

function main()
    lines = parseinput() :: Vector{NTuple{4, Int64}}
    println("Part 1:")
    @time part1 = sum(findintersections(lines, true))
    #@time part1 = sum(values(findintersections(lines, true))) # Dict variant
    println(part1)
    println("Part 2:")
    @time part2 = sum(findintersections(lines, false))
    #@time part2 = sum(values(findintersections(lines, false))) # Dict variant
    println(part2)
end

main()
