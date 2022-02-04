using Statistics

function scoreline(line :: String)
    stack = Vector{Char}()
    other = Dict{Char, Char}( ')'=>'(', ']'=>'[', '}'=>'{', '>'=>'<' )
    escore = Dict{Char, Int}( ')'=>3, ']'=>57, '}'=>1197, '>'=>25137 )
    cscore = Dict{Char, Int}( '('=>1, '['=>2, '{'=>3, '<'=>4 )
    for c = line
	if c ∈ ('(','[','{','<')
	    push!(stack, c)
	elseif length(stack) == 0 || pop!(stack) != other[c]
	    return (escore[c], 0)
	end
    end
    (0, foldr((x, y) -> 5y + cscore[x], stack, init=0))
end

function bothscores(lines)
    escores = Vector{Int}()
    cscores = Vector{Int}()
    for line = lines
	a = scoreline(line)
	if a[2] == 0
	    push!(escores, a[1])
	else
	    push!(cscores, a[2])
	end
    end
    escores, cscores
end

function main()
    lines = readlines()
    @time escores, cscores = bothscores(lines) # don't fell like calculating time without compilation?
    @time escores, cscores = bothscores(lines) # just call the thing twice
    println("Part 1:")
    @time part1 = sum(escores)
    println(part1)
    println("Part 2:")
    @time part2 = Int(median(cscores))
    println(part2)
end

main()
