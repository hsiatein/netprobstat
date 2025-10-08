using LinearAlgebra, GLM, Plots

Y = [2.292, 2.068, 0.926, -1.419, 4.451, 0.679, 3.226, 2.220, -0.649, -2.008]
X1 = [1.209, -1.577, -0.605, -0.689, 0.814, -1.681, 0.304, -0.202, -1.510, -1.081]
X2 = [-0.472, 2.291, 1.231, -1.047, 0.585, 0.617, 1.441, 0.360, -1.262, -0.323]
X3 = [0.3588, 0.3377, 0.3030, -0.8682, 0.7039, -0.5338, 0.8917, 0.0736, -1.3820, -0.7049]

X_partial = hcat(X1, X2)
X_full = hcat(X1, X2, X3)

β_partial = inv(X_partial' * X_partial) * (X_partial' * Y)
β_full = inv(X_full' * X_full) * (X_full' * Y)

println("部分模型 (X1,X2) 系数: ", β_partial)
println("完整模型 (X1,X2,X3) 系数: ", β_full)

lambdas = [0.01, 0.1, 1, 10, 100]
I=
[[1. 0. 0.]
[0. 1. 0.]
[0. 0. 1.]]
for λ in lambdas
    β_ridge = inv(X_full' * X_full + λ * I) * (X_full' * Y)
    println("λ = $λ 时, 岭回归系数 = ", β_ridge)
end
