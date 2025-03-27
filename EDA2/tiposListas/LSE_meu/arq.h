#include "stdio.h"
#include "stdlib.h"
#include "string.h"

typedef struct{
    int numero;
}info;

struct no{
    info dado;
    struct no *prox;
};

struct descLSE{
    int tamTotal;
    struct no *inicio;
};

//======================FILA=====================
struct descLSE * cria(int tamTotal);
int tamDaLista(struct descLSE *p);
int reinicia(struct descLSE *p);
struct descLSE * destroi(struct descLSE *p);

int insereNaPoslog(int posLog, info *novo, struct descLSE *p);
int insereNovoUltimo(info *reg, struct descLSE *p);
int insereNovoPrimeiro(info *reg, struct descLSE *p);

int buscaOultimo(info *reg, struct descLSE *p);
int buscaOprimeiro(info *reg, struct descLSE *p);
int buscaNaPoslog(int posLog, info *reg, struct descLSE *p);

int removeDaPoslog(int Poslog, info *reg, struct descLSE  *p);
int removeUltimo(info *reg, struct descLSE *p);
int removePrimeiro(info *reg, struct descLSE *p);

int testaVazia(struct descLSE *p);
int inverte(struct descLSE *p);
struct descLSE * destroi(struct descLSE *p);






