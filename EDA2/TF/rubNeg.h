#ifndef FUNCAO_H
#define FUNCAO_H

#include <stdlib.h>
#include <stdio.h>

typedef enum { Vermelho, Preto } Cor;

typedef struct no {
    struct no* pai;
    struct no* esquerda;
    struct no* direita;
    Cor cor;
    int valor;
} No;

typedef struct arvore {
    No* raiz;
    No* nulo; 
} ArvoreRN;

// Declaração de funções com o parâmetro contador
ArvoreRN* criarRN();
int vazia(ArvoreRN* arvore);
No* adicionar(ArvoreRN* arvore, int valor, int* contador);
No* adicionarNo(ArvoreRN* arvore, No* no, int valor, int* contador);
No* criarNo(ArvoreRN* arvore, No* pai, int valor);
No* localizarRN(ArvoreRN* arvore, int valor);
void percorrerProfundidadeInOrder(ArvoreRN* arvore, No* no, void (*callback)(int));
void percorrerProfundidadePreOrder(ArvoreRN* arvore, No* no, void (*callback)(int));
void percorrerProfundidadePosOrder(ArvoreRN* arvore, No* no, void (*callback)(int));
void visitar(int valor);
void balancear(ArvoreRN* arvore, No* no, int* contador);
void rotacionarEsquerda(ArvoreRN* arvore, No* no, int* contador);
void rotacionarDireita(ArvoreRN* arvore, No* no, int* contador);
void transplante(ArvoreRN* arvore, No* u, No* v);
No* minimoSubarvore(ArvoreRN* arvore, No* no);
void correcaoRemocao(ArvoreRN* arvore, No* x, int* contador);
void remover(ArvoreRN* arvore, int valor, int* contador);

#endif
