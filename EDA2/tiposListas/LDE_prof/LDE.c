#include "arq.h"


/*************** CRIA ***************/
struct descLDE * cria(int tamInfo)
{  
   struct descLDE *desc = (struct descLDE*) malloc(sizeof(struct descLDE));

    if( desc ) 
    {	
        desc->inicio = NULL;
        desc->tamInfo = tamInfo;
    }
    return desc;
}

/*************** INSERE NO INICIO ***************/
int insereNovoPrimeiro(struct descLDE *p, info *novo)
{	
    struct noLDE *temp;
    int ret = FRACASSO;

    if( (temp = (struct noLDE*) malloc(sizeof(struct noLDE))) != NULL ) 
    {       memcpy(&(temp->dados), novo, p->tamInfo);
            temp->prox = p->inicio;
            temp->ant = NULL;
            if(p->inicio != NULL) 
                  p->inicio->ant = temp;
            p->inicio = temp;
            ret = SUCESSO;
    }

    return ret;
}

/*************** INSERE NO FINAL ***************/
int insereNovoUltimo(struct descLDE *p, info *novo)
{ 	
    struct noLDE *temp=NULL, *aux;
    int ret = FRACASSO;
	
	temp = (struct noLDE *) malloc(sizeof(struct noLDE)); 
   	
   	if (p->inicio == NULL)
		ret = insereNovoPrimeiro(p,novo);
	else
      {     aux = p->inicio;
            while(aux->prox != NULL)
                    aux = aux->prox;
			//temp = (struct noLDE *) malloc(sizeof(struct noLDE));//<<<ANALISAR o EFEITO COLATERAL 
            if(temp != NULL) 
            { 	memcpy(&(temp->dados), novo, p->tamInfo);        
				aux->prox = temp;
				temp->prox=NULL;
				temp->ant = aux;
				ret = SUCESSO; 
			}
			else
				ret=FRACASSO; 
    }
    return ret;
}

/*************** INSERE NA POSIÇÃO LÓGICA ***************/
int insereNaPoslog (struct descLDE *p, info *novo, unsigned int posLog)
{ 
    struct noLDE *temp, *pos;
    unsigned int cont=0, ret=FRACASSO;

    if(posLog <= 0)
	{	 printf("PosLog %i inexistente: PosLog <= 0 ou posLog > tamanho da lista \n", posLog);
		 return ret;
	}
	if ( p->inicio == NULL)    
	{	 printf("A operação não insere em lista vazia \n");
		 return ret;
	}    
    else
	{   cont = 1;
		temp = (struct noLDE*) malloc(sizeof(struct noLDE)); 		
		memcpy(&(temp->dados), novo, p->tamInfo);
        if(posLog == cont) 
        {   /*PosLog == 1: inserção de um novo primeiro elemento*/
                    temp->prox = p->inicio;
                    p->inicio->ant = temp;
                    temp->ant = NULL;
                    p->inicio = temp;
                    ret = SUCESSO;
        }
        else 
          {                                /* posLog >= 2, no minimo igual a dois */
                    pos = p->inicio->prox;      /*pos:apontara p/ no de dados na posLog==cont*/
                    if (pos != NULL) 
                    {   cont = 2;
                        while(cont < posLog && pos->prox != NULL) 
                        {   /*1<posLog<=tam.dalista*/
                            pos = pos->prox;
                            cont++;
                        }
                        if (cont == posLog) 
                        {   	
                            temp->prox = pos;
                            temp->ant = pos->ant;
                            pos->ant->prox = temp;
                            pos->ant = temp;
                            ret = SUCESSO;
                        }
						else
						{ 	printf("PosLog %i inexistente: PosLog <= 0 ou posLog > tamanho da lista \n", posLog);
							//fprintf(stderr, "PosLog %i inexistente: PosLog <= 0 ou posLog > tamanho da lista \n", posLog);
							ret=FRACASSO;
						}                        
                    }
          }
    }
   return ret;
}

/*************** REMOVE DO INICIO ***************/
int removeOprimeiro(struct descLDE *p, info *reg)
{  	
    int ret = FRACASSO;

    if(p->inicio != NULL) 
    {	
        memcpy(reg, &(p->inicio->dados), p->tamInfo);

        if(p->inicio->prox == NULL) 
        {	
            free(p->inicio);             
            p->inicio = NULL;
        }
        else 
        {	
            p->inicio = p->inicio->prox;

            free(p->inicio->ant);
            p->inicio->ant = NULL;
        }
        ret = SUCESSO;
    }

    return ret;
}


