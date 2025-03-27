#include "arq.h"

descPilha *criaPilha()
{
    descPilha *p;
    //verifica a alocacao de memoria inicial para a pilha(1, porque vai variar e acordo com insercoes e remocoes)
    if ((p = malloc(1 * sizeof(descPilha))) == NULL)
    {
        printf("ERRO! Nao foi possível criar a pilha!\n\n");
        free(p);
        p = NULL;
        return NULL;
    }
    else
    {
        printf("Sucesso na criacao da pilha!\n\n");
        //verifica a alocacao de memoria inicial para o vetor onde a pilha estara inserida(1, porque vai variar e acordo com insercoes e remocoes)
        if ((p->vetor = malloc(1 * sizeof(noPilha))) == NULL)
        {
            printf("ERRO! Nao foi possivel inicializar o vetor!\n\n");
            free(p->vetor);
            free(p);
            p->vetor = NULL;
            p = NULL;
            return NULL;
        }
        else
        {
            printf("Sucesso na inicializacao do vetor!!\n\n");
            //inicializacao dos campos da pilha
            p->topo = &(p->vetor[0]);
            p->vetor[0].anterior = NULL;
            p->vetor[0].data.str[0] = '\0';
            p->tam = 0;
        }
    }
    return p;
}
int insereNaPilha(descPilha *p, info *novo)
{
    if (p == NULL)//verifica a existencia da pilha
    {
        printf("Pilha não criada!!\n\n");
        return 0;
    }
    if (p->vetor == NULL)//verifica a existencia do vetor
    {
        printf("Vetor não inicializado!\n\n");
        return 0;
    }

    //realloca a memoria do vetor para receber a proxima string
    if ((p->vetor = realloc(p->vetor, ((p->tam) + 1) * sizeof(noPilha))) == NULL)
    {
        printf("PROBLEMA NA REALOCACAO DE MEMORIA!!\n\n");
        return 0;
    }

    //insere a string no vetor
    strcpy(p->vetor[p->tam].data.str, novo->str);

    //redefine o topo da pilha
    p->topo = &(p->vetor[p->tam]);

    if (p->tam != 0)//encadeia o novo termo com o seu antecessor
    {
        p->topo->anterior = &(p->vetor[p->tam - 1]);
    }

    p->tam += 1;

    return 1;
}
int removeDaPilha(descPilha *p, info *removido)
{
    if (p == NULL)//verifica a existencia da pilha
    {
        printf("Pilha não criada!\n\n");
        return 0;
    }
    if (p->vetor == NULL)//verifica a existencia de vetor
    {
        printf("Vetor nao inicializado!\n\n");
        return 0;
    }

    //realloca a memoria para 1 termo a menos (o vetor fica com a tamanho da quantia de termos exata que ele tem)
    if ((p->vetor = realloc(p->vetor, (p->tam) * sizeof(noPilha))) == NULL)
    {
        printf("ERRO NA REALOCACAO DE MEMORIA!\n\n");
        return 0;
    }

//define a string removida
    (*removido) = p->topo->data;
    //redefine a string excluida
    p->vetor[p->tam-1].data.str[0] = '\0';
    //redefine o ponteiro da string excluida que aponta para seu antecessor como NULL "quebrando" o encadeamento entre eles 
    p->topo->anterior = NULL;
    //redefine o tamanho
    p->tam -= 1;
    //redefine o topo da pilha
    p->topo = &(p->vetor[p->tam-1]);
    return 1;
}