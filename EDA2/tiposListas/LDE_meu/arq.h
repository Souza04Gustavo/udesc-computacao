#include "stdlib.h"
#include "stdio.h"
#include "string.h"

typedef struct{ 
    int idade;
	char nome[30];
	}info;
		
struct no{
    info dados;
    struct no *ant;
    struct no *prox;
};

struct descLDE{
    int tamInfo;
    struct no *inicio;
};


struct descLDE * cria(int tamInfo);
int insereNovoPrimeiro(struct descLDE *p, info *novo);
//int insereNovoUltimo(struct descLDE *p, info *novo);
int insereNaPoslog (struct descLDE *p, info *novo,unsigned int posLog);
int tamanhoDaLista(struct descLDE *p);
int reinicia(struct descLDE *p);
//struct descLDE * destroi(struct descLDE *p);
//int buscaNaPoslog(struct descLDE *p, info *reg, unsigned int posLog);
//int buscaOultimo(struct descLDE *p, info *reg);
//int buscaOprimeiro(struct descLDE *p, info *reg);
int removeDaPoslog(int posLog, info *reg, struct descLDE *p);
//int removeOultimo(struct descLDE *p, info *reg);
//int removeOprimeiro(struct descLDE *p, info *reg);
//int enderecosFisicos(struct descLDE *p);

