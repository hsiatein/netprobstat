import igraph as ig
import leidenalg
import numpy as np
import matplotlib.pyplot as plt
import os

import igraph as ig
import leidenalg
import numpy as np
import matplotlib.pyplot as plt
import os
import sys

# --- Dynamic File Path Handling ---
script_dir = os.path.dirname(__file__)
default_file_path = os.path.join(script_dir, 'ba_model.edgelist')

# Use command-line argument for file path if provided, otherwise use default
if len(sys.argv) > 1:
    file_path = sys.argv[1]
else:
    file_path = default_file_path

# --- Output Path Configuration ---
output_dir = os.path.join(script_dir, 'report', 'plots')
os.makedirs(output_dir, exist_ok=True)
# Generate a unique plot filename based on the input file
input_filename = os.path.basename(file_path)
plot_path = os.path.join(output_dir, f"degree_distribution_{input_filename}.png")


print(f"Loading graph from {file_path}...")

# Load the graph using igraph. Set weights=False to handle unweighted graphs too.
try:
    G = ig.Graph.Read_Ncol(file_path, directed=True, weights=False)
except Exception as e:
    print(f"Error loading graph: {e}")
    print("Trying to load as a simple edgelist (no weights)...")
    try:
        # Fallback for files that might have weight column issues but are unweighted
        G = ig.Graph.Read_Edgelist(file_path, directed=True)
    except Exception as e2:
        print(f"Failed to load graph: {e2}")
        sys.exit(1)

# The node names are integers, let's map them to strings to be safe
G.vs["name"] = [str(v) for v in G.vs["name"]]

print(f"Graph loaded. Number of nodes: {G.vcount()}, Number of edges: {G.ecount()}")

# --- 1. Centrality Analysis ---

print("Performing centrality analysis...")

# Degree Centrality (in-degree and out-degree for directed graphs)
in_degree = G.indegree()
out_degree = G.outdegree()
total_degree = G.degree()

# Sort and print top 10 nodes by total degree
top_degree_indices = np.argsort(total_degree)[-10:][::-1]
print("\nTop 10 Nodes by Total Degree:")
for idx in top_degree_indices:
    print(f"Node {G.vs[idx]['name']}: {total_degree[idx]}")

# Betweenness Centrality
print("\nCalculating Betweenness Centrality (estimated)...")
betweenness = G.betweenness(cutoff=10) # cutoff for faster estimation
# Normalize for easier interpretation
max_betweenness = max(betweenness)
if max_betweenness > 0:
    betweenness = [b / max_betweenness for b in betweenness]
top_betweenness_indices = np.argsort(betweenness)[-10:][::-1]
print("\nTop 10 Nodes by Betweenness Centrality (normalized):")
for idx in top_betweenness_indices:
    print(f"Node {G.vs[idx]['name']}: {betweenness[idx]:.4f}")

# Closeness Centrality (on largest connected component)
print("\nCalculating Closeness Centrality (on largest connected component)...")
largest_cc = G.connected_components().giant()
closeness = largest_cc.closeness()
top_closeness_indices = np.argsort(closeness)[-10:][::-1]
print("\nTop 10 Nodes by Closeness Centrality:")
for idx in top_closeness_indices:
    # Node names in the giant component correspond to the original graph's names
    original_node_name = largest_cc.vs[idx]["name"]
    print(f"Node {original_node_name}: {closeness[idx]:.4f}")

# Eigenvector Centrality
print("\nCalculating Eigenvector Centrality...")
eigenvector_centrality = G.eigenvector_centrality()
top_eigenvector_indices = np.argsort(eigenvector_centrality)[-10:][::-1]
print("\nTop 10 Nodes by Eigenvector Centrality:")
for idx in top_eigenvector_indices:
    print(f"Node {G.vs[idx]['name']}: {eigenvector_centrality[idx]:.4f}")

# --- 2. Community Detection (Leiden Method) ---

print("\nPerforming Community Detection (Leiden method)...")
# We need to convert the graph to undirected for most community detection algorithms
# that are based on modularity.
G_undirected = G.as_undirected()
partition = leidenalg.find_partition(G_undirected, leidenalg.ModularityVertexPartition)

num_communities = len(partition)
modularity = G_undirected.modularity(partition)

print(f"Number of communities detected: {num_communities}")
print(f"Modularity of the partition: {modularity:.4f}")

# Get the size of each community
community_sizes = [len(c) for c in partition]
# Sort communities by size and print top 5
sorted_community_indices = np.argsort(community_sizes)[-5:][::-1]
print("\nTop 5 Largest Communities:")
for i, idx in enumerate(sorted_community_indices):
    print(f"Community {idx}: {community_sizes[idx]} nodes")

# --- Basic Graph Statistics ---
print("\nBasic Graph Statistics:")
print(f"Number of nodes: {G.vcount()}")
print(f"Number of edges: {G.ecount()}")
print(f"Average degree: {np.mean(G.degree()):.2f}")
print(f"Graph is connected: {G.is_connected()}")
if not G.is_connected():
    components = G.connected_components()
    print(f"Number of connected components: {len(components)}")
    largest_cc = components.giant()
    print(f"Size of largest connected component: {largest_cc.vcount()} nodes")

# --- Plotting Degree Distribution ---
print(f"\nGenerating degree distribution plot in {plot_path}...")
degree_dist = G.degree_distribution()
bins = degree_dist.bins()
degrees_and_counts = []
for b in bins:
    if b[2] > 0: # If count is greater than 0
        degrees_and_counts.append((b[1], b[2])) # (max_degree, count)

# Sort by degree
degrees_and_counts.sort(key=lambda x: x[0])

degrees = [item[0] for item in degrees_and_counts]
counts = [item[1] for item in degrees_and_counts]

plt.figure(figsize=(10, 6))
plt.loglog(degrees, counts, 'o-')
plt.title(f"Degree Distribution for {input_filename}")
plt.xlabel("Degree")
plt.ylabel("Number of Nodes")
plt.grid(True, which="both", ls="-")
plt.savefig(plot_path)
plt.close()
print("Degree distribution plot generated.")

print("\nAnalysis Complete. Review the printed results and generated plots.")