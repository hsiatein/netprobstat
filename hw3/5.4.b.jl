using Graphs, StatsBase, Random, LinearAlgebra, Distributions, Plots

function B_matrix(p::Float64, K::Int)
    B = zeros(Float64, K+1, K+1)
    for d in 0:K, k in d:K
        B[d+1, k+1] = pdf(Binomial(k, p), d)
    end
    return B
end

function deconvolve(f_obs::Vector, p::Float64)
    K = length(f_obs) - 1
    B = B_matrix(p, K)
    f_est = B \ f_obs
    f_est[f_est .< 0] .= 0
    return f_est ./ sum(f_est)
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

function simulate_deconvolution(; N=500, m=3, n=100, seed=0)
    Random.seed!(seed)
    g = barabasi_albert(N, m; seed=seed)
    gstar = induced_subgraph(g, sample(1:N, n; replace=false))[1]
    f_true = degree_distribution(g)
    f_star = degree_distribution(gstar)
    L = min(length(f_true), length(f_star))
    f_true = f_true[1:L]; f_star = f_star[1:L]
    p = (n - 1) / (N - 1)
    f_hat = deconvolve(f_star, p)

    L = min(L, length(f_hat))
    f_true, f_star, f_hat = f_true[1:L], f_star[1:L], f_hat[1:L]

    tv_star = sum(abs.(f_star - f_true)) / 2
    tv_hat = sum(abs.(f_hat - f_true)) / 2
    println("TVD(f*, f) = $(round(tv_star, digits=4)),   TVD(f̂, f) = $(round(tv_hat, digits=4))")

    return (f_true, f_star, f_hat)
end

simulate_deconvolution(N=500, m=3, n=100, seed=0)
