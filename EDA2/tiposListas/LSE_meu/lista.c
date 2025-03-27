#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "arq.h"

struct descLSE * cria (int tamTotal){
    
    struct descLSE *desc = (struct descLSE*) malloc(sizeof(struct descLSE));
    
    //criado com sucesso
    if(desc != NULL){
        desc->inicio = NULL;
        desc->tamTotal = tamTotal;
        printf("SUCESSO NA CRIACAO!\n");
    }

    return desc;

}

struct descLSE * destroi(struct descLSE *p){
    reinicia(p);
    free(p);
    printf("\nlista destruida!\n");
    return NULL;

}


int tamDaLista(struct descLSE *p){
    int tam = 0;
    struct no *aux = p->inicio;

    while( aux != NULL){
        aux = aux->prox;
        tam++;
    }

    return tam;

}

int reinicia(struct descLSE *p){

    struct no *aux;

    if(p->inicio != NULL ){

        aux = p->inicio->prox;

        while(p->inicio->prox != NULL){
            free(p->inicio);
            p->inicio = aux;
            aux = p->inicio->prox;
        }
        
        free(p->inicio);
        p->inicio = NULL;
        printf("lista reinicializada\n");
        return 1;//sucesso na reinicializacao

    }else{
        printf("n foi preciso reinicializar\n");
        return 0;//nao reiniciou
    }


}

// Função para inserir um novo nó no início da lista
int insereNovoPrimeiro(info *reg, struct descLSE *p) {
    struct no *novo = (struct no*)malloc(sizeof(struct no));
    
    if (novo != NULL) {
        memcpy(&(novo->dado), reg, sizeof(info));
        novo->prox = p->inicio;
        p->inicio = novo;
        p->tamTotal++;
        return 1;  // SUCESSO
    }
    
    return 0;  // FRACASSO
}


int insereNovoUltimo(info *reg, struct descLSE *p){
        struct no *novo;
        novo = (struct no*) malloc(sizeof(struct no));
        memcpy(&(novo->dado), reg, sizeof(info));

        if(novo != NULL){
            struct no *aux = p->inicio;
            while(aux->prox != NULL){
                aux = aux->prox;
            }
            //chegou no ultimo
            (p->tamTotal)++;
            aux->prox = novo;
            return 1;
        }

        return 0;
}

int insereNaPoslog(int posLog, info *nova, struct descLSE *p) {
    if (posLog < 0 || posLog > p->tamTotal) {
        printf("Falha na inserção! Posição inválida.\n");
        return 0;
    }

    struct no *novo = (struct no*)malloc(sizeof(struct no));
    if (novo == NULL) {
        printf("Falha na alocação de memória.\n");
        return 0;
    }
    memcpy(&(novo->dado), nova, sizeof(info));

    if (posLog == 0) {
        novo->prox = p->inicio;
        p->inicio = novo;
    } else {
        struct no *aux = p->inicio;
        for (int i = 0; i < posLog - 1; i++) {
            aux = aux->prox;
        }
        novo->prox = aux->prox;
        aux->prox = novo;
    }

    p->tamTotal++;
    printf("Inserido com sucesso!\n");
    return 1;
}

int buscaNaPosLog(int posLog, info *reg, struct descLSE *p){
        int cont = 0;      
        struct no *aux = p->inicio;
       
        if(posLog == 0 && aux != NULL){
            printf("elemento achado na primeira posicao!\n");
            memcpy(reg, &(aux->dado), sizeof(info));
            return 1;
        }else{
            if(posLog < 0 || posLog > p->tamTotal){
                printf("posicao inexistente para busca!\n");
                return 0;
            }else{
                while(cont != posLog){
                    aux = aux->prox;
                    cont++;
                }

                //achou
                memcpy(reg, &(aux->dado), sizeof(info));
                printf("elemento achado!\n");
                return 1;
            }
        }

}

int removeDaPoslog(int posLog, info *reg, struct descLSE *p) {
    if (posLog < 0 || posLog >= p->tamTotal) {
        printf("Posição inexistente para remoção!\n");
        return 0;
    }

    struct no *aux = p->inicio;
    struct no *anterior = NULL;
    
    for (int i = 0; i < posLog; i++) {
        anterior = aux;
        aux = aux->prox;
    }

    if (anterior == NULL) {
        p->inicio = aux->prox; // Removendo o primeiro nó
    } else {
        anterior->prox = aux->prox; // Removendo nó do meio ou final
    }

    memcpy(reg, &(aux->dado), sizeof(info));
    free(aux);
    p->tamTotal--;
    printf("Nó removido da lista!\n");
    return 1;
}


int inverte(struct descLSE *p) {
    struct no *anterior = NULL;
    struct no *atual = p->inicio;
    struct no *proximo = NULL;

    while (atual != NULL) {
        proximo = atual->prox;
        atual->prox = anterior;
        anterior = atual;
        atual = proximo;
    }

    p->inicio = anterior;

    printf("Lista invertida com sucesso!\n");
    return 1;
}


// Função para remover um nó do início da lista
int removePrimeiro(info *reg, struct descLSE *p) {
    if (p->inicio == NULL) {
        printf("A lista está vazia!\n");
        return 0;  // FRACASSO
    }
    
    struct no *temp = p->inicio;
    memcpy(reg, &(temp->dado), sizeof(info));
    p->inicio = temp->prox;
    free(temp);
    p->tamTotal--;
    return 1;  // SUCESSO
}




