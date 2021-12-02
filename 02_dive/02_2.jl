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
function step((horizontal, depth, aim), (velocity, aimdelta))
    aim += aimdelta
    horizontal += velocity
    depth += velocity * aim
    horizontal, depth, aim
end
function dive(commands)
    foldl(step, commands; init=(0,0,0))
end
horizontal, depth, _ = readlines() .|> parseinput |> dive
println(horizontal * depth)
