using Random
include("input.jl")
include("Graph.jl")

mutable struct entity
    
    energy::Float64
    path::Array{Int}

    function Perturb(arr::Array{Int})
        x, y = rand(1:length(arr)), rand(1:length(arr))
        arr[x], arr[y] = arr[y], arr[x]
    end

    function Energy(G::Graph, p::Array{Int})::Float64 
        e::Float64 = 0
        l = length(p)
        for i in 2:l e+= G.ady[p[i-1], p[i]] end
        return e + G.ady[p[1], p[l]]
    end

    function entity(G::Graph, E::entity) 
        p = copy(E.path)
        Perturb(p)
        new(Energy(G, p), p)
    end

    function entity(size::Int, G::Graph)
        p = shuffle(collect(1:size))        
        new(Energy(G, p), p)
    end
end
