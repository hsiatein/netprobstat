import Pkg
Pkg.activate(".")
Pkg.add(["Plots"])
using Graphs
using Random
using Statistics
using Plots


function double_edge_swap!(g::AbstractGraph, n_swaps::Int)
    
    nvg = nv(g)
    if ne(g) < 2
        return
    end

    for _ in 1:n_swaps
        u = rand(1:nvg)
        if degree(g, u) == 0; continue; end
        v = neighbors(g, u)[rand(1:degree(g, u))]

        x = rand(1:nvg)
        if degree(g, x) == 0; continue; end
        y = neighbors(g, x)[rand(1:degree(g, x))]

        if u == x || u == y || v == x || v == y
            continue
        end

        if has_edge(g, u, x) || has_edge(g, v, y)
            continue
        end

        rem_edge!(g, u, v)
        rem_edge!(g, x, y)
        add_edge!(g, u, x)
        add_edge!(g, v, y)
    end
end

g = smallgraph(:karate)

obs_trans = global_clustering_coefficient(g)
println("Observed Transitivity: $obs_trans")

function simulate_transitivity(original_graph, n_sims=1000)
    sim_results = Float64[]
    n_swaps = 100 * ne(original_graph)
    
    for _ in 1:n_sims
        g_sim = copy(original_graph)
        
        double_edge_swap!(g_sim, n_swaps)
        
        push!(sim_results, global_clustering_coefficient(g_sim))
    end
    return sim_results
end

println("Starting simulation...")
sim_trans = simulate_transitivity(g, 1000)

mean_sim = mean(sim_trans)
p_value = count(x -> x >= obs_trans, sim_trans) / length(sim_trans)

println("Mean Simulated Transitivity: $mean_sim")
println("P-value: $p_value")

p = histogram(sim_trans, 
    label="Null Model", 
    title="Transitivity Test", 
    xlabel="Transitivity",
    ylabel="Frequency",
    color=:lightblue,
    legend=:topright
)
vline!([obs_trans], label="Observed", color=:red, linewidth=2, linestyle=:dash)

savefig(p, "transitivity_test.png")
