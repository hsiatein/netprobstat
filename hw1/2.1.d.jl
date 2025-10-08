g = Dict(
    1 => [2, 3],
    2 => [1, 3, 4],
    3 => [1, 2, 5],
    4 => [2, 5, 6, 7],
    5 => [3, 4, 6],
    6 => [4, 5, 7],
    7 => [4, 6]
)

function all_paths(g, start::Int, goal::Int)
    openlist = [[start]]
    paths = []

    while !isempty(openlist)
        path = popfirst!(openlist)
        node = last(path)

        if node == goal
            push!(paths, path)
            println(path)
            continue
        end

        for neighbor in g[node]
            if neighbor ∉ path
                push!(openlist, vcat(path, [neighbor]))
            end
        end
    end
    
    println("Total paths: ", length(paths))
    return paths
end

all_paths(g, 1, 7)
