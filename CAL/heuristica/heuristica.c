#include <stdio.h>
#include <stdlib.h>
#include <string.h> // Para memset
#include <math.h>   // Para abs (valor absoluto)

#define TAMANHO_MAX_MAPA 100      // Define um tamanho máximo razoável para o mapa
#define COMPRIMENTO_MAX_CAMINHO (TAMANHO_MAX_MAPA * TAMANHO_MAX_MAPA) // Caminho máximo possível

// Estrutura para representar um ponto com coordenadas (linha, coluna)
typedef struct {
    int linha, coluna;
} Ponto;

// Mapa do jogo/problema. '0' é caminho livre, '1' é obstáculo.
char mapa[TAMANHO_MAX_MAPA][TAMANHO_MAX_MAPA];
int num_linhas, num_colunas; // Dimensões reais do mapa carregado

// Array para armazenar os pontos do caminho encontrado
Ponto caminho_encontrado[COMPRIMENTO_MAX_CAMINHO];
int comprimento_caminho = 0; // Número atual de pontos no caminho_encontrado

// Grid auxiliar para marcar células que já estão no caminho atual da busca.
// Ajuda a evitar ciclos e a não revisitar o mesmo ponto na tentativa atual.
// 1 se está no caminho atual, 0 caso contrário.
int no_caminho_atual[TAMANHO_MAX_MAPA][TAMANHO_MAX_MAPA];

// Função para carregar o mapa de um arquivo de texto
int carregar_mapa(const char* nome_arquivo) {
    FILE* arquivo = fopen(nome_arquivo, "r");
    if (!arquivo) {
        perror("Erro ao abrir o arquivo do mapa");
        return 0; // Retorna 0 em caso de falha
    }

    num_linhas = 0;
    char buffer_linha[TAMANHO_MAX_MAPA + 2]; // +1 para char, +1 para '\0'

    // Lê o arquivo linha por linha
    while (num_linhas < TAMANHO_MAX_MAPA && fgets(buffer_linha, sizeof(buffer_linha), arquivo) != NULL) {
        if (num_linhas == 0) { // Na primeira linha, determina o número de colunas
            num_colunas = 0;
            while (buffer_linha[num_colunas] != '\n' && buffer_linha[num_colunas] != '\0' && num_colunas < TAMANHO_MAX_MAPA) {
                num_colunas++;
            }
        }
        // Copia os caracteres da linha lida para a matriz 'mapa'
        for (int c = 0; c < num_colunas && c < TAMANHO_MAX_MAPA; ++c) {
            mapa[num_linhas][c] = buffer_linha[c];
        }
        num_linhas++;
    }
    fclose(arquivo);

    if (num_linhas == 0 || num_colunas == 0) {
        fprintf(stderr, "Mapa vazio ou invalido.\n");
        return 0;
    }
    return 1; // Retorna 1 em caso de sucesso
}

// Função para imprimir o mapa atual com o caminho percorrido até o momento
void imprimir_mapa_com_caminho(Ponto inicio, Ponto fim) {
    for (int i = 0; i < num_linhas; ++i) {
        for (int j = 0; j < num_colunas; ++j) {
            int esta_no_caminho_flag = 0;
            // Verifica se a coordenada (i,j) está no caminho_encontrado
            for(int k=0; k < comprimento_caminho; ++k) {
                if (caminho_encontrado[k].linha == i && caminho_encontrado[k].coluna == j) {
                    esta_no_caminho_flag = 1;
                    break;
                }
            }

            if (i == inicio.linha && j == inicio.coluna) printf("S"); // Ponto inicial
            else if (i == fim.linha && j == fim.coluna) printf("E");   // Ponto final
            else if (esta_no_caminho_flag) printf("*");                // Ponto no caminho
            else printf("%c", mapa[i][j]);                             // Célula do mapa
        }
        printf("\n");
    }
    printf("--------------------\n");
}


// Heurística: Distância de Manhattan.
// Calcula a "distância em quarteirões" entre dois pontos.
int distancia_manhattan(Ponto p1, Ponto p2) {
    return abs(p1.linha - p2.linha) + abs(p1.coluna - p2.coluna);
}

// Verifica se um movimento para (linha, coluna) é válido:
// 1. Dentro dos limites do mapa.
// 2. Não é um obstáculo ('1').
// 3. Não está já marcado como parte do caminho atual da busca recursiva.
int eh_movimento_valido(int linha, int coluna) {
    return linha >= 0 && linha < num_linhas && coluna >= 0 && coluna < num_colunas &&
           mapa[linha][coluna] == '0' &&
           no_caminho_atual[linha][coluna] == 0;
}

