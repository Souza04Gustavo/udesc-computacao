#include "arvB.h"

ArvoreB* criaArvoreB(int ordem){
    ArvoreB* a = malloc(sizeof(ArvoreB));
    a->ordem = ordem;
    a->raiz = criaNoB(a);

    return a;
}

NoB* criaNoB(ArvoreB* arvore){
    int max = arvore->ordem * 2;
    NoB* no = malloc(sizeof(NoB));

    no->pai = NULL;

    no->chaves = malloc(sizeof(int) * (max + 1));
    no->filhos = malloc(sizeof(NoB*) * (max + 2)); // não teria que ser um sizeof(NoB*)? n sei, aparentemente n
    no->total_chaves = 0;

    for(int i = 0; i < max + 2; i++){
        no->filhos[i] = NULL;
    }

    return no;
}

void percorreArvoreB(NoB* no, void (visita)(int chave)){
    if(no != NULL) {
        for (int i = 0; i < no->total_chaves; i++){
            percorreArvoreB(no->filhos[i], visita);

            visita(no->chaves[i]);
        }

        percorreArvoreB(no->filhos[no->total_chaves], visita);
    }
}

void imprime(int chave){
    printf("%d ", chave);
}

int loclizaChave(ArvoreB* arvore, int chave){
    NoB*  no = arvore->raiz;

    while (no != NULL){
        int i = pesquisaBinaria(no, chave);

        if (i < no->total_chaves && no->chaves[i] == chave){
            return 1; // encontrou
        } else {
            no = no->filhos[i];
        }
    }
    return 0; // não encontrou
}

int pesquisaBinaria(NoB* no, int chave){
    int inicio = 0, fim = no->total_chaves - 1, meio;
    while(inicio <= fim){
        meio = (inicio + fim)/2;
        if(no->chaves[meio] == chave){
            return meio; // encontrou
        } else if (no->chaves[meio] > chave){
            fim = meio -1;
        } else {
            inicio = meio + 1;
        }
    }
    return inicio; // não encontrou
}

NoB* localizaNoB(ArvoreB* arvore, int chave){
    NoB* no = arvore->raiz;

    while(no != NULL){
        int i = pesquisaBinaria(no, chave);

        if (no->filhos[i] == NULL)
            return no; // encontroub nó
        else
            no = no->filhos[i];
    }

    return NULL; // não encontrou nenhum nó
}


int transbordo(ArvoreB* arvore, NoB* no){
    return no->total_chaves > arvore->ordem * 2;
}

NoB* divideNoB(ArvoreB* arvore, NoB* no){
    int meio = no->total_chaves / 2;
    NoB* novo = criaNoB(arvore);
    novo->pai = no->pai;

    for (int i = meio + 1; i < no->total_chaves; i++){
        novo->filhos[novo->total_chaves] = no->filhos[i];
        novo->chaves[novo->total_chaves] = no->chaves[i];
        if(novo->filhos[novo->total_chaves] != NULL)
            novo->filhos[novo->total_chaves]->pai = novo;
        novo->total_chaves++;
    }

    novo->filhos[novo->total_chaves] = no->filhos[no->total_chaves];
    if(novo->filhos[novo->total_chaves] != NULL)
        novo->filhos[novo->total_chaves]->pai = novo;
    no->total_chaves = meio;
    return novo;
}

void adicionaChaveNo(NoB* no, NoB* direita, int chave, int* contador){
    int i = pesquisaBinaria(no, chave);

    contador[2]++;
    for (int j = no->total_chaves - 1; j >= i; j--){
        no->chaves[j + 1] = no->chaves[j];
        no->filhos[j + 2] = no->filhos[j + 1];
        contador[2]++;
    }

    no->chaves[i] = chave;
    no->filhos[i + 1] = direita;

    //contador[2]++;
    no-> total_chaves++;
}

void adicionaChave(ArvoreB* arvore, int chave, int* contador){
    NoB* no = localizaNoB(arvore, chave);
    contador[2]++;
    adicionaChaveRecursivo(arvore, no, NULL, chave, contador);
}

void adicionaChaveRecursivo(ArvoreB* arvore, NoB* no, NoB* novo, int chave, int* contador){
    adicionaChaveNo(no, novo, chave, contador);
    //contador[2]++;
    if (transbordo(arvore, no)){
        int promovido = no->chaves[arvore->ordem];
        contador[2]++;
        NoB* novo = divideNoB(arvore, no);
        
        contador[2]++;
        if(no->pai == NULL){
            NoB* raiz = criaNoB(arvore);
            raiz->filhos[0] = no;
            adicionaChaveNo(raiz, novo, promovido, contador);// diferente do slide

            no->pai = raiz;
            novo->pai = raiz;
            arvore->raiz = raiz;
        } else {
            adicionaChaveRecursivo(arvore, no->pai, novo, promovido, contador);
        }
    }
}

