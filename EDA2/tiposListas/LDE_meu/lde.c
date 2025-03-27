#include "arq.h"

struct descLDE * cria(int tamInfo){
    struct descLDE *desc = (struct descLDE*) malloc(sizeof(struct descLDE));

    if(desc != NULL){
        desc->inicio = NULL;
        desc->tamInfo = tamInfo;
    }

    printf("FILA DUPLAMENTE ENCADEADA CRIADA COM SUCESSO!!!\n");
    return desc;


}

int tamanhoDaLista(struct descLDE *p){
    int tam = 0;
    struct no *aux = p->inicio;

    while( aux != NULL){
        aux = aux->prox;
        tam++;
    }

    return tam;

}

int reinicia(struct descLDE *p){
    
   if(p->inicio != NULL){
    while(p->inicio->prox != NULL){
        p->inicio = p->inicio->prox;
        free(p->inicio->ant);
    }
    free(p->inicio);
    p->inicio = NULL;
    printf("lista reinicializada com sucesso!\n");
    return 1;
   }
   else{
    return 0;
   }
}


int insereNovoPrimeiro(struct descLDE *p, info *novo) {
    struct no *aux = (struct no*)malloc(sizeof(struct no));
  
    if(aux != NULL) {
        memcpy(&(aux->dados), novo, sizeof(info));
        aux->prox = p->inicio;
        aux->ant = NULL;

        if(p->inicio != NULL) {
            p->inicio->ant = aux;
        }

        p->inicio = aux;
        printf("primeiro no inserido corretamente!\n");
        return 1;
    }

    printf("falha na criacao!\n");
    return 0;
}


int insereNaPosLog(int posLog, info *nova, struct descLDE *p){

    struct no *novo = (struct no*)malloc(sizeof(struct no));
    memcpy((&novo->dados), nova, sizeof(info));

    int cont = 2;
    if(posLog < 1 || posLog >= tamanhoDaLista(p)){
        printf("posicao invalida!\n");
        return 0;
    }

    struct no *aux = p->inicio->prox;
    while(cont != posLog){
        aux = aux->prox;
        cont++;
    }

    //achou
    novo->ant = aux->ant;
    novo->prox = aux;
    aux->ant->prox=novo;
    aux->ant = novo;
    printf("sucesso na incersao!\n");
    return 1;


}

int removeDaPoslog(int posLog, info *reg, struct descLDE *p){
    struct no *ret;
    int cont = 1;

    if(posLog < 0 || posLog > tamanhoDaLista(p)){
        printf("posicao invalida!\n");
        return 0;
    }

    if(posLog == 1){
        struct no *aux = p->inicio;
        p->inicio = aux->prox;
        p->inicio->ant = NULL;
        memcpy(reg, &aux->dados, p->tamInfo);

        free(aux);
        printf("primeiro removido com sucesso!\n");
        return 1;
    }else{

        struct no *aux = p->inicio;
        while(cont != posLog){
            aux = aux->prox;
            cont++;
        }

        if(posLog == tamanhoDaLista(p)){
            aux->ant->prox = NULL;
            memcpy(reg, &aux->dados, p->tamInfo);
        free(aux);
        printf("sucesso na remocao do ultimo!\n");
        return 1;
        }

        //achou
        aux->prox->ant = aux->ant;
        aux->ant->prox = aux->prox;
        memcpy(reg, &aux->dados, p->tamInfo);
        free(aux);
        printf("sucesso na remocao!\n");
        return 1;


    }
    return 0;

}