#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<stdio_ext.h>
#include<time.h>

typedef struct infoDados
{
    int matricula;
    char curso[50];
    int ranking;
    char nome[30];
} info;

typedef struct noFila
{
    info dados;
    struct noFila *atras;
    struct noFila *frente;
} noF;

typedef struct descFDEsReferencialMovel
{
    noF *primeiro;
    noF *ultimo;
    int tamInfo;
} descFDEsRef;

typedef struct descFDEcRefMovel{
    noF *primeiro;
    noF *ultimo;
    noF *refMovel;
    int tamInfo;
}descFDEcRef;

//======================APLICACAO=====================
int compara(info *inf1, info *inf2);

//======================FILA SEM REFERENCIAL MOVEL=====================
descFDEsRef *criaA(int tamInfo);
int insereA(info *novo, descFDEsRef *p, int (*compara)(info *novo, info *visitado), int *nIteracao);
int tamanhoDaFilaA(descFDEsRef *p);
int reiniciaA(descFDEsRef *p);
descFDEsRef *destroiA(descFDEsRef *p);
int buscaNaCaudaA(info *reg, descFDEsRef *p);
int buscaNaFrenteA(info *reg, descFDEsRef *p);
int remove_A(info *reg, descFDEsRef *p, int chave);
int testaVaziaA(descFDEsRef *p);
int inverteA(descFDEsRef *p);


//=======================FILA COM REFERENCIAL MOVEL===================
descFDEcRef *criaB(int tamInfo);
int insereB(info *novo, descFDEcRef *p, int (*compara)(info *novo, info *visitado), int *nIteracao);
int tamanhoDaFilaB(descFDEcRef *p);
int reiniciaB(descFDEcRef *p);
descFDEcRef *destroiB(descFDEcRef *p);
int buscaNaCaudaB(info *reg, descFDEcRef *p);
int buscaNaFrenteB(info *reg, descFDEcRef *p);
int remove_B(info *reg, descFDEcRef *p,int chave);
int testaVaziaB(descFDEcRef *p);
int inverteB(descFDEcRef *p);