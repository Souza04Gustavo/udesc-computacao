#include <stdio.h>
#include <stdlib.h>

typedef struct no_avl {
    struct no_avl* pai;
    struct no_avl* esquerda;
    struct no_avl* direita;
    int valor;
    int altura;
} NoAVL;

typedef struct _avl {
    struct no_avl* raiz;
} Arvore;

NoAVL* rsd(Arvore*, NoAVL*);
NoAVL* rse(Arvore*, NoAVL*);
NoAVL* rdd(Arvore*, NoAVL*);
NoAVL* rde(Arvore*, NoAVL*);
NoAVL* localizar(NoAVL* no, int valor);
Arvore* criar();
int maximo(int a, int b);
int vazia_avl(Arvore* arvore);
void remover_avl(Arvore* arvore, int valor, int* contador_rem);
void adicionar_avl(Arvore* arvore, int valor, int* contadores);
void percorrer(NoAVL* no, void (*callback)(int));
void visitar_avl(int valor); 
void balanceamento(Arvore* arvore, NoAVL* no, int* contadores);
int altura(NoAVL* no);
int fb(NoAVL* no);
void imprimir_por_altura(Arvore* arvore);
void destruir_avl(Arvore* arvore);
void destruir_no(NoAVL* no);