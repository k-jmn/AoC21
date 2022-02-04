function parseinput() = BitVector(reverse(digits(parse(BigInt, readline(), base=16), base=2)))

function main()
    packets = parseinput()

end

main()
