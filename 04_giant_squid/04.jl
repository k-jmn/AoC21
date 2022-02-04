
function parseinput()
    nums = parse.(Int, split(readline(), ","))
    lines = split.(readlines())
    boards = [parse.(Int, hcat(lines[i:i+4]...)) for i = 2:6:length(lines)]
    nums, boards
end

getboardindex(nums, boards) =  [BitSet(findall(x -> n ∈ x, boards)) for n = 0:maximum(nums)]

iswinningmove(boardstate, pos) = all(boardstate[pos[1],:]) || all(boardstate[:,pos[2]])

function playbingo(nums, boards, boardindex)
    boardstates = [zeros(Bool, size(boards[1])) for _ = boards]
    haswon = [false for _ = boards]
    winners = Vector{Int}()
    winningstates = Vector{Matrix{Bool}}()
    winningnums = Vector{Int}()
    for num = nums, b = boardindex[num+1]
	pos = findfirst(x -> x == num, boards[b])
	boardstates[b][pos] = true
	if iswinningmove(boardstates[b], pos) && !haswon[b]
	    haswon[b] = true
	    push!(winners, b)
	    push!(winningstates, copy(boardstates[b]))
	    push!(winningnums, num)
	end
    end
    winners, winningstates, winningnums
end

score(board, state, num) = sum(board .* .~state) * num

const nums, boards = parseinput()
winners, winningstates, winningnums = playbingo(nums, boards, getboardindex(nums, boards))
println("Part 1:")
println(score(boards[first(winners)], first(winningstates), first(winningnums)))
println("Part 2:")
println(score(boards[last(winners)], last(winningstates), last(winningnums)))
