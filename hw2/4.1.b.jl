using Random, Statistics, StatsBase, DataFrames, GLM

# 采样
pareto_sample(x0, α, n; rng=Random.default_rng()) = x0 .* rand(rng, n) .^ (-1/α)

# Hill
function hill_mle(x::AbstractVector, x0::Real)
    inv(mean(log.(x ./ x0)))
end

# 4.2
function reg_alpha_42(x::AbstractVector)
    n = length(x)
    xs = sort(x)
    p = (n .- collect(1:n) .+ 1) ./ n
    df = DataFrame(logx = log.(xs), logS = log.(p))
    model = lm(@formula(logS ~ logx), df)
    slope = coef(model)[2]
    αhat = -slope
    return αhat
end

# 4.3
function reg_alpha_43(x::AbstractVector)
    n = length(x)
    xs = sort(x)
    idx = collect(1:n)
    df = DataFrame(logi = log.(idx), logx = log.(xs))
    model = lm(@formula(logx ~ logi), df)
    b = coef(model)[2]
    αhat = -1 / b
    return αhat
end

# 单次
function one_run(x0, α, n; rng=Random.default_rng())
    x = pareto_sample(x0, α, n; rng)
    α_hill = hill_mle(x, x0)
    α_42   = reg_alpha_42(x)
    α_43   = reg_alpha_43(x)
    (; α_true=α, α_hill, α_42, α_43)
end

# 多次
function eval_estimators(x0, α_list, n_list; trials=1000, seed=42)
    rng = MersenneTwister(seed)
    rows = NamedTuple[]
    for α in α_list, n in n_list
        H = Float64[]; SF = Float64[]; QS = Float64[]
        for _ in 1:trials
            r = one_run(x0, α, n; rng)
            push!(H, r.α_hill); push!(SF, r.α_42); push!(QS, r.α_43)
        end
        for (name, arr) in zip(["Hill", "4.2", "4.3"], [H,SF,QS])
            bias = mean(arr) - α
            rmse = sqrt(mean((arr .- α).^2))
            push!(rows, (α_true=α, n=n, estimator=name, mean_est=mean(arr),
                         bias=bias, rmse=rmse, sd=std(arr)))
        end
    end
    return DataFrame(rows)
end

# 开始实验

α_list = [1.2, 2.0]
n_list = [50, 200]
x0 = 1.0

res = eval_estimators(x0, α_list, n_list; trials=1000, seed=2025)
println(res)

# include("4.1.b.jl")