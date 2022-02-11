parseinput() = BitVector(vcat(reverse.(digits.(parse.(UInt8, collect(readline()), base=16), base=2, pad=4))...))

struct Header
    version :: UInt8
    type :: UInt8
end

struct PacketVal
    header :: Header
    # let's hope the values don't go above 64 bits
    val :: UInt64
end

struct PacketOp
    header :: Header
    operands :: Vector{Union{PacketVal,PacketOp}}
end

function takeint(bits :: AbstractVector{Bool}, count)
    @assert count ≤ 64
    view(bits, count+1:length(bits)), sum(x * 2 ^ y for (x,y) in zip(bits, count-1:-1:0))
end
function takeheader(bits ::AbstractVector{Bool})
    bits, version = takeint(bits, 3)
    bits, type = takeint(bits, 3)
    bits, Header(version, type)
end
function takepacketval(bits, header)
    chunks = Vector{UInt8}()
    sizehint!(chunks, 16)
    bits, chunk = takeint(bits, 5)
    while chunk & 16 ≠ 0
	push!(chunks, chunk & 15)
	bits, chunk = takeint(bits, 5)
    end
    push!(chunks, chunk & 15)
    @assert length(chunks) ≤ 16
    bits, PacketVal(header, sum(UInt64(x) << 4y for (x,y) in zip(chunks, length(chunks)-1:-1:0)))
end
function takepacketop(bits, header)
    bits, lengthtype = takeint(bits, 1)
    operands = []
    if lengthtype == 0
	bits, len = takeint(bits, 15)
	slice = view(bits, 1:len)
	bits = view(bits, len+1:length(bits))
	while length(slice) ≠ 0
	    slice, packet = takepacket(slice)
	    push!(operands, packet)
	end
	@assert length(slice) == 0
    else
	bits, count = takeint(bits, 11)
	sizehint!(operands, count)
	for _ in 1:count
	    bits, packet = takepacket(bits)
	    push!(operands, packet)
	end
    end
    bits, PacketOp(header, operands)
end

function takepacket(bits :: AbstractVector{Bool})
    bits, header = takeheader(bits)
    if header.type == 4
	return takepacketval(bits, header)
    else
	return takepacketop(bits, header)
    end
end

sumversions(packet :: PacketVal) = packet.header.version
sumversions(packet :: PacketOp) = packet.header.version + sum(sumversions.(packet.operands))

evalpacket(packet :: PacketVal) = big(packet.val)
function evalpacket(packet :: PacketOp) :: BigInt
    # no switch statement? no problem!
    ops = [sum
	   prod
	   minimum
	   maximum
	   x -> 0//0
	   x -> BigInt(x[1] > x[2])
	   x -> BigInt(x[1] < x[2])
	   x -> BigInt(x[1] == x[2])]
    big(ops[packet.header.type+1](evalpacket.(packet.operands)))
end

function main()
    @time input = parseinput()
    #@show input
    @time _, rootpacket = takepacket(input)
    @time _, rootpacket = takepacket(input)
    println("Part 1:")
    @time part1 = sumversions(rootpacket)
    @time part1 = sumversions(rootpacket)
    println(part1)
    println("Part 2:")
    @time part2 = evalpacket(rootpacket)
    @time part2 = evalpacket(rootpacket)
    println(part2)
end

main()
