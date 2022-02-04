parseinput() = parse.(Int16, hcat(split.(readlines(), "")...))

# looks better than the last one I wrote
neighs((x,y), (xm,ym)) = filter(((xx,yy),) -> 1 ≤ xx ≤ xm && 1 ≤ yy ≤ ym, [(x-1,y), (x+1,y), (x,y-1), (x,y+1)])

# I don't feel like writing or importing a proper priority queue,
# so let's make use of the low upper bound on edge cost
# and use a circular buffer of vectors instead
function getnextnearest(near, dist)
    l = length(near)
    nextnearest = near[1]
    while true
	dist += 1
	nextnearest = near[dist % l + 1]
	length(nextnearest) > 0 && break
    end
    nextnearest, dist
end

function shortestpathlength(costmatrix, start, goal)
    mdims = size(costmatrix)
    seen = BitMatrix(zeros(Bool, mdims))
    seen[start...] = 1
    # the aforementioned circular buffer
    near = [Vector{Tuple{Int,Int}}() for _ in 1:10]
    push!(near[1], start)
    dist = 0
    nearest = near[1]
    while true
	for (x,y) in nearest
	    for (xx,yy) in neighs((x,y), mdims)
		(xx,yy) == goal && return dist + costmatrix[xx,yy]
		if !seen[xx,yy]
		    seen[xx,yy] = 1
		    push!(near[(dist + costmatrix[xx,yy]) % 10 + 1], (xx,yy))
		end
	    end
	end
	empty!(nearest)
	nearest, dist = getnextnearest(near, dist)
    end
    -1 # should not happen, ever
end

# I figured it would be fun to make a custom type
# (although it is definitely slower than using a 25 times larger matrix)
struct WeirdMatrix
    matrix::Matrix{Int16}
    xmax::Int
    ymax::Int
    xtimesmax::Int
    ytimesmax::Int
    WeirdMatrix(matrix, xmul, ymul) = new(matrix, size(matrix)[1], size(matrix)[2], xmul, ymul)
end

WeirdMatrix(matrix, mul) = WeirdMatrix(matrix, mul, mul)

function Base.getindex(m::WeirdMatrix, x, y)
    (1 ≤ x ≤ m.xmax * m.xtimesmax && 1 ≤ y ≤ m.ymax * m.ytimesmax) || throw(BoundsError)
    (m.matrix[(x-1) % m.xmax + 1, (y-1) % m.ymax + 1] + (x-1) ÷ m.xmax + (y-1) ÷ m.ymax - 1) % 9 + 1
end

Base.size(m::WeirdMatrix) = (m.xmax * m.xtimesmax, m.ymax * m.ytimesmax)

function main()
    @time costmatrix = parseinput()
    println("Part 1:")
    # once again, running both parts twice to get times without compilation
    @time part1 = shortestpathlength(costmatrix, (1,1), size(costmatrix))
    @time part1 = shortestpathlength(costmatrix, (1,1), size(costmatrix))
    println(part1)
    println("Part 2:")
    @time begin
	costmatrix2 = WeirdMatrix(costmatrix, 5)
	part2 = shortestpathlength(costmatrix2, (1,1), size(costmatrix2))
    end
    @time begin
	costmatrix2 = WeirdMatrix(costmatrix, 5)
	part2 = shortestpathlength(costmatrix2, (1,1), size(costmatrix2))
    end
    println(part2)
end

main()
