#include "arvB.h"
#include "avl.h"
#include "rubNeg.h"
#include <time.h>
#include <math.h>  // Para usar logaritmos

#define tam_max 10000 // número máximo de elementos em cada árvore
#define num_testes 10 // número de vezes que rodará cada conjunto
#define intervalo 100 // tamanho do intervalo para acréscimo da quantidade de elementos

// função para verificar se o número gerado aleatoriamente já foi criado
int existe_no_vetor(int *vet, int tam, int valor){
    for(int i = 0; i < tam; i++){
        if(vet[i] == valor){
            return 1;
        }
    }
    return 0;
}

void rodar_teste(Arvore* a, ArvoreRN* rn, ArvoreB* arvoreB, int tam, int* somatorio_add, int* somatorio_rem) {
    
    int vet_add[tam];
    int vet_rem[tam];
    int min = 0;
    int max = 10000;
    int num;

    // Gerar valores aleatórios para adicionar e remover
    for(int i = 0; i < tam; i++) {
        num = rand() % (max - min + 1) + min;
        while (existe_no_vetor(vet_add, i, num)) {
            num = rand() % (max - min + 1) + min;
        }
        vet_add[i] = num;
        vet_rem[i] = vet_add[i]; // os valores da remoção serão os mesmos
    }

    int contador_add[3] = {0, 0, 0}; // Contagem de comparações para adição
    int contador_rem[3] = {0, 0, 0}; // Contagem de comparações para remoção

    // Executa as adições e registra as comparações
    for(int i = 0; i < tam; i++) {
        adicionar_avl(a, vet_add[i], contador_add);
        adicionar(rn, vet_add[i], contador_add);
        adicionaChave(arvoreB, vet_add[i], contador_add);
        
    }
    
    // Captura as comparações para adição
    somatorio_add[0] = contador_add[0];
    somatorio_add[1] = contador_add[1];
    somatorio_add[2] = contador_add[2];

    // Executa as remoções e registra as comparações
    for(int i = 0; i < tam; i++) {
        remover_avl(a, vet_rem[i], contador_rem);
        remover(rn, vet_rem[i], contador_rem);
        //removeChave(arvoreB, vet_rem[i], contador_rem);  // arvore B comentado pois da erros
    }

    // Captura as comparações para remoção
    somatorio_rem[0] = contador_rem[0];
    somatorio_rem[1] = contador_rem[1];
    somatorio_rem[2] = contador_rem[2];

}

void rodar_experimento(FILE* arquivo_adicao, FILE* arquivo_remocao) {
    for (int tam = intervalo; tam <= tam_max; tam += intervalo) {
        // Inicializando os acumuladores para os testes
        int total_add[3] = {0, 0, 0}; // Para acumular os contadores de adição
        int total_rem[3] = {0, 0, 0}; // Para acumular os contadores de remoção

        for (int i = 0; i < num_testes; i++) {
            Arvore* a = criar(); // cria a árvore AVL
            ArvoreB* arvoreB = criaArvoreB(10);
            ArvoreRN* rn = criarRN();
            rodar_teste(a, rn, arvoreB, tam, total_add, total_rem); // roda o teste para AVL
            destruir_avl(a); // destrói a árvore AVL
        }

        // Média das comparações por operação
        float media_add[3];
        float media_rem[3];
        for (int i = 0; i < 3; i++) {
            media_add[i] = total_add[i] / num_testes;
            media_rem[i] = total_rem[i] / num_testes;
        }

        // media_add[0] representa os valores da AVL
        // media_add[1] da RN 
        // media_add[2] da B

        // Registra os resultados logaritmicamente
        //double log_tam = log(tam);
        fprintf(arquivo_adicao, "%d,%lf,%lf,%lf\n", tam, media_add[0], media_add[1], media_add[2]); 
        fprintf(arquivo_remocao, "%d,%lf,%lf,%lf\n", tam, media_rem[0], media_rem[1], media_rem[2]);
    }
}

int main() {
    FILE *arquivo_adicao, *arquivo_remocao;

    const char *nome_arquivo_adicao = "resultados_adicao.csv";
    const char *nome_arquivo_remocao = "resultados_remocao.csv";

    arquivo_adicao = fopen(nome_arquivo_adicao, "w");
    arquivo_remocao = fopen(nome_arquivo_remocao, "w");
    if (arquivo_adicao == NULL || arquivo_remocao == NULL) {
        printf("Erro ao abrir os arquivos!\n");
        return 1;
    }

 // Cabeçalho dos CSVs
    fprintf(arquivo_adicao, "Tamanho da árvore, Comparações Adição AVL, Comparações Adição RN, Comparações Adição B\n");
    fprintf(arquivo_remocao, "Tamanho da árvore, Comparações Remoção AVL, Comparações Remoção RN,  Comparações Remoção B\n");

    srand(time(NULL));

    rodar_experimento(arquivo_adicao, arquivo_remocao);

    fclose(arquivo_adicao);
    fclose(arquivo_remocao);
    
    printf("Experimento concluído! Resultados gravados em %s e %s\n", nome_arquivo_adicao, nome_arquivo_remocao);
    
    return 0;
}