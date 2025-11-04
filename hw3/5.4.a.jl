using Graphs, StatsBase, Random, Plots

function make_graph(N::Int=500, m::Int=3; seed=1)
    Random.seed!(seed)
    g = barabasi_albert(N, m; seed=seed)
    return g
end

function induced_sample(g::SimpleGraph, n::Int)
    N = nv(g)
    sample_vertices = sample(1:N, n; replace=false)
    gstar = induced_subgraph(g, sample_vertices)[1]
    return gstar
end

function degree_distribution(g::SimpleGraph)
    degs = degree(g)
    counts = countmap(degs)
    dmax = maximum(keys(counts))
    f = zeros(Float64, dmax+1)
    for (k, v) in counts
        f[k+1] = v / nv(g)
    end
    return f
end

function compare_degree_distributions(; N=500, m=3, n=100, seed=0)
    g = make_graph(N, m; seed=seed)
    gstar = induced_sample(g, n)
    f_true = degree_distribution(g)
    f_star = degree_distribution(gstar)

    L = min(length(f_true), length(f_star))
    f_true = f_true[1:L]; f_star = f_star[1:L]
    tv = sum(abs.(f_true - f_star)) / 2
    println("n=$n -> total variation distance = $(round(tv, digits=4))")
    return tv
end

tvs = Float64[]
for n in [50, 100, 150, 200, 300]
    push!(tvs, compare_degree_distributions(N=500, m=3, n=n, seed=0))
end

