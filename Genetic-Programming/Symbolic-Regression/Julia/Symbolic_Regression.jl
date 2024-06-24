using GLMakie
using Base.Threads

include("mutation.jl")

const update_channel = Channel{Tree}(1)


function generate_data(fun::Tree)
    n = 7
    x = LinRange(0, 19, n)
    y = LinRange(0, 19, n)
    z = [real(evaluate(fun, xi, yi)) for xi in x, yi in y]
    X = repeat(x, 1, n)
    Y = repeat(y', n, 1)
    Z = z
    return X, Y, Z
end

function plot_updater()
    set_theme!(theme_black())
    fig = Figure(size = (800, 600))
    ax = Axis3(fig[1, 1])
    display(fig)
    surface_plot = nothing
    scatter_plot = scatter!(ax, [p[1] for p in entry], [p[2] for p in entry], [p[3] for p in entry], color=:purple, markersize=10)
    while true
        fun = take!(update_channel)
        X, Y, Z = generate_data(fun)
        if surface_plot == nothing
            surface_plot = surface!(ax, X, Y, Z)
        else
            surface_plot[1] = X
            surface_plot[2] = Y
            surface_plot[3] = Z
        end
        # Actualizar puntos del scatter plot
        scatter_plot[1] = [p[1] for p in entry]
        scatter_plot[2] = [p[2] for p in entry]
        scatter_plot[3] = [p[3] for p in entry]
        sleep(7.5)
    end
end

Threads.@spawn plot_updater()

function update_data!(fun::Tree) put!(update_channel, fun) end

function cmp(a::Tuple, b::Tuple) return a[1] < b[1] end

function reproduce(P::Vector{Tuple})::Vector{Tuple}
    push!(P, make_exp(mutation(P[1][2])))
    for i in 1:sizePop for j in 1:sizePop push!(P, cross_over(P[i][2], P[j][2])) end end
    sort!(P, lt=cmp)
    return P[1:sizePop]
end

function Symbolic_Regression()
    P::Vector{Tuple} = make_gen()
    i::Int = 0
    while(true)
        if(i % 300 == 0 && P[1][1] != Inf)
            println(P[1])
            update_data!(P[1][2])
        end
        P = reproduce(P)
        i += 1
    end
    return println(P[1])
end

Symbolic_Regression()

