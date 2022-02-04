parseinput() :: Matrix{Vector{Char}} = (x -> sort!(Char.(collect(x)))).(hcat(split.(replace.(readlines()," | "=>" "))...))

function decode(vec)
    1
end

function main()
    @time input = parseinput()
    println("Part 1:")
    @time part1 = count((x -> length(x) ∈ (2,3,4,7)), input[end-3:end,:])
    println(part1)
    println("Part 1:")
    @time part1 = sum(decode(input[:,i]) for i = 1:size(input)[2])
    println(part1)
end

main()
