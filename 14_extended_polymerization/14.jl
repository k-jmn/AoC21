using SparseArrays

function parseinput()
    template = split(readline(), "")
    readline()
    rules = hcat(split.(replace.(readlines(), " -> "=>""), "")...)
    template, rules
end

function translateinput(template, rules)
    c2i = Dict()
    i = 1
    foreach(vcat(template, rules[:])) do x
	if x ∉ keys(c2i)
	    c2i[x] = i
	    i += 1
	end
    end
    elems length(c2i)
    rulematrix = spzeros(Int, elems^2, elems^2)	# using a sparse array actually makes part 1 faster
    foreach(x -> rulematrix[x,x] = 1, 1:elems^2)
    for i in 1:size(rules)[2]
	a, b, c = map(x -> c2i[x], rules[:,i])
	ab = (a-1)n + b
	ac = (a-1)n + c
	cb = (c-1)n + b
	rulematrix[ab,ab] = 0
	rulematrix[ac,ab] = 1
	rulematrix[cb,ab] = 1
    end
    templateint = map(x -> c2i[x], template) # this is where I gave up on naming my variables sensibly
    templatevec = zeros(Int, n^2)
    foreach(x -> templatevec[x] += 1, [(templateint[i]-1)n + templateint[i+1] for i in 1:length(templateint)-1])
    templatevec , rulematrix, (templateint[1], templateint[end]), n
end

function translateback(pairvec, edges, elems)
    elemvec = zeros(Int, elems)
    foreach(x -> elemvec[x] += 1, edges)
    for a in 1:elems, b in 1:elems
	n = pairvec[(a-1)elems+b]
	elemvec[a] += n
	elemvec[b] += n
    end
    elemvec .÷ 2
end

function main()
    template, rules = parseinput()
    @time templatevec, rulematrix, edges, elems = translateinput(template, rules)
    @time templatevec, rulematrix, edges, elems = translateinput(template, rules)
    println("Part 1:")
    @time begin
	elemvec = translateback(rulematrix ^ 10 * templatevec, edges, elems)
	part1 = maximum(elemvec) - minimum(elemvec)
    end
    @time begin
	elemvec = translateback(rulematrix ^ 10 * templatevec, edges, elems)
	part1 = maximum(elemvec) - minimum(elemvec)
    end
    println(part1)
    println("Part 2:")
    @time begin
	elemvec = translateback(rulematrix ^ 40 * templatevec, edges, elems)
	part2 = maximum(elemvec) - minimum(elemvec)
    end
    @time begin
	elemvec = translateback(rulematrix ^ 40 * templatevec, edges, elems)
	part2 = maximum(elemvec) - minimum(elemvec)
    end
    println(part2)
end

main()