void removeChaveFolha(NoB* no, int chave){
    int i = pesquisaBinaria(no, chave);

    for(int j = i + 1; j < no->total_chaves; j++){
        no->chaves[j - 1] = no->chaves[j];
    }
    no->total_chaves--;
}

void removeChave(ArvoreB* arvore, int chave, int* contador) {
    NoB* raiz = arvore->raiz;

    if (raiz == NULL) {
        printf("A árvore está vazia.\n");
        return;
    }

    removeChaveRecursivo(arvore, raiz, chave, contador);

    // raiz ficou vazia e não é folha
    if(raiz->total_chaves == 0){
        if(raiz->filhos[0] != NULL){
            arvore->raiz = raiz->filhos[0];
            free(raiz);
        } else{
            arvore->raiz = NULL; //raiz nao existe
        }
    }
}
void removeChaveRecursivo(ArvoreB* arvore, NoB* no, int chave, int* contador) {
    int i = pesquisaBinaria(no, chave);

    // Caso 1: A chave está em uma folha
    if (no->filhos[0] == NULL) {
        if (i < no->total_chaves && no->chaves[i] == chave) {
            // Remover a chave do nó folha
            removeChaveFolha(no, chave);
            contador[3]++;  // Contabiliza a remoção
            printf("\nCaso 1\n");
        } else {
            printf("\nChave %d não encontrada.\n", chave);
        }
        return;
    }

    // Caso 2: A chave está em um nó interno
    if (i < no->total_chaves && no->chaves[i] == chave) {
        NoB* filhoEsq = no->filhos[i];
        NoB* filhoDir = no->filhos[i + 1];

        if (filhoEsq->total_chaves >= arvore->ordem) { 
            // Caso 2a: Substituir pelo predecessor
            int predecessor = encontraPredecessor(filhoEsq);
            no->chaves[i] = predecessor;
            contador[3]++;  // Contabiliza a remoção do predecessor
            printf("\nCaso 2a\n");
            removeChaveRecursivo(arvore, filhoEsq, predecessor, contador);
        } else if (filhoDir->total_chaves >= arvore->ordem) {
            // Caso 2b: Substituir pelo sucessor
            int sucessor = encontraSucessor(filhoDir);
            no->chaves[i] = sucessor;
            contador[3]++;  // Contabiliza a remoção do sucessor
            printf("\nCaso 2b\n");
            removeChaveRecursivo(arvore, filhoDir, sucessor, contador);
        } else {
            // Caso 2c: Fusão de filhos
            fundirNos(arvore, no, i, contador);
            printf("\nCaso 2c\n");
            removeChaveRecursivo(arvore, filhoEsq, chave, contador);
        }
        return;
    }

    // Caso 3: A chave não está no nó
    NoB* filho = no->filhos[i];
    if (filho->total_chaves == arvore->ordem - 1) {
        
        NoB* irmaoEsq = (i > 0) ? no->filhos[i - 1] : NULL;
        NoB* irmaoDir = (i < no->total_chaves) ? no->filhos[i + 1] : NULL;

        if (irmaoEsq != NULL && irmaoEsq->total_chaves >= arvore->ordem) {
            // Caso 3a: Redistribuir do irmão esquerdo
            printf("\nCaso 3a(esq)\n");
            redistribuirEsquerda(no, filho, irmaoEsq, i, contador);
        } else if (irmaoDir != NULL && irmaoDir->total_chaves >= arvore->ordem) {
            printf("\nCaso 3a (dir)\n");
            redistribuirDireita(no, filho, irmaoDir, i, contador);
        } else {
            printf("\nCaso 3b\n");
            if (irmaoEsq != NULL) {
                fundirNos(arvore, no, i - 1, contador);
                filho = irmaoEsq;
            } else {
                fundirNos(arvore, no, i, contador);
            }
        }
    }

    // Continuar a busca recursivamente
    removeChaveRecursivo(arvore, filho, chave, contador);
}

int encontraPredecessor(NoB* no) {
    while (no->filhos[no->total_chaves] != NULL) {
        no = no->filhos[no->total_chaves];
    }
    return no->chaves[no->total_chaves - 1];
}

int encontraSucessor(NoB* no) {
    while (no->filhos[0] != NULL) {
        no = no->filhos[0];
    }
    return no->chaves[0];
}

