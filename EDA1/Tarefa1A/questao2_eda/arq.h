#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdio_ext.h>

//================MODELO DE DADOS DA APLICACAO==============
typedef struct infoDados{
char str[50];
}info;

//======================MODELO DE DADOS=====================
//pilha dinamica simplesmente encadeada
typedef struct nos
{
   info data;
   struct nos *anterior;//unico sentido
}noPilha;

typedef struct descritor
{
    noPilha *topo;
    noPilha *vetor;
    int tam;
}descPilha;

//======================FUNCIONALIDADE DA PILHA=====================
descPilha *criaPilha();
int insereNaPilha(descPilha *p, info *novo);
int removeDaPilha(descPilha *p, info *removido);