/*************** REMOVE DO FINAL ***************/
int removeOultimo(struct descLDE *p, info *reg)
{	
    struct noLDE *aux;
    int ret = FRACASSO;

    if(p->inicio != NULL) 
    {	
        aux = p->inicio;
        while(aux->prox != NULL) 
               aux = aux->prox;
        
        memcpy(reg, &(aux->dados), p->tamInfo);

        if(aux->ant != NULL) 
            aux->ant->prox = NULL;     /*há mais de 1 item na lista e aux aponta p/ o último*/
        else 
            p->inicio = NULL;        /*há apenas um elemento na lista*/
        
        free(aux);
        ret = SUCESSO;
    }

    return ret;

}

/*************** REMOVE DA POSIÇÃO LÓGICA ***************/
int removeDaPoslog(struct descLDE *p, info *reg, unsigned int posLog)
{	
    struct noLDE *pos;
    unsigned int cont=0, ret = FRACASSO;

    if( p->inicio != NULL && posLog > 0) 
    { 	
        cont = 1;
        if(posLog == cont)   /*PosLog == 1: inserção de um novo primeiro elemento*/
            ret = removeOprimeiro(p, reg);
        else 
        {                              /* posLog > 1, no minimo igual a dois */
            pos = p->inicio->prox;           /*pos:apontara p/ no de dados na posLog==cont*/
            if (pos != NULL) 
            {
                cont = 2;
                while(cont < posLog && pos->prox != NULL) /*1<posLog<=tam.dalista*/
                {   
                    pos = pos->prox;
                    cont++;
                }
                if (cont == posLog) /* encontrou a posLog ? */
                {             
                    if(pos->prox != NULL) /*posLog eh aa do ultimo elemento ?*/
							pos->prox->ant = pos->ant;
                    pos->ant->prox = pos->prox;
                    memcpy(reg, &(pos->dados), p->tamInfo);

                    free(pos);
                    ret = SUCESSO;
                }
            }
        }
    }

    return ret;
}

/*************** BUSCA NO INICIO ***************/
int buscaOprimeiro(struct descLDE *p, info *reg)
{  
    int ret = FRACASSO;

    if(p->inicio != NULL) 
    { 	
        memcpy(reg, &(p->inicio->dados), p->tamInfo);
        ret = SUCESSO;
    }

    return ret;
}

/*************** BUSCA NO FINAL ***************/
int buscaOultimo(struct descLDE *p, info *reg)
{	
    struct noLDE *aux;
    int ret = FRACASSO;
    if(p->inicio != NULL) 
    {	
        aux = p->inicio;
        while(aux->prox!=NULL) 
            aux = aux->prox;
        
        memcpy(reg, &(aux->dados), p->tamInfo);
        ret = SUCESSO;
    }

    return ret;
}

/*************** BUSCA NA POSIÇÃO LÓGICA ***************/
int buscaNaPoslog(struct descLDE *p, info *reg, unsigned int posLog)
{	
    int cont, ret = FRACASSO;
    struct noLDE *pos;

    if(p->inicio != NULL && posLog > 0) 
    {	
        cont = 1;
        pos = p->inicio;
        while(cont < posLog && pos->prox != NULL) 
        {  	
            pos = pos->prox;
            cont++;
        }
        if(cont == posLog) 
        {	
            memcpy(reg, &(pos->dados), p->tamInfo);
            ret = SUCESSO;
        }
    }

    return ret;
}

/*************** TAMANHO ***************/
int tamanhoDaLista(struct descLDE *p)
{ 
    int tam=0;
    struct noLDE *aux;
    aux = p->inicio;
    if(aux == NULL) 
        tam=0;
    else  
        while(aux != NULL) 
        { 	
            aux = aux->prox;
            tam++;
        }
    return tam;
}

/*************** PURGA ***************/
int reinicia(struct descLDE *p)
{	
    if(p->inicio != NULL) 
    {	
        while(p->inicio->prox != NULL) 
        {   p->inicio = p->inicio->prox;
            free(p->inicio->ant);
        }
        free(p->inicio);
        p->inicio = NULL;
        return SUCESSO;
    }
    else 
		return FRACASSO;
}

/*************** DESTROI ***************/
struct descLDE* destroi(struct descLDE *p)
{
    reinicia(p);
    free(p);
    return NULL;
}

/*
int enderecosFisicos(struct descLDE *p)
{    
    struct noLDE *aux;

    if(p->inicio != NULL) 
     {	
        printf("tamanho de cada no: %u bytes\n", p->tamInfo);
        aux = p->inicio;
        while(aux != NULL) 
        {	
            printf("endereco %X \n", (unsigned int)aux);
            aux = aux->prox;
        }
        if(p->inicio->prox) 
            printf("distancia entre nos: %X \n", p->inicio - p->inicio->prox);
        return SUCESSO;
    }
    
    return FRACASSO;
}
*/

