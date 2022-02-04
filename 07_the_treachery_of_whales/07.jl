using Statistics

parseinput() = parse.(Int, split(readline(), ","))

function main()
    initial = parseinput()
    println("Part 1:")
    @time part1 = sum(abs.(initial .- round(Int, median(initial))))
    println(part1)
    println("Part 2:")
    @time begin
	mn = mean(initial)
	part2 = minimum(sum((x -> x*(x+1)÷2).(abs.(initial .- target))) for target = [floor(Int, mn), ceil(Int, mn)])
    end
    println(part2)
end

main()

