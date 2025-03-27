#include "arq.h"

/*************** CRIA FILA SEM REF***************/
descFDEsRef *criaA(int tamInfo)
{
    descFDEsRef *desc = (descFDEsRef *)malloc(tamInfo * sizeof(descFDEsRef));
    if (desc != NULL)
    {
        desc->ultimo = NULL;
        desc->primeiro = NULL;
        desc->tamInfo = tamInfo;
    }
    return desc;
}

/*************** INSERE NA CAUDA FILA SEM REF***************/
int insereA(info *novo, descFDEsRef *p, int (*compara)(info *novo, info *visitado), int *nIteracao)
{
    int result;
    noF *novoNoFila = NULL, *visitado = NULL;

    if ((novoNoFila = (noF *)malloc(sizeof(noF))) != NULL)
    {
        memcpy(&(novoNoFila->dados), novo, sizeof(info));
        if (p->primeiro == NULL && p->ultimo == NULL) /*fila vazia*/
        {
            //insere o elemento ja que a fila esta vazia
            novoNoFila->atras = NULL;
            novoNoFila->frente = NULL;
            p->primeiro = novoNoFila;
            p->ultimo = novoNoFila;
            (*nIteracao)++;
        }
        else
        {
            //compara o novo elemento com a cauda
            result = (*compara)(novo, &(p->ultimo->dados));

            if (result == -1 || result == 0) //novo elemento é o de menor prioridade ou igual ao de menor prioridade
            {
                //menor prioridade
                novoNoFila->atras = NULL;
                novoNoFila->frente = p->ultimo;
                p->ultimo->atras = novoNoFila;
                p->ultimo = novoNoFila;
                (*nIteracao)++;
            }
            else
            {
                //compara o novo elemento com o primerio da fila
                result = (*compara)(novo, &(p->primeiro->dados));

                if (result == 1)
                {
                    // maior prioridade
                    novoNoFila->frente = NULL;
                    novoNoFila->atras = p->primeiro;
                    p->primeiro->frente = novoNoFila;
                    p->primeiro = novoNoFila;
                    (*nIteracao)++;
                }
                else
                {
                    //verifica se ta mais perto do primeiro ou do ultimo
                    int difMaior = p->primeiro->dados.ranking - novo->ranking;
                    int difMenor = novo->ranking - p->ultimo->dados.ranking;

                    if (difMaior < difMenor)
                    {
                        //mais perto do primeiro
                        visitado = p->primeiro->atras;//segunda maior prioridade
                        
                        (*nIteracao)++;

                        //percorre a fila a partir do primeiro
                        while (visitado->atras != NULL && (*compara)(novo, &(visitado->dados)) != 1)
                        {
                            visitado = visitado->atras; //comparou(A,B) e A < B ou A == B
                            (*nIteracao)++;
                        }

                        //insere o novo no na posicao correta para ele
                        novoNoFila->atras = visitado;
                        novoNoFila->frente = visitado->frente;
                        visitado->frente->atras = novoNoFila;
                        visitado->frente = novoNoFila;
                        (*nIteracao)++;
                    }
                    else
                    {
                        //sera mais perto do ultimo
                        visitado = p->ultimo->frente;
                       
                        (*nIteracao)++;

                        //percore a fila a partir da frente
                        while (visitado->frente != NULL && (*compara)(novo, &(visitado->dados)) == 1)
                        {
                            visitado = visitado->frente;
                            (*nIteracao)++;
                        }

                        //insere o novo no na posicao correta
                        novoNoFila->atras = visitado->atras;
                        novoNoFila->frente = visitado;
                        visitado->atras->frente = novoNoFila;
                        visitado->atras = novoNoFila;
                        (*nIteracao)++;
                    }
                }
            }
        }
        return 1;//sucesso na insercao
    }

    return 0;//erro na alocacao
}

/*************** REMOVE DA FILA SEM REF***************/
int remove_A(info *reg, descFDEsRef *p,int chave)
{
    int ret = 0;//controlaremos o retorno por essa variavel

    noF *aux = p->ultimo;//ponteiro auxuliar para o ultimo elemento da fila

    if (p->ultimo != NULL && p->primeiro != NULL)//verificacao da fila vazia
    {
        memcpy(reg, &(p->primeiro->dados), p->tamInfo);

        if (aux == p->primeiro)//caso tenha 1 elemento apenas
        { 
            free(p->primeiro);//libera esse unico elemento
            p->primeiro = p->ultimo = NULL;
        }
        else
        {
            if (chave == 1)//remove o primeiro elemento
            {
                p->primeiro = p->primeiro->atras;
                free(p->primeiro->frente);
                p->primeiro->frente = NULL;
            }
            else//remove o ultimo elemento
            {
                p->ultimo = p->ultimo->frente;
                free(p->ultimo->atras);
                p->ultimo->atras = NULL;
            }
        }
        ret = 1;//sucesso na remocao
    }

    return ret;
}

