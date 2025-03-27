#include <stdio.h>
#include <stdlib.h>
#include <stdio_ext.h>

//================MODELO DE DADOS DA APLICACAO==============
typedef union infoDados
{
    int inteiro;
    char letra;

} info;

//======================MODELO DE DADOS=====================
// No pilha
typedef struct noPilha
{
    info dados;
    struct noPilha *prox;
    struct noPilha *ant;
} noPi;

/* Nó descritor de uma pilha */
typedef struct descpilha
{
    int topo; // Indice
    noPi *pontTopo;
} DescPilha;

typedef struct mp
{
    int topo1;
    int tamInfo;
    int topo2;
    noPi *vet;
    int *vetAux;
    DescPilha pilha1, pilha2;
    
} MP;

//======================FUNCIONALIDADE DA PILHA=====================


MP *cria(int tamInfo);
int insereNaPilha(MP *p, int escPilha, info *novo);
int removeDaPilha(MP *p, int nPilha, info *removido);
int consultaTopo(MP *p, int nPilha, info *consultado);
MP *destroi(MP *p);
int numElementosInseridos(MP *desc);
int reinicializacaoPilha(MP *a, int escPilha);