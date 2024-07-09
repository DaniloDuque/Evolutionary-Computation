function read_file(name::AbstractString)
    input = Vector{Tuple{Int, Int, Float64}}()
    file = open(name, "r")
    line = readline(file)
    n = parse(Int, split(line)[1])
    m = parse(Int, split(line)[2])
    while !eof(file)
        line = readline(file)
        parts = split(line)  
        num1 = parse(Int, parts[1])
        num2 = parse(Int, parts[2])
        num3 = parse(Float64, parts[3])
        push!(input, (num1, num2, num3))
    end
    close(file)  
    return (n, m, input)
end

