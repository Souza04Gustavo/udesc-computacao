#include "stdlib.h"
#include "stdio.h"
#include "string.h"

#define FRACASSO 0
#define SUCESSO 1

#define SIM 1
#define NAO  0
#define INI_LESE 1
#define OK 1
#define NOK -1


typedef struct{
    int idade;
    char nome[30];
}info;

struct no{
    info dados;
    int prox;
};

struct descLESE{
    struct no *vet;
    int tamInfo;
    int tamdalistadedados;
    int listaDados;
    int listaDispo;
};

struct descLESE * cria(int tamVetor, int tamInfo);
struct descLESE * destroi(struct descLESE *p);
int reinicia(struct descLESE *p);
int testaVazia(struct descLESE *p);
int testaCheia(struct descLESE *p);
int buscaOprimeiro(struct descLESE *p, info *pReg);
int buscaOultimo(struct descLESE *p, info *pReg);
int insereNovoPrimeiro(struct descLESE *p,info *pReg);
int insereNovoUltimo(struct descLESE *p, info *pReg);
int insereNaPosLog(struct descLESE *p,info *pReg, int posLog);