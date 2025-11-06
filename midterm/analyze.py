import networkx as nx

G:nx.DiGraph = nx.read_weighted_edgelist('/home/mugi/vscode/netprobstat/midterm/higgs-mention_network.edgelist', create_using=nx.DiGraph())

print("节点数:", G.number_of_nodes())
print("边数:", G.number_of_edges())
print("平均出度:", sum(dict(G.out_degree()).values()) / G.number_of_nodes())

import matplotlib.pyplot as plt
import random

# 随机抽取子图可视化（整个图太大）
sub_nodes = random.sample(list(G.nodes), 200)
H = G.subgraph(sub_nodes)

plt.figure(figsize=(8,8))
nx.draw_networkx(
    H,
    pos=nx.spring_layout(H, k=0.3),
    node_size=30,
    arrowsize=8,
    with_labels=False
)
plt.title("Higgs Mention Network (sample of 200 nodes)")
plt.show()
