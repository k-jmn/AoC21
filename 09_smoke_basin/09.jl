parseinput() :: Matrix{UInt8} = parse.(UInt8, hcat(split.(readlines(), "")...))

function neighs((x, y) :: Tuple{Integer, Integer}, (xm, ym) :: Tuple{Integer, Integer}) 
    o = Vector{CartesianIndex{2}}()
    x > 1 && push!(o, CartesianIndex(x-1,y))
    y > 1 && push!(o, CartesianIndex(x,y-1))
    x < xm && push!(o, CartesianIndex(x+1,y))
    y < ym && push!(o, CartesianIndex(x,y+1))
    o
end

function bothparts(heights)
    xm, ym = size(heights)
    heightindices = [Vector{CartesianIndex{2}}() for _ = 1:9]
    for x = 1:xm, y = 1:ym
	heights[x,y] != 9 && push!(heightindices[heights[x,y]+1], CartesianIndex(x,y))
    end
    risklevelsum = zero(Int)
    basinsizes = Vector{Int}()
    upstream = ones(Int, (xm, ym))
    for heightlevel = reverse(heightindices), pos = heightlevel
	islowest = true
	for neigh = neighs(Tuple(pos), (xm, ym))
	    if heights[neigh] < heights[pos]
		upstream[neigh] += upstream[pos]
		islowest = false
		break
	    end
	end
	if islowest
	    push!(basinsizes, upstream[pos])
	    risklevelsum += heights[pos] + 1
	end
    end
    risklevelsum, prod(sort!(basinsizes, rev=true)[1:3])
end

function main()
    heights = parseinput()
    @time bothparts(heights) # time with compilation
    @time part1, part2 = bothparts(heights) # and without
    println("Part 1:")
    println(part1)
    println("Part 2:")
    println(part2)
end

main()
