#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <math.h> 

#define TAMANHO_MAX_MAPA_LINHAS 50
#define TAMANHO_MAX_MAPA_COLUNAS 60 
#define COMPRIMENTO_MAX_CAMINHO (TAMANHO_MAX_MAPA_LINHAS * TAMANHO_MAX_MAPA_COLUNAS)

typedef struct {
    int linha, coluna;
} Ponto;

char mapa[TAMANHO_MAX_MAPA_LINHAS][TAMANHO_MAX_MAPA_COLUNAS];
int num_linhas_mapa, num_colunas_mapa; 

Ponto caminho_encontrado[COMPRIMENTO_MAX_CAMINHO];
int comprimento_caminho = 0;

int no_caminho_atual[TAMANHO_MAX_MAPA_LINHAS][TAMANHO_MAX_MAPA_COLUNAS];

void imprimir_mapa_interno() { // Função para imprimir o mapa armazenado internamente
    printf("--- Conteudo Interno do Mapa (%dx%d) ---\n", num_linhas_mapa, num_colunas_mapa);
    for (int i = 0; i < num_linhas_mapa; ++i) {
        printf("[%02d] ", i); // Imprime o número da linha para facilitar a depuração
        for (int j = 0; j < num_colunas_mapa; ++j) {
            printf("%c", mapa[i][j]);
        }
        printf("\n");
    }
    printf("---------------------------------------------------------------------------\n");
}


int carregar_mapa(const char* nome_arquivo) { // Função para carregar o mapa de um arquivo de texto
    FILE* arquivo = fopen(nome_arquivo, "r");
    if (!arquivo) {
        perror("Erro ao abrir o arquivo do mapa");
        return 0;
    }

    num_linhas_mapa = 0;
    num_colunas_mapa = 0; // Será determinado pela primeira linha válida
    char buffer_linha[TAMANHO_MAX_MAPA_COLUNAS + 2]; // +1 para \n, +1 para \0

    while (num_linhas_mapa < TAMANHO_MAX_MAPA_LINHAS && fgets(buffer_linha, sizeof(buffer_linha), arquivo) != NULL) {
        // Remove o caractere de nova linha, se presente
        buffer_linha[strcspn(buffer_linha, "\r\n")] = '\0'; // Remove \n ou \r\n

        int comprimento_linha_atual = strlen(buffer_linha);

        if (comprimento_linha_atual == 0 && feof(arquivo)) { // Linha vazia no final do arquivo
            continue;
        }
        if (comprimento_linha_atual == 0) {
            fprintf(stderr, "Aviso: Linha %d vazia encontrada no mapa.\n", num_linhas_mapa + 1);
            continue; // Pula linhas vazias no meio, mas idealmente não deveriam existir
        }


        if (num_linhas_mapa == 0) { // Primeira linha lida (não vazia)
            num_colunas_mapa = comprimento_linha_atual;
            if (num_colunas_mapa > TAMANHO_MAX_MAPA_COLUNAS) {
                fprintf(stderr, "Erro: A primeira linha do mapa excede TAMANHO_MAX_MAPA_COLUNAS (%d).\n", TAMANHO_MAX_MAPA_COLUNAS);
                fclose(arquivo);
                return 0;
            }
        } else {
            // Verifica se as linhas subsequentes têm o mesmo comprimento
            if (comprimento_linha_atual != num_colunas_mapa) {
                fprintf(stderr, "Erro: Linha %d do mapa tem comprimento %d, esperado %d.\n",
                        num_linhas_mapa + 1, comprimento_linha_atual, num_colunas_mapa);
                fclose(arquivo);
                return 0;
            }
        }

        // Copia os caracteres da linha lida para a matriz 'mapa'
        for (int c = 0; c < num_colunas_mapa; ++c) {
            mapa[num_linhas_mapa][c] = buffer_linha[c];
        }
        num_linhas_mapa++;
    }
    fclose(arquivo);

    if (num_linhas_mapa == 0) {
        fprintf(stderr, "Mapa vazio ou nao pode ser lido.\n");
        return 0;
    }
    printf("Mapa carregado: %d linhas, %d colunas\n", num_linhas_mapa, num_colunas_mapa);
    //imprimir_mapa_interno();
    return 1;
}


Ponto encontrar_zero_na_linha(int linha_alvo) {  // Função para encontrar o único '0' em uma linha específica
    Ponto p_encontrado = {-1, -1};
    if (linha_alvo >= 0 && linha_alvo < num_linhas_mapa) {
        for (int c = 0; c < num_colunas_mapa; ++c) {
            if (mapa[linha_alvo][c] == '0') {
                p_encontrado.linha = linha_alvo;
                p_encontrado.coluna = c;
                break;
            }
        }
    }
    return p_encontrado; // retorna a cordenada do ponto de inicio
}


int distancia_manhattan(Ponto p1, Ponto p2) { // Heurística: Distância de Manhattan
    return abs(p1.linha - p2.linha) + abs(p1.coluna - p2.coluna);
}


