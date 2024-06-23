using Symbolics, NaNMath
include("input.jl")
include("operators.jl")

@variables x y
const entry = read_file("functions/f5.txt")
const sizePop = 10

struct Tree
    fun::Function
    left::Union{Tree, Num, Number}
    right::Union{Tree, Num, Number}
end

operators = (sum, subs, prod, div, pow, lg)

function make_exp(t::Tree)::Tuple return (fitness(t), t) end
function depth(node::Union{Tree, Num, Number})::Int return node isa Tree ? 1 + max(depth(node.left), depth(node.right)) : 0 end
function make_gen()::Vector{Tuple} return [make_exp(seed()) for _ in 1:sizePop] end
function nextBool()::Bool return Bool(rand(0:1)) end
function choose_consvar()::Union{Num, Number} return rand(0:7) == 0 ? rand(-20:20) : nextBool() ? x : y end
function choose_function()::Function operators[rand(1:6)] end

function seed()::Tree
    function seed_h(tree::Tree)::Tree
        if(nextBool()) return tree end
        if(nextBool()) return Tree(choose_function(), seed(), tree) end
        return Tree(choose_function(), tree, seed())
    end
    return seed_h(Tree(choose_function(), choose_consvar(), choose_consvar()))
end

function evaluate(node::Tree, x_val::Number, y_val::Number)::Number
    return node.fun(node.left isa Tree ? evaluate(node.left, x_val, y_val) :
                   node.left isa Num ? node.left === x ? x_val : y_val : node.left,
                   node.right isa Tree ? evaluate(node.right, x_val, y_val) :
                   node.right isa Num ? node.right === x ? x_val : y_val : node.right)
end

function fitness(tree::Tree)::Number
    fit::Number = 0
    for (x, y, z) in entry 
        e::Number = evaluate(tree, x, y)
        fit += abs(isnan(e) ? Inf : e - z) 
    end
    return fit
end

