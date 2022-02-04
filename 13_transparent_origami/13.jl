function parseinput()
    lines = readlines()
    d = findfirst(x -> x == "", lines)
    dots = map(x -> parse.(Int, x) .+ 1, split.(lines[1:d-1], ","))
    paperdims = reduce((x, y) -> max.(x, y), dots)
    paper = BitMatrix(zeros(Bool, paperdims...))
    foreach(((x, y),) -> paper[x,y] = 1, dots)
    instructions = [(axis, parse(Int, location)+1) for (_, _, axis, location) = split.(replace.(lines[d+1:end], "="=>" "), " ")]
    paper, instructions
end

function parseinput2()
    lines = readlines()
    d = findfirst(x -> x == "", lines)
    dots = map(x -> parse.(Int, x) .+ 1, split.(lines[1:d-1], ","))
    instructions = [(axis, parse(Int, location)+1) for (_, _, axis, location) = split.(replace.(lines[d+1:end], "="=>" "), " ")]
    Tuple.(dots), instructions
end

# yes, I am aware this is a horribly slow way to do this
function foldpaper(paper, instructions)
    paper = copy(paper)
    xm, ym = size(paper)
    afterfirst = -1
    for (axis, loc) = instructions
	if axis == "x"
	    fl = xm - loc
	    paper[loc-fl:loc-1,:] .|= reverse(paper[loc+1:loc+fl,:], dims=1)
	    xm = loc - 1
	else
	    fl = ym - loc
	    paper[:,loc-fl:loc-1] .|= reverse(paper[:,loc+1:loc+fl], dims=2)
	    ym = loc - 1
	end
	(afterfirst == -1) && (afterfirst = sum(paper[1:xm,1:ym]))
    end
    afterfirst, paper[1:xm,1:ym]
end

function folddots(dots, instructions)
    #dots = Set(dots) 
    dots = copy(dots)
    afterfirst = -1
    for (axis, loc) = instructions
	if axis == "x"
	    tofold = filter(((x, y),) -> x > loc, collect(dots))
	    filter!(((x, y),) -> x < loc, dots)
	    push!(dots, map(((x, y),) -> (2*loc - x, y), tofold)...)
	else
	    tofold = filter(((x, y),) -> y > loc, collect(dots))
	    filter!(((x, y),) -> y < loc, dots)
	    push!(dots, map(((x, y),) -> (x, 2*loc - y), tofold)...)
	end
	dots = unique!(dots)
	(afterfirst == -1) && (afterfirst = length(dots))
    end
    paperdims = reduce((x, y) -> max.(x, y), dots)
    paper = BitMatrix(zeros(Bool, paperdims...))
    foreach(((x, y),) -> paper[x,y] = 1, dots)
    afterfirst, paper
end

function main()
    @time paper, instructions = parseinput()
    @time part1, part2 = foldpaper(paper, instructions)
    @time part1, part2 = foldpaper(paper, instructions)
    println("Part 1:")
    println(part1)
    println("Part 2:")
    display(copy(part2'))
    println()
end

function main2()
    @time dots, instructions = parseinput2()
    @time part1, part2 = folddots(dots, instructions)
    @time part1, part2 = folddots(dots, instructions)
    println("Part 1:")
    println(part1)
    println("Part 2:")
    display(copy(part2'))
    println()
end

main2()
