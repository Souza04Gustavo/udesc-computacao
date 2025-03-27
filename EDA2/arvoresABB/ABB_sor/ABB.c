#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "arq_privado.h"

ABB * criaABB(int tamInfo)
{  
    
    ABB *desc = (ABB*) malloc(sizeof(ABB));

    if(desc != NULL ) {	
        desc->raiz = NULL;
        desc->tamInfo = tamInfo;
        return desc;
    }

    

    return NULL;
}

ABB * destroiABB(ABB *p)
{  
    reiniciaABB(p);
    free(p);
    return NULL;
}


void reiniciaABB(ABB *p)
{
    apagaNoABB(p->raiz);
    p->raiz = NULL;
}

void apagaNoABB(NoABB *p)
{ 
    if(p != NULL) {   
        apagaNoABB(p->esq);
        apagaNoABB(p->dir);
        free(p);
    }
}

int buscaABB(ABB *pa, info *destino, tipoChave chaveDeBusca)
{  
    NoABB *aux = pa->raiz;
    unsigned int ret = FRACASSO;

    while( aux != NULL && ((aux->dados).identificador != chaveDeBusca)) {
        if (chaveDeBusca < (aux->dados).identificador)
		aux= aux->esq;
	else
		aux= aux->dir;
    }

    if (aux != NULL) {   
        memcpy(destino, &(aux->dados), pa->tamInfo);
        ret = SUCESSO;
    }

    return ret;
}

int insereABB(ABB *pa, info *novoReg)
{  	
    NoABB *p, *q, *novoNoABB;

    p = q = pa->raiz;

    while( p != NULL ) {  
        if( novoReg->identificador == (p->dados.identificador)) {
            return FRACASSO;  /* registro j� inserido previamente */
        }
        else {   	
            q = p;
            if (novoReg->identificador < (p->dados.identificador))
		p= p->esq;
	    else
		p= p->dir;
        }
    }


    if((novoNoABB = (NoABB*) malloc (sizeof(NoABB))) != NULL) {
        if(novoNoABB != NULL) 
	{	
            memcpy(&(novoNoABB->dados), novoReg, pa->tamInfo);
            novoNoABB->dir = novoNoABB->esq = NULL; /* insere nova folha */

            if (q != NULL) {
                if((novoNoABB->dados.identificador) < (q->dados.identificador)) /*ou (*cmp)(novoReg,q->dados)*/
                    q->esq = novoNoABB;
                else
                    q->dir=novoNoABB;
            }
	    else 
		pa->raiz = novoNoABB;   /* �rvore com um �nico n� */
            
            return SUCESSO;
        }
	        
    }

    return FRACASSO;  /* n�o conseguiu alocar mem�ria */
}

int removeABB(ABB *pa, tipoChave chaveDeBusca, info *copia)
{	
    
    NoABB *subst, *paiSubst, *alvo, *paiDoAlvo, *avante;

    paiDoAlvo = NULL;
    alvo = pa->raiz;

    while (alvo != NULL && (chaveDeBusca != (alvo->dados.identificador))) {	
        paiDoAlvo = alvo;
        if (chaveDeBusca < (alvo->dados.identificador))
        	alvo = alvo->esq;
	else
		alvo= alvo->dir;
    }

    if (alvo==NULL)   /*alvo n�o encontrado */
        return FRACASSO;

    if (alvo->esq == NULL) {
        if (alvo->dir == NULL) // alvo � uma folha
            subst = NULL;
        else
            subst = alvo->dir; /*alvo possui apenas um filho � dir*/
    }else {
        if(alvo->dir == NULL)
            subst = alvo->esq; /*alvo possui apenas um filho � esq*/

        else  /* alvo possui os dois filhos*/
        {    	/* determinando o substituto pelo sucessor em ordem: */
            paiSubst = alvo;
            subst = alvo->dir;
            //avante = alvo->esq; // ERRO!!
            avante = subst->esq;   // CORRE��O!!
            while(avante != NULL) {   
                paiSubst = subst;
                subst = avante;
                avante = avante->esq;
            }

            if(paiSubst != alvo) {  	
                paiSubst->esq = subst->dir;
                subst->dir = alvo->dir;
            }
            subst->esq = alvo->esq; /*o pai do substituto eh o proprio alvo */
        }
    }

    if(pa->raiz == alvo) // ou seja se "paiDoAlvo = NULL"
        pa->raiz = subst; /*alvo era a raiz*/
    else
        alvo == paiDoAlvo->esq ? (paiDoAlvo->esq = subst) : (paiDoAlvo->dir = subst);

    memcpy(copia, &(alvo->dados), pa->tamInfo);
    free(alvo);

    return SUCESSO;
}


int testaVaziaABB(ABB *p)
{ 
    return (p->raiz == NULL ? SIM : NAO);
}



int numFolhas(ABB *p)
{   
    if(p != NULL) {
        return calcNumFolhas(p->raiz);
    }

    return 0;
}





int preOrdem(ABB *pa)
{   
    if(pa->raiz == NULL) {
        return FRACASSO;
    }

    percorreEmPreOrdem(pa->raiz);

    return SUCESSO;

}

int posOrdem(ABB *pa)
{   
    if(pa->raiz == NULL) {
        return FRACASSO;
    }

    percorreEmPosOrdem(pa->raiz);

    return SUCESSO;

}

int emOrdem(ABB *pa)
{   
    if(pa->raiz == NULL) {

        return FRACASSO;
    }

    percorreEmOrdem(pa->raiz);

    return SUCESSO;
}


void percorreEmPreOrdem(NoABB *p)
{  
    if(p != NULL) { 
        processa(p->dados);
        percorreEmPreOrdem(p->esq);
        percorreEmPreOrdem(p->dir);
    }
}

void percorreEmOrdem(NoABB *p)
{  
    if(p != NULL) { 
        percorreEmOrdem(p->esq);
        processa(p->dados);
        percorreEmOrdem(p->dir);
    }
}

void percorreEmPosOrdem(NoABB *p)
{ 
    if(p != NULL) { 
        percorreEmPosOrdem(p->esq);
        percorreEmPosOrdem(p->dir);
        processa(p->dados);
    }
}

int calcNumFolhas(NoABB *p)
{   
    if(!p) {
        return 0;
    }

    if(!(p->esq) && !(p->dir)) {
        return 1;
    }
    
    return calcNumFolhas(p->esq)+calcNumFolhas(p->dir);
}
