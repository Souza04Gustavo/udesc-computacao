#include <stdio.h>
#include <stdlib.h>

// Função de pesquisa sequencial com contagem de iterações
int pesquisa_sequencial(int arr[], int tamanho, int alvo, int *contador) {
    for (int i = 0; i < tamanho; i++) {
        (*contador)++; // Conta uma iteração
        if (arr[i] == alvo) {
            return i;
        }
    }
    return -1;
}

// Função de pesquisa binária com contagem de iterações
int pesquisa_binaria(int arr[], int inicio, int fim, int alvo, int *contador) {
    while (inicio <= fim) {
        (*contador)++; // Conta uma iteração
        int meio = inicio + (fim - inicio) / 2;

        if (arr[meio] == alvo) {
            return meio;
        }
        if (arr[meio] < alvo) {
            inicio = meio + 1;
        } else {
            fim = meio - 1;
        }
    }
    return -1;
}

int main() {
    int tamanhos[] = {100, 150, 200, 250}; // Diferentes tamanhos de vetores
    int num_tamanhos = sizeof(tamanhos) / sizeof(tamanhos[0]);

    FILE *arquivo = fopen("resultados.txt", "w"); // Abre o arquivo para escrita
    if (arquivo == NULL) {
        printf("Erro ao abrir o arquivo.\n");
        return 1;
    }

    // Itera sobre diferentes tamanhos de vetor
    for (int t = 0; t < num_tamanhos; t++) {
        int tamanho = tamanhos[t];
        int arr[tamanho];
        for (int i = 0; i < tamanho; i++) {
            arr[i] = i; // Preenchendo o vetor ordenado
        }

        int alvo = tamanho - 1; // Elemento a ser buscado (pior caso)

        int contador_seq = 0;
        pesquisa_sequencial(arr, tamanho, alvo, &contador_seq);

        int contador_bin = 0;
        pesquisa_binaria(arr, 0, tamanho - 1, alvo, &contador_bin);

        // Escreve os resultados no arquivo
        fprintf(arquivo, "%d %d %d\n", tamanho, contador_seq, contador_bin);
    }

    fclose(arquivo);
    printf("Resultados salvos em resultados.txt\n");
    return 0;
}
