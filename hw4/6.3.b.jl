import Pkg
Pkg.activate(".")
Pkg.add(["GLM", "DataFrames", "StatsBase"])
using Random
using StatsBase
using DataFrames
using GLM
using Statistics

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

"""
Hill Estimator
"""
function hill_estimator(degrees::Vector{Int}, d_min::Int)
    tail_degrees = filter(d -> d >= d_min, degrees)
    n = length(tail_degrees)
    
    if n == 0
        return NaN
    end
    log_sum = sum(log.(tail_degrees ./ d_min))
    gamma = 1 + n / log_sum
    
    return gamma
end

"""
Naive Regression
"""
function regression_estimator(degrees::Vector{Int})
    deg_counts = countmap(degrees)
    ks = sort(collect(keys(deg_counts)))
    probs = [deg_counts[k] / length(degrees) for k in ks]

    X = log.(ks)
    Y = log.(probs)

    data = DataFrame(X=X, Y=Y)
    model = lm(@formula(Y ~ X), data)
    
    slope = coef(model)[2]
    gamma = -slope
    
    return gamma
end

function run_estimation_comparison()
    N = 100000
    m = 3
    d_min = 15
    
    println("生成网络 (N=$N, m=$m)...")
    graph = generate_ba_network(N, m)
    degrees = length.(graph)

    gamma_hill = hill_estimator(degrees, d_min)
    
    gamma_reg = regression_estimator(degrees)
    
    println("\n=== 结果对比 (理论值 Gamma ≈ 3.0) ===")
    println("1. Hill Estimator:")
    println("   Gamma ≈ $(round(gamma_hill, digits=4))")
    
    println("\n2. Naive Regression:")
    println("   Gamma ≈ $(round(gamma_reg, digits=4))")
    
    return degrees
end

run_estimation_comparison()