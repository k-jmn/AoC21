function parseinput(line)
    dir, num = split(line)
    num = parse(Int, num)
    if dir == "up"
	return [0, -num]
    elseif dir == "down"
	return [0, num]
    else
	return [num, 0]
    end
end
horizontal, depth = readlines() .|> parseinput |> sum
println(horizontal * depth)