// Função recursiva principal para encontrar o caminho.
// Tenta encontrar um caminho do 'ponto_atual' até o 'ponto_final'.
// Retorna 1 se um caminho é encontrado, 0 caso contrário.
int encontrar_caminho_simples(Ponto ponto_atual, Ponto ponto_final) {
    // Adiciona o ponto atual ao caminho e marca como visitado nesta tentativa
    caminho_encontrado[comprimento_caminho++] = ponto_atual;
    no_caminho_atual[ponto_atual.linha][ponto_atual.coluna] = 1;

    // Condição de parada: chegou ao destino
    if (ponto_atual.linha == ponto_final.linha && ponto_atual.coluna == ponto_final.coluna) {
        return 1; // Sucesso!
    }

    // Define as direções de movimento: Direita, Baixo, Esquerda, Cima.
    // A ordem pode influenciar o caminho encontrado, mas não a sua existência.
    int delta_linha[] = {0, 1, 0, -1}; // Variação na linha para cada direção
    int delta_coluna[] = {1, 0, -1, 0}; // Variação na coluna para cada direção

    Ponto melhor_proximo_movimento = {-1, -1}; // Guarda o melhor vizinho encontrado
    int menor_distancia_ao_fim = 1000000;    // Inicializa com um valor bem grande

    // Explora os vizinhos (guloso: tenta o que parece mais promissor primeiro)
    for (int i = 0; i < 4; ++i) { // Para cada uma das 4 direções
        int proxima_linha = ponto_atual.linha + delta_linha[i];
        int proxima_coluna = ponto_atual.coluna + delta_coluna[i];

        if (eh_movimento_valido(proxima_linha, proxima_coluna)) {
            Ponto vizinho = {proxima_linha, proxima_coluna};
            int distancia = distancia_manhattan(vizinho, ponto_final);

            // Se este vizinho está mais perto do fim do que os anteriores testados
            if (distancia < menor_distancia_ao_fim) {
                menor_distancia_ao_fim = distancia;
                melhor_proximo_movimento = vizinho;
            }
        }
    }

    // Se um movimento promissor (melhor_proximo_movimento) foi encontrado
    if (melhor_proximo_movimento.linha != -1) {
        // Tenta recursivamente a partir deste melhor movimento
        if (encontrar_caminho_simples(melhor_proximo_movimento, ponto_final)) {
            return 1; // Se a recursão teve sucesso, propaga o sucesso
        }
    }

    // Backtracking: Se chegou aqui, significa que:
    // 1. Não havia vizinhos válidos a partir do 'ponto_atual', ou
    // 2. O 'melhor_proximo_movimento' explorado não levou a uma solução (caiu num beco sem saída).
    // Então, remove o 'ponto_atual' do caminho e desmarca como visitado nesta tentativa.
    comprimento_caminho--;
    no_caminho_atual[ponto_atual.linha][ponto_atual.coluna] = 0;
    return 0; // Indica falha a partir deste ponto
}


int main() {
    if (!carregar_mapa("mapa01.txt")) {
        return 1; // Termina se o mapa não puder ser carregado
    }

    printf("Mapa Carregado (%d linhas, %d colunas):\n", num_linhas, num_colunas);

    Ponto inicio, fim;
    // Solicita ao usuário as coordenadas de início e fim
    printf("Digite a linha de inicio (0 a %d): ", num_linhas - 1);
    scanf("%d", &inicio.linha);
    printf("Digite a coluna de inicio (0 a %d): ", num_colunas - 1);
    scanf("%d", &inicio.coluna);

    printf("Digite a linha de destino (0 a %d): ", num_linhas - 1);
    scanf("%d", &fim.linha);
    printf("Digite a coluna de destino (0 a %d): ", num_colunas - 1);
    scanf("%d", &fim.coluna);

    // Validação básica dos pontos de entrada
    if (inicio.linha < 0 || inicio.linha >= num_linhas || inicio.coluna < 0 || inicio.coluna >= num_colunas ||
        fim.linha < 0 || fim.linha >= num_linhas || fim.coluna < 0 || fim.coluna >= num_colunas ||
        mapa[inicio.linha][inicio.coluna] == '1' || mapa[fim.linha][fim.coluna] == '1') {
        fprintf(stderr, "Pontos de inicio ou destino invalidos ou sao obstaculos.\n");
        return 1;
    }

    // Inicializa o grid 'no_caminho_atual' com zeros (nenhum ponto no caminho ainda)
    memset(no_caminho_atual, 0, sizeof(no_caminho_atual));

    // Chama a função principal de busca
    if (encontrar_caminho_simples(inicio, fim)) {
        printf("\nCaminho encontrado (%d passos):\n", comprimento_caminho);
        for (int i = 0; i < comprimento_caminho; ++i) {
            printf("(%d, %d)", caminho_encontrado[i].linha, caminho_encontrado[i].coluna);
            if (i < comprimento_caminho - 1) {
                printf(" -> ");
            }
        }
        printf("\n\nMapa com o caminho:\n");
        imprimir_mapa_com_caminho(inicio, fim);

    } else {
        printf("\nNenhum caminho encontrado.\n");
    }

    return 0;
}