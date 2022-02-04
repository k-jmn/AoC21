parseinput() = parse.(Int8, hcat(split.(readlines(), "")...))

neighbors((x,y), (xm,ym)) = [CartesianIndex(xx,yy) for xx = x-1:x+1, yy = y-1:y+1 if 1 <= xx <= xm && 1 <= yy <= ym && (xx != x || yy != y)]

function simulate(input, countat)
    xm, ym = size(input)
    energylevels = copy(input)
    hasflashed = BitMatrix(zeros(Bool, xm, ym))
    tocheck = Vector{CartesianIndex{2}}()
    indices = CartesianIndices((xm,ym))
    neighs = [neighbors((x,y), (xm,ym)) for x = 1:xm, y=1:ym]
    flashcount = 0
    steps = 0
    while !all(hasflashed)
	hasflashed .= 0
	steps += 1
	energylevels .+= 1
	push!(tocheck, indices...)
	while length(tocheck) > 0
	    pos = pop!(tocheck)
	    if !hasflashed[pos] && energylevels[pos] > 9
		hasflashed[pos] = 1
		toupdate = filter(x -> !hasflashed[x], neighs[pos])
		energylevels[toupdate] .+= 1
		push!(tocheck, toupdate...)
	    end
	end
	energylevels .*= .~hasflashed
	steps <= 100 && (flashcount += sum(hasflashed))
    end
    flashcount, steps
end

function main()
    input = parseinput()
    @time part1, part2 = simulate(input, 100)
    @time part1, part2 = simulate(input, 100)
    println("Part 1:")
    println(part1)
    println("Part 2:")
    println(part2)
end

main()