/*************** BUSCA NA FRENTE FILA SEM REF***************/
int buscaNaFrenteA(info *reg, descFDEsRef *p)
{
    int ret = 0;

    if (p->primeiro != NULL && p->ultimo != NULL)
    {
        memcpy(reg, &(p->primeiro->dados), p->tamInfo);
        ret = 1;
    }

    return ret;
}

/*************** BUSCA NA CAUDA FILA SEM REF***************/
int buscaNaCaudaA(info *reg, descFDEsRef *p)
{
    int ret = 0;

    if (p->ultimo != NULL && p->primeiro != NULL)
    {
        memcpy(reg, &(p->ultimo->dados), p->tamInfo);
        ret = 1;
    }

    return ret;
}

/*************** VAZIA? (FILA SEM REF)***************/
int testaVaziaA(descFDEsRef *p)
{
    if (p->primeiro == NULL && p->ultimo == NULL)
    {
        return 1;
    }

    return 0;
}

/*************** TAMANHO FILA SEM REF***************/
int tamanhoDaFilaA(descFDEsRef *p)
{
    int tam = 0;
    noF *aux = p->ultimo;

    while (aux != NULL)
    {
        tam++;
        aux = aux->frente;
    }

    return tam;
}

/*************** PURGA FILA SEM REF***************/
int reiniciaA(descFDEsRef *p)
{
    int ret = 0;
    noF *aux = NULL;

    if (p->primeiro != NULL && p->ultimo != NULL)
    {
        aux = p->ultimo->frente;
        while (aux != NULL)
        {
            free(p->ultimo);
            p->ultimo = aux;
            aux = aux->frente;
        }

        free(p->ultimo);
        p->primeiro = NULL;
        p->ultimo = NULL;
        ret = 1;
    }
    return ret;
}

/**************INVERTE FILA SEM REF****************/
int inverteA(descFDEsRef *p)
{
    if (testaVaziaA(p) == 1)
    {
        printf("FILA VAZIA!\n\n");
        return 0;
    }
    noF *aux = p->primeiro;
    p->primeiro = p->ultimo;
    p->ultimo = aux;
    return 1;
}

/*************** DESTROI FILA SEM REF***************/
descFDEsRef *destroiA(descFDEsRef *p)
{
    reiniciaA(p);
    free(p);
    return NULL; // aterra o ponteiro externo, declarado na aplicação
}

/*************** CRIA FILA COM REF***************/
descFDEcRef *criaB(int tamInfo)
{
    descFDEcRef *desc = (descFDEcRef *)malloc(tamInfo * sizeof(descFDEcRef));
    if (desc != NULL)
    {
        desc->ultimo = NULL;
        desc->primeiro = NULL;
        desc->refMovel = NULL;
        desc->tamInfo = tamInfo;
    }
    return desc;
}

