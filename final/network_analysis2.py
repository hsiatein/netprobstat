import igraph as ig
import os
import math

print("Starting BA model generation...")

# Define the path to the original edgelist file
script_dir = os.path.dirname(__file__)
original_file_path = os.path.join(script_dir, '..', 'midterm', 'higgs-mention_network.edgelist')
output_file_path = os.path.join(script_dir, 'ba_model.edgelist')

print(f"Loading original graph from {original_file_path} to get parameters...")

# Load the original graph to get its N and M
try:
    original_G = ig.Graph.Read_Ncol(original_file_path, directed=True)
    N = original_G.vcount()
    M = original_G.ecount()
    print(f"Original graph has {N} nodes and {M} edges.")

    # Calculate m for the Barabasi-Albert model
    # m is the number of edges to attach for each new node.
    m = int(round(M / N))
    print(f"Calculated m for BA model: {m}")

    # Generate the BA model graph
    print(f"Generating BA model with N={N} and m={m}...")
    # Use directed=True to match the original network type
    ba_model_G = ig.Graph.Barabasi(n=N, m=m, directed=True)

    # Save the edgelist of the generated graph
    print(f"Saving generated BA model to {output_file_path}...")
    ba_model_G.write_edgelist(output_file_path)

    print("\nBA model generation complete.")
    print(f"Generated graph has {ba_model_G.vcount()} nodes and {ba_model_G.ecount()} edges.")
    print(f"You can now run the analysis script on '{output_file_path}'.")

except Exception as e:
    print(f"An error occurred: {e}")
    print("Please ensure the original edgelist file exists at the specified path.")

