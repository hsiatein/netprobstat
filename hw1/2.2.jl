using Graphs

graph_dict = Dict(
    1 => [2, 3],
    2 => [1, 3, 4],
    3 => [1, 2, 5],
    4 => [2, 5, 6, 7],
    5 => [3, 4, 6],
    6 => [4, 5, 7],
    7 => [4, 6]
)

n = length(keys(graph_dict))
g = SimpleGraph(n)

for (u, neighbors) in graph_dict
    for v in neighbors
        add_edge!(g, u, v)
    end
end

for i in 1:n
    for j in 1:n
        if i != j
            path = enumerate_paths(dijkstra_shortest_paths(g, i), j)
            println("从 $i 到 $j 的最短路径: ", path)
        end
    end
end