/*************** INSERE NA FILA COM REF***************/
int insereB(info *novo, descFDEcRef *p, int (*compara)(info *novo, info *visitado), int *nIteracao)
{ 
    int result;
    noF *novoNoFila = NULL, *visitado = NULL;
    if ((novoNoFila = (noF *)malloc(sizeof(noF))) != NULL)
    {
        memcpy(&(novoNoFila->dados), novo, sizeof(info));
        if (p->primeiro == NULL && p->ultimo == NULL) /*fila vazia*/
        {
            //printf("FILA VAZIA\n");
            novoNoFila->atras = NULL;
            novoNoFila->frente = NULL;
            p->primeiro = novoNoFila;
            p->ultimo = novoNoFila;
            p->refMovel = novoNoFila;
            (*nIteracao)++;
        }
        else
        {
            result = (*compara)(novo, &(p->ultimo->dados));
            if (result == -1 || result == 0) /*novo elemento é o de menor prioridade ou igual ao de menor prioridade */
            {
               // printf("MENOR PRIORI\n");
                novoNoFila->atras = NULL;
                novoNoFila->frente = p->ultimo;
                p->ultimo->atras = novoNoFila;
                p->ultimo = novoNoFila;
                p->refMovel = novoNoFila;
                (*nIteracao)++;
            }
            else
            {
                result = (*compara)(novo, &(p->primeiro->dados));
                if (result == 1) // maior priori ou igual
                {
                   // printf("MAIOR PRIORI\n");
                    novoNoFila->frente = NULL;
                    novoNoFila->atras = p->primeiro;
                    p->primeiro->frente = novoNoFila;
                    p->primeiro = novoNoFila;
                    p->refMovel = novoNoFila;
                    (*nIteracao)++;
                }
                else
                {
                    int difMaior = (p->primeiro->dados.ranking) - (novo->ranking), difMenor = (novo->ranking) - (p->ultimo->dados.ranking), difRef = (novo->ranking) - (p->refMovel->dados.ranking);
                    if (difRef < 0)
                    {
                        difRef *= (-1);
                    }

                    if (difMaior < difMenor)
                    {
                        if (difMaior < difRef)
                        {
                           // printf("MAIS PROX DO PRIMEIRO\n");
                            visitado = p->primeiro->atras; /*segunda maior prioridade */
                            (*nIteracao)++;
                            int show = 2;
                            //printf("VERIFICANDO O %d ELEMENTO\n", show);
                            while (visitado->atras != NULL && (*compara)(novo, &(visitado->dados)) != 1)
                            {
                                show++;
                               // printf("VERIFICANDO O %d ELEMENTO\n", show);
                                visitado = visitado->atras; /*comparou(A,B) e A < B ou A == B*/
                                (*nIteracao)++;
                            }
                            novoNoFila->atras = visitado;
                            novoNoFila->frente = visitado->frente;
                            visitado->frente->atras = novoNoFila;
                            visitado->frente = novoNoFila;
                            p->refMovel = novoNoFila;
                            (*nIteracao)++;
                        }
                        else
                        {
                            //printf("MAIS PROX DO REF MOVEL\n");
                            visitado = p->refMovel;
                            (*nIteracao)++;
                           // printf("COMPARANDO COM O REF MOVEL\n");
                           // printf("COMPARANDO COM OS PROX:\n");
                            int show = 1;
                            while (visitado->frente != NULL && (*compara)(novo, &(visitado->dados)) == 1)
                            {
                               // printf("%d\n", show);
                                show++;
                                visitado = visitado->frente;
                                (*nIteracao)++;
                            }
                            novoNoFila->atras = visitado->atras;
                            novoNoFila->frente = visitado;
                            visitado->atras->frente = novoNoFila;
                            visitado->atras = novoNoFila;
                            p->refMovel = novoNoFila;
                            (*nIteracao)++;
                        }
                    }
                    else
                    {
                        if (difMenor <= difRef)
                        {
                            //printf("MAIS PROX DO ULTIMO\n");
                            visitado = p->ultimo->frente;
                            (*nIteracao)++;
                            int show = 1;
                            //printf("COMPARANDO COM O %d A FRENTE DO ULTIMO\n", show);
                            while (visitado->frente != NULL && (*compara)(novo, &(visitado->dados)) == 1)
                            {
                                show++;
                                printf("COMPARANDO COM O %d A FRENTE DO ULTIMO\n", show);
                                visitado = visitado->frente;
                                (*nIteracao)++;
                            }
                            novoNoFila->atras = visitado->atras;
                            novoNoFila->frente = visitado;
                            visitado->atras->frente = novoNoFila;
                            visitado->atras = novoNoFila;
                            p->refMovel = novoNoFila;
                            (*nIteracao)++;
                        }
                        else
                        {
                            //printf("MAIS PROX DO REF MOVEL\n");
                            visitado = p->refMovel;
                            (*nIteracao)++;
                            //printf("COMPARANDO COM O REF MOVEL\n");
                            //printf("COMPARANDO COM OS PROX:\n");
                            int show = 1;
                            while (visitado->atras != NULL && (*compara)(novo, &(visitado->dados)) != 1)
                            {
                                //printf("%d\n", show);
                                show++;
                                visitado = visitado->atras;
                                (*nIteracao)++;
                            }
                            novoNoFila->atras = visitado;
                            novoNoFila->frente = visitado->frente;
                            visitado->frente->atras = novoNoFila;
                            visitado->frente = novoNoFila;
                            p->refMovel = novoNoFila;
                            (*nIteracao)++;
                        }
                    }
                }
            }
        }
        return 1;
    }

    return 0;
    
   

}

