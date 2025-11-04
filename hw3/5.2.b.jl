using Graphs
using SimpleWeightedGraphs
using Random, StatsBase, Statistics
using Printf

function make_graph(N::Int=30, m::Int=3; seed=1, eps=1e-6)
    Random.seed!(seed)
    g = barabasi_albert(N, m; seed=seed)
    wg = SimpleWeightedGraph(g)
    for e in edges(g)
        w = 1.0 + rand()*eps
        add_edge!(wg, src(e), dst(e), w)
    end
    return wg
end

function on_unique_shortest_path(wg::SimpleWeightedGraph{Int,Float64},
                                 i::Int, j::Int, k::Int)
    i == j && return false
    (k == i || k == j) && return false
    sp = dijkstra_shortest_paths(wg, i)     # 默认读取边权
    parent = sp.parents
    v = j
    while v != i && v != 0
        if v == k; return true; end
        v = parent[v]
    end
    return false
end

function true_cB(wg::SimpleWeightedGraph{Int,Float64}, k::Int)
    V = collect(vertices(wg))
    deleteat!(V, findfirst(==(k), V))
    c = 0
    for a = 1:length(V)-1, b = a+1:length(V)
        i, j = V[a], V[b]
        c += on_unique_shortest_path(wg, i, j, k) ? 1 : 0
    end
    return c
end

function ht_estimate_cB(wg::SimpleWeightedGraph{Int,Float64}, k::Int, n::Int)
    N = nv(wg)
    @assert 2 ≤ n ≤ N-1 "sample size n must be in [2, N-1]"
    pool = setdiff(collect(1:N), [k])
    samp = sample(pool, n; replace=false)
    π = n*(n-1) / ((N-1)*(N-2))
    inflate = 1/π
    hits = 0
    for a = 1:n-1, b = a+1:n
        i, j = samp[a], samp[b]
        hits += on_unique_shortest_path(wg, i, j, k) ? 1 : 0
    end
    return inflate * hits
end

function simulate(; N=30, m=3, n=20, R=200, seed=1)
    wg = make_graph(N, m; seed=seed)
    N == nv(wg) || error("graph size mismatch")

    deg = degree.(Ref(wg), 1:N)
    bc  = betweenness_centrality(wg)
    K = 10
    ks = sample(1:N, K; replace=false)

    results = Dict{Int,Dict{Symbol,Float64}}()
    for k in ks
        truev = true_cB(wg, k)
        ests = [ht_estimate_cB(wg, k, n) for _ in 1:R]
        results[k] = Dict(
            :true_val => truev,
            :mean => mean(ests),
            :deg  => deg[k],
            :bc   => bc[k]
        )
    end
    return results
end

res = simulate(N=30, m=3, n=20, R=200, seed=42)
println("k\tdeg\tbc\ttrue\tmean")
for (k, d) in res
    @printf("%d\t%d\t%.4f\t%.0f\t%.1f\n",
        k, Int(d[:deg]), d[:bc], d[:true_val], d[:mean])
end
