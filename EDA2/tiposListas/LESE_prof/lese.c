
#include "arq_priv.h"


struct descLESE * cria(int tamanhoVetor, int tamInfo)
{ 
    int i;
    struct descLESE *desc = (struct descLESE*) malloc(sizeof(struct descLESE));

    if( desc != NULL ) 
    {   if( (desc->vet = (struct noLESE*) malloc(tamanhoVetor*sizeof(struct noLESE))) != NULL ) 
        {   desc->listDados = -1;
            desc->listDispo = 0;
            desc->tamInfo = tamInfo;
	    desc->tamanhoDaListaDeDados=0;
	    // todas as posiçoes estão na lista de disponibilidade (listdispo)
            for(i=0; i < tamanhoVetor-1; i++) 
                	desc->vet[i].prox = i+1; 
            desc->vet[i].prox = -1;
            return desc;
        }
        else 
        {   free(desc);
            return NULL;
        }
    }
    return NULL;
}

struct descLESE * destroi(struct descLESE *p)
{ 
    free(p->vet);
    free(p);
    return NULL;
}

int reinicia(struct descLESE *p)
{  int aux;
   if (testaVazia(p) == SIM)
	return FRACASSO;
     
    while (p->listDados !=-1) 
    {   aux = p->vet[p->listDados].prox;
        devolveNo(p, p->listDados);
        p->listDados=aux;
    }
    p->tamanhoDaListaDeDados=0;
    return SUCESSO;
}

int testaVazia(struct descLESE *p)
{ 
    if(p->listDados < 0)
        return SIM;

    return NAO;
}

int testaCheia(struct descLESE *p)
{   if(p->listDispo < 0)
        return SIM;
    return NAO;
}

/*----------------------------------------------/ BUSCAS /----------------------------------------------*/
int buscaOprimeiro(struct descLESE *p, info *pReg )
{  
    if(p->listDados < 0)
        return FRACASSO;

    memcpy(pReg, &(p->vet[p->listDados].dados), p->tamInfo);
    return SUCESSO;
}


int buscaOultimo(struct descLESE *p, info *pReg )
{
    int aux;

    if (p->listDados < 0) 
        return FRACASSO;

    aux = p->listDados;
    while (p->vet[aux].prox != -1) 
        aux = p->vet[aux].prox;
    
    memcpy(pReg, &(p->vet[aux].dados), p->tamInfo);

    return SUCESSO;
}

int buscaNaPosLog(struct descLESE *p, info *pReg, int posLog)
{  
    int cont, aux1, aux2;
    if (p->listDados > -1) 
    {  
        cont = 1;
        if (posLog == cont) 
        {  
            memcpy(pReg, &(p->vet[p->listDados].dados), p->tamInfo);
            return SUCESSO;
        }
        aux1= p->listDados;
        aux2= p->vet[aux1].prox;
        cont = 2;
        while(aux2 > -1 && cont < posLog) 
        {
            aux1=aux2;
            aux2=p->vet[aux2].prox;
            cont++;
        }
        if (aux2 > -1 && cont == posLog) 
        { 	
            memcpy(pReg, &(p->vet[aux2].dados), p->tamInfo);
            return  SUCESSO;
        }
    }
    return FRACASSO;    /*LESE vazia ou 1 > posLog > tamanho da LESE */
}

/*----------------------------------------------/ REMOÇÕES /----------------------------------------------*/

int removeOprimeiro(struct descLESE *p, info *pReg)
{
    int aux = p->listDados;

    if (aux < 0)
        return FRACASSO;

    p->listDados = p->vet[aux].prox;
    memcpy(pReg, &(p->vet[aux].dados), p->tamInfo);
    devolveNo(p, aux);
    p->tamanhoDaListaDeDados -= 1;
    return SUCESSO;
}

int removeOultimo(struct descLESE *p, info *pReg)
{
    int temp1 = p->listDados;
    int temp2;

    if (temp1 < 0) 
        return FRACASSO;  // lista vazia
    

    if(p->vet[temp1].prox == -1) {   
        memcpy(pReg, &(p->vet[temp1].dados), p->tamInfo);
        p->listDados = -1; /* existe um unico elemento*/
        devolveNo(p, temp1);
    }
    else { /* busca penultimo elemento*/
        temp2 = p->vet[temp1].prox;

        while(p->vet[temp2].prox != -1) 
        { 
            temp1=temp2;
            temp2 = p->vet[temp2].prox;
        }
        p->vet[temp1].prox = -1;
        memcpy(pReg, &(p->vet[temp2].dados), p->tamInfo);
        devolveNo(p, temp2);
    }
    p->tamanhoDaListaDeDados -= 1;
    return SUCESSO;
}

