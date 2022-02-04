# NON-STANDARD FORMAT TODAY
parseinput() = parse.(Int, split(readline()))


function velocitycount(xlower, xupper, ylower, yupper)
    # first, let's find out at which starting velocities
    # the probe stops witihin x bounds
    # (it's much easier to process these cases separately)
    v = 0
    stopcount = 0
    firststop = -1
    laststop = -1
    stopsat = 0
    while true
	if stopsat > xupper
	    laststop = v - 1
	    break
	elseif stopsat ≥ xlower
	    stopcount += 1
	    (firststop == -1) && (firststop = v)
	end
	v += 1
	stopsat += v
    end

    # check that there aren't infinitely many possibilities
    (stopcount ≠ 0) && (ylower ≤ 0 ≤ yupper) && return -1

    xsteps = laststop
    if ylower < 0
	ysteps = -ylower * 2
    elseif ylower == 0
	ysteps = xsteps
    else
	# I think this should work?
	ysteps = yupper * 2
    end

    # the funny looking conversion...
    xpart = Vector{Union{UnitRange{Int}, Vector{UnitRange{Int}}}}(onepart(xlower, xupper, xsteps, false)) 
    # is for this - if you know of a better way to concatenate 2 ranges without collecting them
    # than this + Iterators.flatten(), please let me know
    for i in 1:stopcount
	xpart[end-stopcount+i] = [xpart[end-stopcount+i], firststop:firststop+i-1]
    end
    ypart = onepart(ylower, yupper, ysteps, true)
    if (ext = length(ypart) - length(xpart)) > 0 && stopcount ≠ 0
	append!(xpart, [firststop:laststop for _ in 1:ext])
    end
    
    xvlower, xvupper = extrema(Iterators.flatten(Iterators.flatten.(xpart)))
    yvlower, yvupper = extrema(Iterators.flatten(ypart))
    # given the input size, a bit array should do fine
    isgoodthrow = BitMatrix(zeros(Bool, xvupper - xvlower + 1, yvupper - yvlower + 1))
    for (xs, ys) in zip(xpart, ypart)
	for x in Iterators.flatten(xs), y in ys
	    isgoodthrow[x-xvlower+1,y-yvlower+1] = 1
	end
    end
    sum(isgoodthrow)
end

# for each step count in 0:maxsteps
# calculate starting velocity ranges that make 
# the probe land within lower:upper
# (canreverse determines whether the probe may have negative velocity)
function onepart(lower, upper, maxsteps, canreverse)
    options = [1:0 for _ in  0:maxsteps]
    lower ≤ 0 ≤ upper && (options[1] = 0:0)
    # we can imagine that instead of the probe de- / accelerating,
    # the target area is moving away at an increasing pace
    offset = 0
    for i in 1:maxsteps
	vlower = ceil(Int, (lower + offset) / i)
	!canreverse && (vlower = max(vlower, i))
	vupper = floor(Int, (upper + offset) / i)
	vlower ≤ vupper && (options[i+1] = vlower:vupper)
	offset += i
    end
    options
end

function main()
    input = parseinput()
    # I worked out part 1 with a calculator in less than 2 minutes
    # and I really don't feel like spending 10 more writing the code
    println("Part 2:")
    @time part2 = velocitycount(input...)
    @time part2 = velocitycount(input...)
    println(part2)
end

main()
