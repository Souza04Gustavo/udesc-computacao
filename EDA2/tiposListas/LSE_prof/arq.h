#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#define SIM 1
#define NAO 0
#define SUCESSO 1
#define FRACASSO 0


typedef struct{ int idade;
		char nome[30];
	}info;
			


struct noLSE {
    info dados;
    struct noLSE *prox;
};

struct descLSE { 
    int tamInfo;
    struct noLSE *inicio;
};
//======================APLICACAO=====================


//======================FILA=====================
struct descLSE * cria(int tamInfo);
int tamanhoDaLista(struct descLSE *p);
int reinicia(struct descLSE *p);
struct descLSE * destroi(struct descLSE *p);

int insereNaPoslog(int posLog, info *novo, struct descLSE *p);
int insereNovoUltimo(info *reg, struct descLSE *p);
int insereNovoPrimeiro(info *reg, struct descLSE *p);

int buscaOultimo(info *reg, struct descLSE *p);
int buscaOprimeiro(info *reg, struct descLSE *p);
int buscaNaPoslog(int posLog, info *reg, struct descLSE *p);

int removeDaPoslog(int Poslog, info *reg, struct descLSE  *p);
int removeOultimo(info *reg, struct descLSE *p);
int removeOprimeiro(info *reg, struct descLSE *p);

int testaVazia(struct descLSE *p);
int inverte(struct descLSE *p);
struct descLSE * destroi(struct descLSE *p);