int removeDaPosLog(struct descLESE *p, info *pReg, int posLog)
{  
    int cont,pre,pos;

    if (p->listDados > -1) 
    {  
        cont = 1;
        if (posLog == cont) 
        { 
            pos = p->listDados;
            memcpy(pReg, &(p->vet[pos].dados), p->tamInfo);
            p->listDados = p->vet[pos].prox;
            devolveNo(p, pos);
	    p->tamanhoDaListaDeDados -= 1;
            return SUCESSO;
        }

        pre = p->listDados;
        pos = p->vet[p->listDados].prox;
        if (pos > -1) 
        {  
            cont = 2;
            while(p->vet[pos].prox > -1 && cont < posLog) 
            { 	
                pre = pos;
                pos = p->vet[pos].prox;
                cont ++;
            }
            if (cont == posLog) 
            { 	
                p->vet[pre].prox = p->vet[pos].prox;
                memcpy(pReg,&(p->vet[pos].dados),p->tamInfo);
                devolveNo(p,pos);
		p->tamanhoDaListaDeDados -= 1;
                return  SUCESSO;
            }
        }
    }
    return FRACASSO;    /*LESE vazia ou 1 > posLog > tamanho da LESE */
}

/*----------------------------------------------/ INSERÇÕES /----------------------------------------------*/

int insereNovoPrimeiro(struct descLESE *p, info *pReg)
{  
    int ret = FRACASSO, temp = obtemNo(p);

    if(temp > -1) 
    {  
        memcpy(&(p->vet[temp].dados), pReg, p->tamInfo);
        p->vet[temp].prox = p->listDados;
        p->listDados = temp;
	p->tamanhoDaListaDeDados += 1;
        ret = SUCESSO;  
    }

    return ret;
}

int insereNovoUltimo(struct descLESE *p, info *pReg)
{
    int vaga = obtemNo(p);
    int temp;

    if (vaga > -1) 
    { 
        p->vet[vaga].prox = -1;
        memcpy(&(p->vet[vaga].dados), pReg, p->tamInfo);
        temp = p->listDados;
        if(temp == -1) 
          	/*LESE vazia*/
            	p->listDados = vaga;
        else 
        { /* busca penultimo elemento*/
            while(p->vet[temp].prox != -1) 
                temp = p->vet[temp].prox;
            
            p->vet[temp].prox = vaga;
        }
        p->tamanhoDaListaDeDados += 1;
        return SUCESSO;
    }

    return FRACASSO;
}

int insereNaPosLog(struct descLESE *p, info *pReg, int posLogAlvo)
{  
    int cont, aux1, aux2, vaga;

    if(p->listDados > -1) {  
        vaga = obtemNo(p);  
        if (vaga > -1) 
        { 
            memcpy(&(p->vet[vaga].dados), pReg, p->tamInfo);
            if (posLogAlvo == 1) 
            {	
                p->vet[vaga].prox = p->listDados; // insercao de um novo primeiro item 
                p->listDados = vaga;
                p->tamanhoDaListaDeDados += 1;
                return SUCESSO;
            }

            /* posLogAlvo > 1, precisamos encontrar a posLogAlvo na sequencia da lista */
            aux1 = p->listDados;
            aux2 = p->vet[aux1].prox;
            cont = 2; // contador das posicoes indexadas por aux2 
            while(aux2 > -1 && p->vet[aux2].prox > -1 && cont < posLogAlvo) 
            { 	
                aux1 = aux2;
                aux2 = p->vet[aux2].prox;
                cont++;
            }
            if (aux2 > -1 && cont == posLogAlvo) 
	    { 	
                p->vet[aux1].prox = vaga;
                p->vet[vaga].prox = aux2;
		p->tamanhoDaListaDeDados += 1;
                return SUCESSO;
            }
            devolveNo(p, vaga); /* posLogAlvo > tamanho da LESE, nao existindo. 
                                   Alem de "fracasso" devolve-se o no obtido */
            return FRACASSO;
        }
    }
    return FRACASSO;    /*LESE vazia ou 1 > posLog > tamanho da LESE */
}

int tamanhoDaLista(struct descLESE *p)
{ 
   return (p->tamanhoDaListaDeDados);
}

static int obtemNo(struct descLESE *p)
{ 
    int temp;
    temp = p->listDispo;     // printf("%i ---",temp); getchar();
    if (temp > -1) 
        p->listDispo = p->vet[p->listDispo].prox; /* (p->vet+p->dispo)->prox */
    return temp;
}


static void devolveNo(struct descLESE *p, int posicao)
{ 
    p->vet[posicao].prox = p->listDispo;
    p->listDispo = posicao;
}