int eh_movimento_valido(int linha, int coluna) { // Verifica se um movimento para (linha, coluna) é válido
    return linha >= 0 && linha < num_linhas_mapa && coluna >= 0 && coluna < num_colunas_mapa &&
           mapa[linha][coluna] == '0' &&
           no_caminho_atual[linha][coluna] == 0;
}


int encontrar_caminho_recursivo(Ponto ponto_atual, Ponto ponto_final) {  // Função recursiva principal para encontrar o caminho
    caminho_encontrado[comprimento_caminho++] = ponto_atual;
    no_caminho_atual[ponto_atual.linha][ponto_atual.coluna] = 1;

    if (ponto_atual.linha == ponto_final.linha && ponto_atual.coluna == ponto_final.coluna) {
        return 1;
    }

    int delta_linha[] = {0, 1, 0, -1};
    int delta_coluna[] = {1, 0, -1, 0};

    Ponto melhor_proximo_movimento = {-1, -1};
    int menor_distancia_ao_fim = 1000000;

    for (int i = 0; i < 4; ++i) {
        int proxima_linha = ponto_atual.linha + delta_linha[i];
        int proxima_coluna = ponto_atual.coluna + delta_coluna[i];

        if (eh_movimento_valido(proxima_linha, proxima_coluna)) {
            Ponto vizinho = {proxima_linha, proxima_coluna};
            int distancia = distancia_manhattan(vizinho, ponto_final);
            if (distancia < menor_distancia_ao_fim) {
                menor_distancia_ao_fim = distancia;
                melhor_proximo_movimento = vizinho;
            }
        }
    }

    if (melhor_proximo_movimento.linha != -1) {
        if (encontrar_caminho_recursivo(melhor_proximo_movimento, ponto_final)) {
            return 1;
        }
    }

    comprimento_caminho--;
    no_caminho_atual[ponto_atual.linha][ponto_atual.coluna] = 0;
    return 0;
}


void imprimir_mapa_com_solucao(Ponto inicio_real, Ponto fim_real) {
    printf("\nResultado:\n");
    for (int i = 0; i < num_linhas_mapa; ++i) {
        for (int j = 0; j < num_colunas_mapa; ++j) {
            char char_para_imprimir = mapa[i][j];
            int eh_ponto_do_caminho = 0;

            // Verifica se o ponto (i,j) está no caminho encontrado
            // Não marca S ou E como # se forem parte do caminho, eles têm prioridade
            if (!(i == inicio_real.linha && j == inicio_real.coluna) &&
                !(i == fim_real.linha && j == fim_real.coluna)) {
                for (int k = 0; k < comprimento_caminho; ++k) {
                    if (caminho_encontrado[k].linha == i && caminho_encontrado[k].coluna == j) {
                        eh_ponto_do_caminho = 1;
                        break;
                    }
                }
            }

            if (i == inicio_real.linha && j == inicio_real.coluna) {
                printf("E");  // Entrada
            } else if (i == fim_real.linha && j == fim_real.coluna) {
                printf("S");  // Saida
            } else if (eh_ponto_do_caminho) {
                printf(".");
            } else {
                printf("%c", char_para_imprimir);
            }
        }
        printf("\n");
    }
}


int main() {
    if (!carregar_mapa("mapa01.txt")) {
        return 1;
    }

    Ponto inicio = encontrar_zero_na_linha(0);
    if (inicio.linha == -1) {
        fprintf(stderr, "Erro: Nao foi possivel encontrar o ponto de inicio '0' na primeira linha.\n");
        imprimir_mapa_interno(); // Imprime o que foi carregado para ajudar na depuração
        return 1;
    }
    printf("Ponto de inicio encontrado em: (%d, %d)\n", inicio.linha, inicio.coluna);

    Ponto fim = encontrar_zero_na_linha(num_linhas_mapa - 1);
    if (fim.linha == -1) {
        fprintf(stderr, "Erro: Nao foi possivel encontrar o ponto de fim '0' na ultima linha.\n");
        imprimir_mapa_interno(); // Imprime o que foi carregado para ajudar na depuração
        return 1;
    }
    printf("Ponto de fim encontrado em: (%d, %d)\n", fim.linha, fim.coluna);


    memset(no_caminho_atual, 0, sizeof(no_caminho_atual));

    if (encontrar_caminho_recursivo(inicio, fim)) {
        printf("\nCaminho encontrado (%d passos).\n", comprimento_caminho);
        imprimir_mapa_com_solucao(inicio, fim);
    } else {
        printf("\nNenhum caminho encontrado entre (%d,%d) e (%d,%d).\n",
               inicio.linha, inicio.coluna, fim.linha, fim.coluna);
        imprimir_mapa_com_solucao(inicio, fim); // Imprime o mapa com S e E mesmo sem caminho
    }

    return 0;
}