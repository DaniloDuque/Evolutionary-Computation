function read_file(name)
    input = []
    file = open(name, "r")
    while(!eof(file))
        push!(input, collect(parse.(Float64, split(replace(readline(file), r"[()]" => "")))))
    end
    return input
end
