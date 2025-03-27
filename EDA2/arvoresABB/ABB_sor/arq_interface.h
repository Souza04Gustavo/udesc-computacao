#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#define SIM 1
#define NAO 0
#define SUCESSO 1
#define FRACASSO 0

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
} NoABB;

typedef struct ABB {    
    NoABB *raiz;
    int tamInfo;
} ABB;
			


//======================APLICACAO=====================

void menu(ABB *p);
//======================ABB=====================

void apagaNoABB(NoABB *p);

int calcNumFolhas(NoABB *p);

ABB *  criaABB(int tamInfo);

ABB *  destroiABB(ABB *p);

void reiniciaABB(ABB *p);

int buscaABB(ABB *pa, info *destino, int chaveDeBusca);

int insereABB(ABB *p, info *novoReg);

int removeABB(ABB *p, int chaveDeBusca, info *copia);

int testaVaziaABB(ABB *p);

int numFolhas(ABB *p);

int emOrdem(ABB *pa);

int posOrdem(ABB *pa);

int preOrdem(ABB *pa);











