#include <stdio.h>
#include <stdlib.h>

// Função que calcula 2^n de forma simples e direta
int potencia_de_dois(int n) {
    int resultado = 1;
    for (int i = 0; i < n; i++) {
        resultado *= 2;  // Multiplica por 2 para cada bit
    }
    return resultado;
}

// Função que calcula e imprime o conjunto das partes (powerset)
void powerset(int* v, int tamanho) {
    // Total de subconjuntos = 2^tamanho, calculado de forma simples
    int total = potencia_de_dois(tamanho);

    // Aloca a matriz m para armazenar os subconjuntos
    int** m = malloc(sizeof(int*) * total);
    for (int i = 0; i < total; i++) {
        m[i] = malloc(sizeof(int) * tamanho);
    }

    // Gera o conjunto das partes
    for (int i = 0; i < total; i++) {
        int index = 0;
        for (int j = 0; j < tamanho; j++) {
            // Verifica se o bit j está definido no índice i
            if (i & (1 << j)) {
                m[i][index++] = v[j];
            }
        }
        // Marca o final da lista do subconjunto
        m[i][index] = -1;
    }

    // Imprime os subconjuntos
    for (int i = 0; i < total; i++) {
        printf("[");
        int primeiro = 1;  // Controla a vírgula na impressão dos elementos

        for (int j = 0; m[i][j] != -1; j++) {
            if (!primeiro)
                printf(", ");
            printf("%d", m[i][j]);
            primeiro = 0;
        }
        printf("]\n");
    }

    // Libera a memória alocada
    for (int i = 0; i < total; i++) {
        free(m[i]);
    }
    free(m);
}

int main() {
    int v[] = {1, 2, 3, 4};  // Vetor de entrada
    powerset(v, 4);       // Chama a função com o vetor e seu tamanho
    return 0;
}
