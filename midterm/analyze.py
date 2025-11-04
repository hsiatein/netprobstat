import networkx as nx

G = nx.read_weighted_edgelist('/home/mugi/vscode/netprobstat/midterm/higgs-mention_network.edgelist', create_using=nx.DiGraph())

print("节点数:", G.number_of_nodes())
print("边数:", G.number_of_edges())
print("平均出度:", sum(dict(G.out_degree()).values()) / G.number_of_nodes())
