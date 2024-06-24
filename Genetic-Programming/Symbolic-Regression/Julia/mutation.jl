include("util.jl")

const maxDepth = 5
const mutationProbability = 0.5

function isLeaf(node::Tree)::Bool return !(node.left isa Tree || node.right isa Tree) end

function combine_trees(t1::Tree, t2::Tree)::Tree return Tree(choose_function(), t1, t2) end


#point mutation -> alters a leaf node

function alter_point(point::Union{Num, Number})::Union{Num, Number} return point isa Num ? choose_consvar() : point + rand(-2:2) end

function change_point(node::Tree)::Tree
    return Tree(node.fun, 
          !(node.left isa Tree) && nextBool() ? alter_point(node.left) : node.left, 
          !(node.right isa Tree) && nextBool() ? alter_point(node.right) : node.right) 
end

function mutate_point(tree::Tree)::Tree
    if(isLeaf(tree)) return change_point(tree) end
    return Tree(tree.fun, nextBool() ? mutate_point(tree.left) : tree.left, nextBool() ? mutate_point(tree.right) : tree.right) 
end

#---------------------------------------------------------------------------------------------



#subtree mutation -> changes a random subtree

function mutate_subtree(tree::Tree)::Tree
    if(isLeaf(tree) || nextBool()) return seed() end
    return nextBool() ? Tree(tree.fun, mutate_subtree(tree.left), tree.right) : Tree(tree.fun, tree.left, mutate_subtree(tree.right))
end

#---------------------------------------------------------------------------------------------



#hoist mutation -> replaces a tree with one of it's subtrees

function mutate_hoist(tree::Tree)::Tree
    return isLeaf(tree) || nextBool() ? tree :
    nextBool() ? select_subtree(tree.left) :
    select_subtree(tree.right)
end

#---------------------------------------------------------------------------------------------



#function mutation -> changes the operator from a random node

function change_function(node::Tree)::Tree return Tree(choose_function(), node.left, node.right) end

function mutate_function(tree::Tree)::Tree
    if(isLeaf(tree) || rand(0:7) == 0) return change_function(tree) end    
    return nextBool() ? Tree(tree.fun, mutate_function(tree.left), tree.right) : Tree(tree.fun, tree.left, mutate_function(tree.right))
end

#--------------------------------------------------------------------------------------------

function prune(node::Union{Tree, Num, Number}, d::Int)
    if(!(node isa Tree)) return node end
    if(d == maxDepth) return choose_consvar() end
    return Tree(node.fun, prune(node.left, d+1), prune(node.right, d+1))
end

function select_subtree(tree::Tree)::Tree
    return isLeaf(tree) || nextBool() ? tree :
    nextBool() ? select_subtree(tree.left) :
    select_subtree(tree.right)
end

const mutations = [mutate_function, mutate_point, mutate_subtree, mutate_hoist]

function mutation(exp::Tree)::Tree return mutations[rand(1:4)](exp) end

function cross_over(f::Tree, g::Tree)::Tuple
    New = combine_trees(select_subtree(f), select_subtree(g))
    return make_exp(prune(rand() < mutationProbability ? mutation(New) : New, 0))
end
