#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "arq_privado.h"

ABB * cria(int tamInfo){
    ABB *desc = (struct ABB*)malloc(sizeof(struct ABB));

    if(desc != NULL){
    desc->raiz = NULL;
    desc->tamInfo =tamInfo;
    printf("arvore criada com sucesso!\n\n");
    return desc;
    }

    printf("nao foi criada a arvore!\n");
    return NULL;

}

ABB * destroi(ABB *p){
    reiniciaABB(p);
    free(p);
    printf("\nABB destruida com sucesso!!\n");
    return NULL;

}



void reiniciaABB(ABB *p){
    apagaNoABB(p->raiz);//RECURSAO
    printf("abb reiniciada com sucesso!\n");
    p->raiz = NULL;
}


void apagaNoABB(noABB *p){

    if(p!=NULL){
        apagaNoABB(p->esq);
        apagaNoABB(p->dir);
        free(p);
    }


}

int buscaABB(ABB *p, info *destino, tipoChave chavedebusca){
    noABB *aux = p->raiz;

    while(aux != NULL && (aux->dados.identificador) != chavedebusca){
        if(aux->dados.identificador < chavedebusca){//a busca deve continuar na esq
            aux = aux->esq;
        }else{//a busca deve continuar na direita
            aux = aux->dir;
        }
    }

    //ou achou ou acabou as possibilidades
    if(aux == NULL){
        printf("não achou o no procurado!\n");
        return 0;
    }else{//achou o no que tem a mesma chave de busca
        memcpy(destino, &(aux->dados), sizeof(info));
        printf("achou o no procurado!\n");
        return 1;
    }

}


int insereABB(ABB *p, info *novo){

    noABB *paiAux;
    noABB *aux;
    noABB *novoNo;

    paiAux = aux = p->raiz;

    while(aux != NULL){
        if(novo->identificador == aux->dados.identificador){
            printf("ja existe essa chave!\n");
            return 0;
        }else{
            paiAux = aux;
            if(novo->identificador < aux->dados.identificador){//direcoes que deve seguir
                aux = aux->esq;
            }else{
                aux = aux->dir;
            }
        }

    }

    //achou a folha para inserir depois
    novoNo = (noABB*)malloc(sizeof(noABB));
    if(novoNo != NULL) {
        memcpy(&(novoNo->dados), novo, p->tamInfo);
        novoNo->dir = novoNo->esq = NULL; /* insere nova folha */

        if(paiAux != NULL) {
            if(novoNo->dados.identificador < paiAux->dados.identificador) {
                paiAux->esq = novoNo; // novo no vai a esquerda
            } else {
                paiAux->dir = novoNo; // novo no vai a direita
            }
        } else {
            p->raiz = novoNo; // ABB com um unico no
        }

        return 1; // insercao com sucesso
    } else {
        return 0; // falha na alocacao de memoria
    }

}

int removeABB(ABB *p, tipoChave chavedebusca, info *copia) {
    noABB *subst;
    noABB *paiAux;
    noABB *aux;
    noABB *prox;
    noABB *paiSubst;

    aux = p->raiz;
    paiAux = NULL;

    while (aux != NULL && aux->dados.identificador != chavedebusca) {
        paiAux = aux;
        if (chavedebusca < aux->dados.identificador) {
            // deve seguir pela esquerda
            aux = aux->esq;
        } else {
            // deve seguir pela direita
            aux = aux->dir;
        }
    }

    // Saiu do while, verifica se encontrou o nó
    if (aux == NULL) {
        // não encontrou
        printf("Nó não encontrado para remover!\n");
        return 0;
    }

    // Determina o substituto
    if (aux->esq == NULL) {
        subst = aux->dir;
    } else if (aux->dir == NULL) {
        subst = aux->esq;
    } else {
        // Nó com dois filhos, encontrar o sucessor em ordem
        paiSubst = aux;
        subst = aux->dir;
        prox = subst->esq;
        while (prox != NULL) {
            paiSubst = subst;
            subst = prox;
            prox = prox->esq;
        }

        if (paiSubst != aux) {
            paiSubst->esq = subst->dir;
            subst->dir = aux->dir;
        }
        subst->esq = aux->esq;
    }

    // Atualiza o ponteiro do pai
    if (p->raiz == aux) {
        p->raiz = subst;
    } else if (paiAux->esq == aux) {
        paiAux->esq = subst;
    } else {
        paiAux->dir = subst;
    }

    // Copia os dados
    if (copia != NULL) {
        memcpy(copia, &(aux->dados), sizeof(info));
    }

    // Libera o nó removido
    free(aux);

    return 1;
}


int testaVaziaABB(ABB *p)
{ 
    if(p->raiz = NULL){
        printf("vazia!\n");
        return 1;
    }else{
        printf("Nao eh vazia!\n");
        return 0;
    }
}


int emOrdem(ABB *pa)
{   
    if(pa->raiz == NULL) {

        return 0;
    }

    percorreEmOrdem(pa->raiz);

    return 1;
}


void percorreEmPreOrdem(noABB *p)
{  
    if(p != NULL) { 
        processa(p->dados);
        percorreEmPreOrdem(p->esq);
        percorreEmPreOrdem(p->dir);
    }
}

void percorreEmOrdem(noABB *p)
{  
    if(p != NULL) { 
        percorreEmOrdem(p->esq);
        processa(p->dados);
        percorreEmOrdem(p->dir);
    }
}

void percorreEmPosOrdem(noABB *p)
{ 
    if(p != NULL) { 
        percorreEmPosOrdem(p->esq);
        percorreEmPosOrdem(p->dir);
        processa(p->dados);
    }
}



int calcNumFolhas(noABB *no)
{   
    if(no == NULL) {
        return 0;
    }

    if((no->esq) == NULL && (no->dir) == NULL) {
        printf("%d ", no->dados.identificador);
        return 1;
    }
    
    return calcNumFolhas(no->esq)+calcNumFolhas(no->dir);
}
