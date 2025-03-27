#ifndef ARVB_H
#define ARVB_H

#include <stdio.h>
#include <stdlib.h>

// Estrutura do nó da Árvore B
typedef struct noB {
    int total_chaves;      // Número de chaves no nó
    int* chaves;           // Vetor de chaves
    struct noB** filhos;   // Vetor de ponteiros para filhos
    struct noB* pai;       // Ponteiro para o nó pai
} NoB;

// Estrutura da Árvore B
typedef struct arvoreB {
    NoB* raiz;  // Ponteiro para a raiz da árvore
    int ordem;  // Ordem da árvore (máximo de filhos = 2 * ordem)
} ArvoreB;

// Protótipos das funções
ArvoreB* criaArvoreB(int ordem);
NoB* criaNoB(ArvoreB* arvore);
void percorreArvoreB(NoB* no, void (visita)(int chave));
void imprime(int chave);
int loclizaChave(ArvoreB* arvore, int chave);
int pesquisaBinaria(NoB* no, int chave);
NoB* localizaNoB(ArvoreB* arvore, int chave);
int transbordo(ArvoreB* arvore, NoB* no);
NoB* divideNoB(ArvoreB* arvore, NoB* no);
void adicionaChaveNo(NoB* no, NoB* direita, int chave, int* contador);
void adicionaChave(ArvoreB* arvore, int chave, int* contador);
void adicionaChaveRecursivo(ArvoreB* arvore, NoB* no, NoB* novo, int chave, int* contador);
void removeChaveFolha(NoB* no, int chave);
void removeChave(ArvoreB* arvore, int chave, int* contador);
void removeChaveRecursivo(ArvoreB* arvore, NoB* no, int chave, int* contador);
int encontraPredecessor(NoB* no);
int encontraSucessor(NoB* no);
void fundirNos(ArvoreB* arvore, NoB* no, int indice, int* contador);
void redistribuirEsquerda(NoB* pai, NoB* filho, NoB* irmao, int indice, int* contador);
void redistribuirDireita(NoB* pai, NoB* filho, NoB* irmao, int indice, int* contador);
void imprimeDetalhesNo(NoB* no, int nivel);
void imprimeDetalhesArvore(ArvoreB* arvore);
void tira_vetor(int* vet, int* tam, int valor);

#endif // ARVB_H
