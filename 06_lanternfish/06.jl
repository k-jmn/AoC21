parseinput() = reduce((x,y) -> (x[y+1] += 1; x), parse.(Int8, split(readline(), ",")), init=zeros(Int,9))

simulate(initst, mmatrix, n) = mmatrix ^ n * initst

simulatemod(initst, mmatrix, n, m) = matrixpowermod(mmatrix, n, m) * initst

# like powermod, but for matrices
function matrixpowermod(A, n, m)
    B = A ^ 0
    AA = copy(A)
    while n != 0
	n & 1 == 1 && (B = (B * AA) .% m)
	n >>= 1
	AA = (AA ^ 2) .% m
    end
    B
end

function main()
    mmatrix = Int.(
	[0 1 0 0 0 0 0 0 0
	 0 0 1 0 0 0 0 0 0
	 0 0 0 1 0 0 0 0 0
	 0 0 0 0 1 0 0 0 0
	 0 0 0 0 0 1 0 0 0
	 0 0 0 0 0 0 1 0 0
	 1 0 0 0 0 0 0 1 0
	 0 0 0 0 0 0 0 0 1
	 1 0 0 0 0 0 0 0 0])
    initst = parseinput()
    mmatrix2 = BigInt.(mmatrix) # turns out
    initst2 = BigInt.(initst) # you don't even need these
    println("Part 1:")
    # I might just leave the @time macros in from here on out
    @time part1 = sum(simulate(initst, mmatrix, 80))
    println(part1)
    println("Part 2:")
    @time part2 = sum(simulate(initst, mmatrix, 256))
    println(part2)
    println("Part 3?:") # ...until you do a googol days
    @time part3 = sum(simulatemod(initst2, mmatrix2, big"10"^100, UInt128(10)^20)) % UInt128(10)^20
    println(part3)
end

main()