void fundirNos(ArvoreB* arvore, NoB* no, int indice, int* contador) {
    NoB* filhoEsq = no->filhos[indice];
    NoB* filhoDir = no->filhos[indice + 1];

    filhoEsq->chaves[filhoEsq->total_chaves] = no->chaves[indice];  // trocar chave do pai para o filho esquerdo

    //  Copiando chaves e filhos do irmao direito para o filho esquerdo
    for (int i = 0; i < filhoDir->total_chaves; i++) {
        filhoEsq->chaves[filhoEsq->total_chaves + 1 + i] = filhoDir->chaves[i];
        filhoEsq->filhos[filhoEsq->total_chaves + 1 + i] = filhoDir->filhos[i];
        if (filhoDir->filhos[i] != NULL) { 
            filhoDir->filhos[i]->pai = filhoEsq; 
        }
    }
    filhoEsq->filhos[filhoEsq->total_chaves + 1 + filhoDir->total_chaves] = filhoDir->filhos[filhoDir->total_chaves];

    filhoEsq->total_chaves += filhoDir->total_chaves + 1;

    // Ajustando chaves do pai para armazenar os corretos
    for (int i = indice + 1; i < no->total_chaves; i++) {
        no->chaves[i - 1] = no->chaves[i];
        no->filhos[i] = no->filhos[i + 1];
    } 
    no->total_chaves--; //diminuir porque fundiu dois nós

    free(filhoDir);
    contador[3]++;  // Contabiliza a fusão dos nós
}

void redistribuirEsquerda(NoB* pai, NoB* filho, NoB* irmao, int indice, int* contador) {
    if(filho->total_chaves >= 1){
        for (int i = filho->total_chaves; i > 0; i--) {
            filho->chaves[i] = filho->chaves[i - 1];
            filho->filhos[i + 1] = filho->filhos[i]; //substituição simples, da direita recebe o anterior
        }
    }
    
    if(filho->filhos[0] != NULL){
        filho->filhos[0]->pai = filho;
    }
    filho->filhos[1] = filho->filhos[0];
    filho->chaves[0] = pai->chaves[indice];
    pai->chaves[indice] = irmao->chaves[irmao->total_chaves - 1];
    filho->filhos[0] = irmao->filhos[irmao->total_chaves];
    if (irmao->filhos[irmao->total_chaves] != NULL) {
        irmao->filhos[irmao->total_chaves]->pai = filho;
    }
    filho->total_chaves++;
    irmao->total_chaves--;
    contador[3]++;  // Contabiliza a redistribuição
}

void redistribuirDireita(NoB* pai, NoB* filho, NoB* irmao, int indice, int* contador) {
    filho->chaves[filho->total_chaves] = pai->chaves[indice];
    filho->filhos[filho->total_chaves + 1] = irmao->filhos[0];
    pai->chaves[indice] = irmao->chaves[0];

    for (int i = 1; i < irmao->total_chaves; i++) {
        irmao->chaves[i - 1] = irmao->chaves[i];
        irmao->filhos[i - 1] = irmao->filhos[i];
    }
    irmao->filhos[irmao->total_chaves - 1] = irmao->filhos[irmao->total_chaves];
    irmao->total_chaves--;
    filho->total_chaves++;
    contador[3]++;  // Contabiliza a redistribuição
}


void imprimeDetalhesNo(NoB* no, int nivel) {
    if (no == NULL) {
        return;
    }

    // Imprimir as chaves do nó
    printf("Nível %d: Nó com %d chave(s): [", nivel, no->total_chaves);
    for (int i = 0; i < no->total_chaves; i++) {
        printf("%d", no->chaves[i]);
        if (i < no->total_chaves - 1)
            printf(", ");
    }
    printf("]\n");

    

    // Imprimir os filhos por recurs
    for (int i = 0; i <= no->total_chaves; i++) {
        imprimeDetalhesNo(no->filhos[i], nivel + 1);
    }
}

// Função para imprimir a partir da raiz
void imprimeDetalhesArvore(ArvoreB* arvore) {
    if (arvore == NULL || arvore->raiz == NULL) {
        printf("A árvore está vazia.\n");
        return;
    }

    printf("------ Detalhes da Árvore ------\n");
    imprimeDetalhesNo(arvore->raiz, 0);
    printf("--------------------------------\n");
}

/*
// verifica a existencia do valor no vetor
int existe_no_vetor(int* vet, int tam, int valor){

    for(int i = 0; i < tam; i++){
        if(vet[i] == valor){
            return 1;
        }
    }
    return 0;
}

void tira_vetor(int* vet, int* tam, int valor){
    int indice = -1;
    for(int i = 0; i < *tam ; i++){
        if(vet[i] == valor){
            indice = i;
            break;
        }
    }

    if(indice == -1){
        return;
    }
    for(int i = indice; i < *tam; i++){
        vet[i] = vet[i+1];
    }

    (*tam)--;
    vet[*tam] = 0;

}
*/