include("util.jl")

const cool_rate::Float64 = 0.99999
const T_max::Float64 = 1000
const T_min::Float64 = 1e-4
n, m, I = read_file("test_cases/test2")
G = Graph(n, I)

function accept(T::Float64, Δ::Float64)::Bool return Δ < 0 || rand() < exp(-Δ/T) end

function Simulated_Annealing()::entity 
    
    curr::entity = entity(n, G)
    T::Float64 = T_max
    while(T > T_min)
        New::entity = entity(G, curr) 
        if(accept(T, New.energy - curr.energy)) curr = New end
        T *= cool_rate
    end
    return curr
end

Simulated_Annealing()


