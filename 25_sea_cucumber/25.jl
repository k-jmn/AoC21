function parseinput()
    m = hcat(split.(readlines(), "")...)
    BitMatrix(map(x -> x == ">", m)), BitMatrix(map(x -> x == "v", m))
end

function whenstop(east, south)
    size(east) != size(south) && error("mismatched input size")
    xm, ym = size(east)
    east = copy(east)
    south = copy(south)
    nexteast = BitMatrix(zeros(Bool, xm, ym))
    nextsouth = BitMatrix(zeros(Bool, xm, ym))
    occupied = BitMatrix(zeros(Bool, xm, ym))
    indices = [(x,y) for x in 1:xm, y in 1:ym]
    steps = 0
    hasmoved = true
    while hasmoved
	steps += 1
	hasmoved = false
	occupied = south .| east
	for (x,y) in indices
	    if east[x,y]
		if !occupied[x%xm+1,y]
		    hasmoved = true
		    nexteast[x%xm+1,y] = 1
		else
		    nexteast[x,y] = 1
		end
	    end
	end
	east, nexteast = nexteast, east
	nexteast .= 0
	occupied = south .| east
	for (x,y) in indices
	    if south[x,y]
		if !occupied[x,y%ym+1]
		    hasmoved = true
		    nextsouth[x,y%ym+1] = 1
		else
		    nextsouth[x,y] = 1
		end
	    end
	end
	south, nextsouth = nextsouth, south
	nextsouth .= 0
    end
    steps
end

function main()
    east, south = parseinput()
    println("Part 1")
    @time part1 = whenstop(east, south)
    @time part1 = whenstop(east, south)
    println(part1)
end

main()
