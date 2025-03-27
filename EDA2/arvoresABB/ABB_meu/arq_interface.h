#include "stdio.h"
#include "stdlib.h"
#include "string.h"

#define processa(a) printf("nome: %s, identificador: %i \n",(a).nome, (a).identificador);

typedef int tipoChave;

typedef struct{ tipoChave identificador;
		int idade;
		char nome[30];
	}info;

typedef struct noABB { 
    info dados;
    struct noABB *esq;
    struct noABB *dir;
} noABB;

typedef struct ABB {    
    noABB *raiz;
    int tamInfo;
} ABB;