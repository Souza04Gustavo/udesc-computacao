from Grafo import graph_from_file


if __name__ == "__main__":
    g = graph_from_file("grafo.txt", separator=",")
    # print(g.get_edges())
    # Imprime os Grafos em 2D e 3D
    # g.show_2d_map()
    g.show_3d_map()
