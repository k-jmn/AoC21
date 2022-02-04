bitvector2int(bv) = sum(reverse(bv, dims=1) .* (2 .^ (0:length(bv) - 1)))

function gammarate(bitvectors)
    ones = sum(bitvectors)
    bitvector2int(length(bitvectors) .< 2 .* ones)
end

function ratings(bitvectors, cmpf)
    l = length(bitvectors[1])
    indices = BitSet(1:length(bitvectors))
    for i = 1:l
	length(indices) == 1 && break
	ones = 0
	for vec = bitvectors[collect(indices)]
	    vec[i] && (ones += 1)
	end
	expected = cmpf(2 * ones, length(indices))
	for j = indices
	    length(indices) == 1 && break
	    bitvectors[j][i] == expected || delete!(indices, j)
	end
    end
    bitvector2int(bitvectors[first(indices)])
end

bitvectors = [[parse(Bool, c) for c in line] for line = readlines()]

println("part 1:")
gamma = gammarate(bitvectors)
epsilon = gamma ⊻ (2 ^ length(bitvectors[1]) - 1)
println(gamma*epsilon)

println("part 2:")
o2 = ratings(bitvectors, >=)
co2 = ratings(bitvectors, <)
println(o2 * co2)


