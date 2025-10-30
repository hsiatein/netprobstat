using Graphs
using LinearAlgebra
using SparseArrays
using Random
using StatsBase
using Statistics
using Arpack
using Printf

function make_two_cliques_with_bridge(n::Int, m::Int; seed::Int=0)
    rng = seed == 0 ? Random.default_rng() : MersenneTwister(seed)
    g = SimpleGraph(2n)
    for u in 1:n, v in (u+1):n
        add_edge!(g, u, v)
    end
    for u in (n+1):(2n), v in (u+1):(2n)
        add_edge!(g, u, v)
    end
    m = min(m, n^2)
    added = 0
    tried = 0
    while added < m && tried < 10m
        i = rand(rng, 1:n)
        j = rand(rng, 1:n)
        u = i
        v = n + j
        if !has_edge(g, u, v)
            add_edge!(g, u, v)
            added += 1
        end
        tried += 1
    end
    labels = vcat(ones(Int, n), fill(2, n))
    return g, labels
end

function laplacian_matrix(g::SimpleGraph)
    A = adjacency_matrix(g)
    deg = degree(g)
    D  = spdiagm(0 => Float64.(deg))
    L  = D - SparseMatrixCSC{Float64, Int}(A)
    return L
end

function fiedler(g::SimpleGraph)
    L = laplacian_matrix(g)
    Lm = Matrix(L)
    vals, vecs = eigen(Lm)
    p = sortperm(real(vals))
    vals = vals[p]; vecs = vecs[:, p]
    λ2 = real(vals[2])
    f  = real(vecs[:, 2])
    return λ2, f
end

function cut_by_fiedler(f::AbstractVector{<:Real})
    θ = median(f)
    pred12 = map(x -> x <= θ ? 1 : 2, f)
    return pred12
end

function clustering_accuracy(pred::Vector{Int}, truth::Vector{Int})
    @assert length(pred) == length(truth)
    acc1 = mean(pred .== truth)
    pred_swapped = map(x -> x == 1 ? 2 : 1, pred)
    acc2 = mean(pred_swapped .== truth)
    return max(acc1, acc2)
end

function single_trial(n::Int, m::Int; seed::Int=0)
    g, truth = make_two_cliques_with_bridge(n, m; seed=seed)
    λ2, f = fiedler(g)
    pred = cut_by_fiedler(f)
    acc  = clustering_accuracy(pred, truth)
    return (λ2=λ2, acc=acc, f=f, g=g, truth=truth, pred=pred)
end

function sweep_m(n::Int; m_list=0:10:200, trials::Int=10, seed::Int=0)
    rng = MersenneTwister(seed)
    results = Dict{Int, NamedTuple}()
    for m in m_list
        λs = Float64[]; accs = Float64[]
        for t in 1:trials
            s = rand(rng, 1:10^9)
            out = single_trial(n, m; seed=s)
            push!(λs, out.λ2)
            push!(accs, out.acc)
        end
        results[m] = (λ2_mean=mean(λs), λ2_std=std(λs),
                      acc_mean=mean(accs), acc_std=std(accs))
    end
    return results
end

function demo(; n=100, mstep=5, mmax=300, trials=10, seed=0)
    m_list = 0:mstep:mmax
    res = sweep_m(n; m_list=m_list, trials=trials, seed=seed)

    println("m\t lambda2")
    for m in m_list
        r = res[m]
        @printf("%d\t %.4f \n",
                m, r.λ2_mean)
    end

    return res
end

res = demo(n=20, mstep=30, mmax=300, trials=10)
