using Graphs

GRAPH = Dict(
    1 => [2, 3],
    2 => [1, 3, 4],
    3 => [1, 2, 5],
    4 => [2, 5, 6, 7],
    5 => [3, 4, 6],
    6 => [4, 5, 7],
    7 => [4, 6]
)

function get_all_comb(n::Int)
    if n == 1
        return [[0], [1]]
    end
    result = []
    for comb in get_all_comb(n - 1)
        push!(result, vcat(comb, [0]))
        push!(result, vcat(comb, [1]))
    end
    return result
end

function cal_sub_graph(comb)
    sub_g = Dict{Int, Vector{Int}}()
    for (i, bit) in enumerate(comb)
        if bit == 1
            sub_g[i] = [j for j in GRAPH[i] if comb[j] == 1]
        end
    end

    return sub_g
end

function analyze_subgraph(sub_g::Dict{Int, Vector{Int}})
    nodes = collect(keys(sub_g))
    node_to_idx = Dict(n => i for (i, n) in enumerate(nodes))
    G = SimpleGraph(length(nodes))

    for (u, neighbors) in sub_g
        for v in neighbors
            if haskey(node_to_idx, v)
                add_edge!(G, node_to_idx[u], node_to_idx[v])
            end
        end
    end

    connected = is_connected(G)

    cycles = cycle_basis(G)

    has_cycle3 = any(length(c) >= 3 for c in cycles)
    has_cycle4 = any(length(c) == 4 for c in cycles)

    return (connected=connected, has_cycle3=has_cycle3, has_cycle4=has_cycle4)
end

function main()
    connected_count = 0
    cycle3_count = 0
    cycle4_count = 0

    for comb in get_all_comb(7)
        if sum(comb) == 0 || sum(comb) == 7
            continue
        end

        sub_g = cal_sub_graph(comb)
        analysis = analyze_subgraph(sub_g)

        if analysis.connected
            connected_count += 1
        end
        if analysis.has_cycle3
            cycle3_count += 1
        end
        if analysis.has_cycle4
            cycle4_count += 1
        end
    end

    println("连通子图数量: ", connected_count)
    println("含有长度≥3环的子图数量: ", cycle3_count)
    println("含有长度=4环的子图数量: ", cycle4_count)
end

main()
