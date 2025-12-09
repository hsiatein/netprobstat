import Pkg
Pkg.activate(".")
Pkg.add(["Plots","StatsBase"])
using Random
using Plots
using StatsBase

function generate_ba_network(N::Int, m::Int)

    adj = [Int[] for _ in 1:N]

    sizehint!(adj, N)
    M_list = Vector{Int}()
    sizehint!(M_list, 2 * N * m)

    initial_size = m + 1
    for i in 1:initial_size
        for j in (i+1):initial_size
            push!(adj[i], j)
            push!(adj[j], i)
            push!(M_list, i)
            push!(M_list, j)
        end
    end

    for new_node in (initial_size + 1):N
        targets = Set{Int}()

        while length(targets) < m

            candidate = M_list[rand(1:length(M_list))]

            if candidate != new_node && !(candidate in targets)
                push!(targets, candidate)
            end
        end
        
        for target in targets
            push!(adj[new_node], target)
            push!(adj[target], new_node)

            push!(M_list, new_node)
            push!(M_list, target)
        end
    end

    return adj
end

function compare_distribution(N::Int, m::Int, filename::String="degree_distribution.png")    
    graph = generate_ba_network(N, m)
    
    degrees = length.(graph)
    deg_counts = countmap(degrees)
    
    unique_degrees = sort(collect(keys(deg_counts)))
    probs = [deg_counts[k] / N for k in unique_degrees]

    theory_probs = [ (2 * m * (m + 1)) / (k * (k + 1) * (k + 2)) for k in unique_degrees ]

    plt = scatter(unique_degrees, probs, 
        label="Simulation (N=$N)", 
        xscale=:log10, yscale=:log10, 
        marker=:circle, markersize=4, alpha=0.6,
        xlabel="Degree (k)", ylabel="Probability P(k)",
        legend=:bottomleft,
        dpi=300
    )
    
    plot!(unique_degrees, theory_probs, 
        label="Theory (Limit)", 
        lw=2, linecolor=:red, linestyle=:dash
    )

    savefig(plt, filename)
    
    return degrees
end

m = 3
N = 1000000

compare_distribution(N, m)