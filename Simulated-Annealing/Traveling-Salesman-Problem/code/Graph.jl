
struct Graph
    
    ady::Array{Float64, 2}

    function Graph(n::Int, T::Vector{Tuple{Int, Int, Float64}})
        A = fill(Inf, n, n)
        for(i, j, w) in T
            A[i, j] = A[j, i] = w
        end
        new(A)
    end
    
end




