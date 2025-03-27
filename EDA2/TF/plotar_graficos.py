import pandas as pd
import matplotlib.pyplot as plt

# Função para ler os dados dos arquivos CSV
def ler_dados(caminho_arquivo):
    df = pd.read_csv(caminho_arquivo)
    # Remove espaços extras ao redor dos nomes das colunas
    df.columns = df.columns.str.strip()  
    print(df.columns)  # Imprime os nomes das colunas para debug
    return df

# Função para plotar os gráficos
def plotar_graficos(adicao_csv, remocao_csv):
    # Lê os dados de adição e remoção
    df_adicao = ler_dados(adicao_csv)
    df_remocao = ler_dados(remocao_csv)

    # Adição - Gráfico
    plt.figure(figsize=(10, 6))
    plt.plot(df_adicao['Tamanho da árvore'], df_adicao['Comparações Adição AVL'], label='AVL Adição', color='blue')
    plt.plot(df_adicao['Tamanho da árvore'], df_adicao['Comparações Adição RN'], label='Rubro-Negra Adição', color='green')
    plt.plot(df_adicao['Tamanho da árvore'], df_adicao['Comparações Adição B'], label='Árvore B Adição', color='red')
    plt.title('Comparação de Adição - Árvores AVL, Rubro-Negra e B (Escala Logarítmica)')
    plt.xlabel('Tamanho da Árvore')
    plt.ylabel('Comparações de Adição')
    plt.yscale('log')  # Define o eixo Y em escala logarítmica
    plt.legend()
    plt.grid(True)

    # Remoção - Gráfico
    plt.figure(figsize=(10, 6))  # Nova figura para o gráfico de remoção
    plt.plot(df_remocao['Tamanho da árvore'], df_remocao['Comparações Remoção AVL'], label='AVL Remoção', color='blue')
    plt.plot(df_remocao['Tamanho da árvore'], df_remocao['Comparações Remoção RN'], label='Rubro-Negra Remoção', color='green')
    plt.plot(df_remocao['Tamanho da árvore'], df_remocao['Comparações Remoção B'], label='Árvore B Remoção', color='red')
    plt.title('Comparação de Remoção - Árvores AVL, Rubro-Negra e B (Escala Logarítmica)')
    plt.xlabel('Tamanho da Árvore')
    plt.ylabel('Comparações de Remoção')
    plt.yscale('log')  # Define o eixo Y em escala logarítmica
    plt.legend()
    plt.grid(True)

    plt.show()  # Chama show() apenas uma vez, após os dois gráficos estarem prontos

# Caminhos para os arquivos CSV
arquivo_adicao = 'resultados_adicao.csv'
arquivo_remocao = 'resultados_remocao.csv'

# Chama a função para plotar os gráficos
plotar_graficos(arquivo_adicao, arquivo_remocao)