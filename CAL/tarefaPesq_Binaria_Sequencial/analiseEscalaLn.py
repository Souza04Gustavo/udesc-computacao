import matplotlib.pyplot as plt
import numpy as np

# Listas para armazenar os dados
tamanhos = []
comparacoes_seq = []
comparacoes_bin = []

# Leitura do arquivo gerado pelo código C
with open("resultados.txt", "r") as arquivo:
    for linha in arquivo:
        tamanho, seq, bin = map(int, linha.split())
        tamanhos.append(tamanho)
        comparacoes_seq.append(seq)
        comparacoes_bin.append(bin)

# Criando o gráfico
plt.figure(figsize=(8, 5))
plt.plot(tamanhos, comparacoes_seq, label="Pesquisa Sequencial (O(n))", marker='o', linestyle='-')
plt.plot(tamanhos, comparacoes_bin, label="Pesquisa Binária (O(log n))", marker='s', linestyle='-')

plt.xlabel("Tamanho do Vetor (N)")
plt.ylabel("Número de Comparações (log scale)")
plt.title("Custo Computacional da Pesquisa Sequencial vs Binária")
plt.legend()
plt.grid()

# Aplica escala logarítmica no eixo Y
plt.yscale("log")

plt.show()
