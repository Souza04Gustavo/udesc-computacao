from collections import defaultdict
from pyvis import network as net
from IPython.display import display, HTML
import plotly.graph_objects as go
import random
import minify_html
from typing import List, Tuple, Union


class Graph:
    """
        Uma classe para representar uma estrutura de dados de um Grafo e aplicar seu devidos algoritmos.

        ...

        Atributos
        ----------
        graph : defaultdict(list)
            Um dicionário para armazenar o grafo, onde as chaves são os vértices e os valores são listas de vizinhos.
        directed : bool
            Indica se o grafo é direcionado ou não.

        Métodos
        -------
        add_edge(vertex: any, neighbor: any) -> None:
            Adiciona uma aresta entre o vértice e o vizinho.
        
        remove_edge(vertex: any, neighbor: any) -> None:
            Remove a aresta entre o vértice e o vizinho.
        
        get_num_vertices() -> int:
            Retorna o número de vértices no grafo.
        
        get_degree(vertex: any) -> int:
            Retorna o grau de um vértice.
        
        get_vertices() -> List[any]:
            Retorna uma lista de vértices do grafo.
        
        bfs(vertex: any) -> List[any]:
            Executa uma busca em largura no grafo a partir de um vértice e retorna a ordem dos vértices visitados.
        
        dfs(vertex: any) -> List[any]:
            Executa uma busca em profundidade no grafo a partir de um vértice e retorna a ordem dos vértices visitados.
        
        has_cycle() -> bool:
            Verifica se o grafo contém ciclos e retorna True se houver, caso contrário retorna False.
        
        get_edges(as_tuple: bool = False) -> List[Union[Tuple[any, any], List[any]]]:
            Retorna uma lista de arestas do grafo. As arestas podem ser retornadas como listas ou tuplas.
        
        show_2d_map() -> None:
            Exibe o grafo em um mapa 2D.
        
        show_3d_map() -> None:
            Exibe o grafo em um mapa 3D.
    """
    # Inicializa a classe Graph, criando um grafo vazio.
    def __init__(self, directed: bool = False) -> None:
        self.graph = defaultdict(list)  # Usa um defaultdict para armazenar o grafo.
        self.directed = directed  # Indica se o grafo é direcionado ou não.

    # Adiciona uma aresta entre o vértice e o vizinho.
    def add_edge(self, vertex: any, neighbor: any) -> None:
        if neighbor not in self.graph[vertex]:
            self.graph[vertex].append(neighbor)  # Adiciona o vizinho à lista de vértices adjacentes.
            if not self.directed:
                self.graph[neighbor].append(vertex)  # Se o grafo não é direcionado, adiciona a aresta reversa.

    # Remove a aresta entre o vértice e o vizinho.
    def remove_edge(self, vertex: any, neighbor: any) -> None:
        if vertex in self.graph:
            self.graph[vertex].remove(neighbor)  # Remove o vizinho da lista de vértices adjacentes.
            if not self.directed:
                self.graph[neighbor].remove(vertex)  # Se o grafo não é direcionado, remove a aresta reversa.

    # Retorna o número de vértices no grafo.
    def get_num_vertices(self) -> int:
        return len(self.graph.keys())

    # Retorna o grau de um vértice.
    def get_degree(self, vertex: any) -> int:
        return len(self.graph[vertex])

    # Retorna uma lista de vértices do grafo.
    def get_vertices(self) -> List[any]:
        return list(self.graph.keys())

    # Executa uma busca em largura no grafo a partir de um vértice e retorna a ordem dos vértices visitados.
    def bfs(self, vertex: any) -> List[any]:
        visited, queue, result = [vertex], [vertex], []  # Inicializa as listas de visitados, fila e resultado.

        while queue:
            vertex = queue.pop(0)  # Remove e retorna o primeiro vértice da fila.
            for neighbor in self.graph[vertex]:
                if neighbor not in visited:
                    visited.append(neighbor)  # Marca o vizinho como visitado.
                    queue.append(neighbor)  # Adiciona o vizinho à fila.
            result.append(vertex)  # Adiciona o vértice atual ao resultado.

        return result

    # Executa uma busca em profundidade no grafo a partir de um vértice e retorna a ordem dos vértices visitados.
    def dfs(self, vertex: any) -> List[any]:
        stack, path = [vertex], []  # Inicializa as listas de pilha e caminho.

        while stack:
            vertex = stack.pop()  # Remove e retorna o último vértice da pilha.
            if vertex not in path:
                path.append(vertex)  # Adiciona o vértice ao caminho.
                stack.extend(self.graph[vertex])  # Adiciona os vizinhos do vértice à pilha.

        return path

    # Método para verificar se o grafo possui ciclos
    def has_cycle(self) -> bool:
        # Obtém o número de vértices do grafo
        num_vertices = self.get_num_vertices()
        # Inicializa a lista de vértices visitados com todos como False
        visited = [False] * (num_vertices + 1)

        # Itera pelos vértices do grafo
        for vertex in range(num_vertices):
            # Se o vértice não foi visitado
            if not visited[vertex]:
                # Chama a função auxiliar __has_cycle e verifica se há ciclo
                if self.__has_cycle(vertex, visited, -1):
                    return True

        # Se não encontrou ciclo, retorna False
        return False
    
    # Método auxiliar para verificar se há ciclos no grafo
    def __has_cycle(self, vertex: any, visited: List[bool], parent: any) -> bool:
        # Marca o vértice atual como visitado
        visited[vertex] = True

        # Itera pelos vizinhos do vértice atual
        for neighbor in self.graph[vertex]:
            # Se o vizinho não foi visitado
            if not visited[neighbor]:
                # Chama recursivamente a função __has_cycle e verifica se há ciclo
                if self.__has_cycle(neighbor, visited, vertex):
                    return True
            # Se o vizinho já foi visitado e não é o vértice pai
            elif parent != neighbor:
                return True

        # Se não encontrou ciclo, retorna False
        return False


    # Método para obter as arestas do grafo
    def get_edges(self, as_tuple: bool = False) -> List[Union[Tuple[any, any], List[any]]]:
        result = []  # Inicializa a lista de resultado
        processed_edges = set()  # Cria um conjunto para armazenar arestas processadas

        # Itera pelos vértices do grafo
        for vertex in self.get_vertices():
            # Itera pelos vizinhos do vértice atual
            for neighbor in self.graph[vertex]:
                # Cria uma tupla com os vértices da aresta, ordenada de forma crescente
                edge = (vertex, neighbor) if vertex < neighbor else (neighbor, vertex)

                # Se o grafo não é direcionado e a aresta já foi processada, continua
                if not self.directed and edge in processed_edges:
                    continue

                # Adiciona a aresta ao conjunto de arestas processadas
                processed_edges.add(edge)

                # Adiciona a aresta ao resultado
                if as_tuple:
                    result.append(edge)
                else:
                    result.append([vertex, neighbor])

        # Retorna a lista de arestas
        return result

    # Método para representar o grafo como uma string
    def __str__(self) -> str:
        # Obtém a lista de vértices e arestas como strings
        vertices_str = ", ".join(map(str, self.get_vertices()))
        edges_str = ", ".join([f"({v1}, {v2})" for v1, v2 in self.get_edges(as_tuple=True)])

        # Retorna a representação do grafo como uma string
        return f"Vertices: {vertices_str}\nNumber of Vertices: {self.get_num_vertices()}\nEdges: {edges_str}\nNumber of Edges: {len(self.get_edges())}"


     # Método para exibir o grafo em um mapa 2D
    def show_2d_map(self) -> None:
        # Obtém os vértices e arestas do grafo
        vertices, edges = self.get_vertices(), self.get_edges()
        print(vertices)
        print(edges)

        # Cria a interface para o grafo 2D
        interface = net.Network(
            height='100%',
            width='100%',
            notebook=True,
            heading='2D Graph'
        )

        # Adiciona os vértices ao grafo 2D
        for v in vertices:
            interface.add_node(v, label=str(v))

        # Adiciona as arestas ao grafo 2D
        interface.add_edges(edges)

        # Exibe o grafo 2D em um arquivo HTML
        output_file = '2DGraph.html'
        interface.show(output_file)
        display(HTML(output_file))



    # Método para exibir o grafo em um mapa 3D
    def show_3d_map(self) -> None:
        # Obtém o número de vértices do grafo
        num_vertices = self.get_num_vertices()
        edges_weights = [1] * num_vertices
        edges = self.get_edges(as_tuple=True)

        # Cria o grafo 3D com coordenadas aleatórias para cada vértice
        graph_3d = {
            v: [random.random(), random.random(), random.random()] for v in self.get_vertices()
        }

        # Obtém as coordenadas dos vértices
        x_vertices = [graph_3d[key][0] for key in graph_3d.keys()]
        y_vertices = [graph_3d[key][1] for key in graph_3d.keys()]
        z_vertices = [graph_3d[key][2] for key in graph_3d.keys()]

        # Inicializa as listas para armazenar as coordenadas das arestas e seus pontos médios
        x_edges, y_edges, z_edges = [], [], []
        xtp, ytp, ztp = [], [], []

        # Itera pelas arestas do grafo
        for edge in edges:
            # Adiciona as coordenadas das arestas e seus pontos médios às listas
            x_coords = [graph_3d[edge[0]][0], graph_3d[edge[1]][0], None]
            x_edges.extend(x_coords)
            xtp.append(0.5 * (graph_3d[edge[0]][0] + graph_3d[edge[1]][0]))

            y_coords = [graph_3d[edge[0]][1], graph_3d[edge[1]][1], None]
            y_edges.extend(y_coords)
            ytp.append(0.5 * (graph_3d[edge[0]][1] + graph_3d[edge[1]][1]))

            z_coords = [graph_3d[edge[0]][2], graph_3d[edge[1]][2], None]
            z_edges.extend(z_coords)
            ztp.append(0.5 * (graph_3d[edge[0]][2] + graph_3d[edge[1]][2]))

        # Cria uma lista de textos para exibir os pesos das arestas
        etext = [f'weight={w}' for w in edges_weights]
        
         # Cria o gráfico 3D para os pesos das arestas
        trace_weights = go.Scatter3d(
            x=xtp,
            y=ytp,
            z=ztp,
            mode='markers',
            marker=dict(color='rgb(125,125,125)', size=1),
            text=etext,
            hoverinfo='text'
        )

        # Cria o gráfico 3D para as arestas
        trace_edges = go.Scatter3d(
            x=x_edges,
            y=y_edges,
            z=z_edges,
            mode='lines',
            line=dict(color='black', width=2),
            hoverinfo='none'
        )

        # Cria o gráfico 3D para os vértices
        trace_vertices = go.Scatter3d(
            x=x_vertices,
            y=y_vertices,
            z=z_vertices,
            mode='markers',
            marker=dict(symbol='circle',
                        size=10,
                        color='skyblue')
        )

        # Define o layout do gráfico 3D
        layout = go.Layout(
            title="3D Graph",
            autosize=True,
            showlegend=True,
            margin=dict(t=100),
            hovermode='closest'
        )

        # Combina os gráficos 3D de arestas, vértices e pesos em um único gráfico
        data = [trace_edges, trace_vertices, trace_weights]
        fig = go.Figure(data=data, layout=layout)

        # Exibe o gráfico 3D
        fig.show()





# Função para criar um objeto Graph a partir de um arquivo
def graph_from_file(file_path: str = "", separator: str = " ", directed: bool = False) -> Graph:
    # Cria uma instância da classe Graph, com a opção de ser direcionado ou não
    graph = Graph(directed)
    
    # Função lambda para dividir uma string usando o separador fornecido e converter cada parte em inteiro
    split = lambda string: [*map(int, string.split(separator))]

    # Abre o arquivo no caminho especificado e lê o conteúdo
    with open(file_path, "r") as file:
        # Itera sobre cada linha do arquivo
        for line in file.readlines():
            # Usa a função lambda para dividir a linha em partes e obter a lista de vértices como inteiros
            edge = split(line)
            
            # Verifica se a linha possui pelo menos dois elementos (dois vértices para formar uma aresta)
            if len(edge) > 1:
                # Extrai os dois vértices da linha
                a, b = edge
                
                # Adiciona a aresta entre os vértices 'a' e 'b' no objeto graph
                graph.add_edge(a, b)

    # Retorna o objeto graph criado a partir do arquivo
    return graph
