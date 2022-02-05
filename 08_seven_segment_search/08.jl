parseinput() = hcat(map.(digit2int, split.(replace.(readlines()," | "=>" ")))...)
# encode digits into 7 bits
digit2int(str) = sum(map(x -> 2 ^ (x-'a'), collect(str)))

function decode(vec)
    unamb = [-1,1,7,4,-1,-1,8]
    unid = []
    sizehint!(unid, 6)
    digit = zeros(UInt8, 127)
    digitinv = zeros(UInt8, 10)
    for x in vec[1:end-4]
	maybeval = unamb[count_ones(x)]
	if maybeval ≠ -1
	    digit[x] = maybeval
	    digitinv[maybeval] = x
	else
	    push!(unid, x)
	end
    end
    frag = digitinv[4] - digitinv[1]
    for x in unid
	val = 0
	if count_ones(x) == 5
	    if x & digitinv[1] == digitinv[1]
		val = 3
	    elseif x & frag == frag
		val = 5
	    else
		val = 2
	    end
	else
	    if x & digitinv[1] ≠ digitinv[1]
		val = 6
	    elseif x & frag == frag
		val = 9
	    else
		val = 0
	    end
	end
	digit[x] = val
    end
    return sum(digit[x] * 10 ^ y for (x,y) in zip(vec[end-3:end], 3:-1:0))
end

function main()
    @time input = parseinput()
    #display(input)
    @show typeof(input)
    println("Part 1:")
    @time part1 = count((x -> count_ones(x) ∈ (2,3,4,7)), input[end-3:end,:])
    @time part1 = count((x -> count_ones(x) ∈ (2,3,4,7)), input[end-3:end,:])
    println(part1)
    println("Part 2:")
    @time part2 = sum(decode(input[:,i]) for i = 1:size(input)[2])
    @time part2 = sum(decode(input[:,i]) for i = 1:size(input)[2])
    println(part2)
end

main()