/*************** REMOVE DA FILA COM REF***************/
int remove_B(info *reg, descFDEcRef *p, int chave)
{
    int ret = 0;
    noF *aux = p->ultimo;//auxiliar apontando para o ultimo no da fila

    if (p->ultimo != NULL && p->primeiro != NULL)//verifica se a fila esta vazia
    {
        memcpy(reg, &(p->primeiro->dados), p->tamInfo);

        if (aux == p->primeiro)
        { // caso tenha 1 elemento apenas
            free(p->primeiro);
            p->primeiro = p->ultimo = NULL;
        }
        else
        {
            if (chave == 1)
            {
                //analisa se a remocao sera to primeiro elemento da fila
                p->primeiro = p->primeiro->atras;
                free(p->primeiro->frente);
                p->primeiro->frente = NULL;
            }
            else
            {
                //atualizara para apontar para o anterior
                p->ultimo = p->ultimo->frente;
                free(p->ultimo->atras);
                p->ultimo->atras = NULL;
            }
        }
        ret = 1;
    }

    return ret;
}

/*************** BUSCA NA FRENTE FILA COM REF***************/
int buscaNaFrenteB(info *reg, descFDEcRef *p)
{
    int ret = 0;

    if (p->primeiro != NULL && p->ultimo != NULL)
    {
        memcpy(reg, &(p->primeiro->dados), sizeof(info));
        ret = 1;
    }

    return ret;
}

/*************** BUSCA NA CAUDA FILA COM REF***************/
int buscaNaCaudaB(info *reg, descFDEcRef *p)
{
    int ret = 0;

    if (p->ultimo != NULL && p->primeiro != NULL)
    {
        memcpy(reg, &(p->ultimo->dados), sizeof(info));
        ret = 1;
    }

    return ret;
}

/*************** VAZIA? (FILA COM REF) ***************/
int testaVaziaB(descFDEcRef *p)
{
    if (p->primeiro == NULL && p->ultimo == NULL)
    {
        return 1;//vazia
    }

    return 0;
}

/*************** TAMANHO FILA COM REF***************/
int tamanhoDaFilaB(descFDEcRef *p)
{
    int tam = 0;
    noF *aux = p->ultimo;

    while (aux != NULL)
    {
        tam++;
        aux = aux->frente;
    }

    return tam;
}

/*************** PURGA FILA COM REF***************/
int reiniciaB(descFDEcRef *p)
{
    int ret = 0;
    noF *aux = NULL;

    if (p->primeiro != NULL && p->ultimo != NULL)
    {
        aux = p->ultimo->frente;
        while (aux != NULL)
        {
            free(p->ultimo);
            p->ultimo = aux;
            aux = aux->frente;
        }

        free(p->ultimo);
        p->primeiro = NULL;
        p->ultimo = NULL;
        p->refMovel = NULL;
        ret = 1;
    }
    return ret;
}

/*************** DESTROI FILA COM REF ***************/
descFDEcRef *destroiB(descFDEcRef *p)
{
    reiniciaB(p);
    free(p);
    return NULL; // aterra o ponteiro externo, declarado na aplicação
}

/**************INVERTE FILA COM REF****************/
int inverteB(descFDEcRef *p)
{
    if (testaVaziaB(p) == 1)//verifica se a fila esta vazia
    {
        printf("FILA VAZIA!\n\n");
        return 0;
    }
    if (p->primeiro == p->ultimo)//verifica se a fila possui apenas um
    {
        printf("FILA COM UM ELEMENTO\n");
        return 0;
    }
    
    noF *aux = p->primeiro->atras;//auxiliar para andar pela fila

        while (aux->atras != NULL)
        {
            //inverte os ponteiros atras e frente
            noF *helper = aux->atras;
            aux->atras = aux->frente;
            aux->frente = helper;
            aux = helper;
        }
    
    //atualizacao dos ponteiros do primeiro e ultimo elemento da fila
    noF *aux2 = p->primeiro;
    p->primeiro->frente = p->primeiro->atras;
    p->primeiro->atras = NULL;
    p->ultimo->atras = p->ultimo->frente;
    p->ultimo->frente = NULL;
    p->primeiro = p->ultimo;
    p->ultimo = aux2;

    return 1;//sucesso
}