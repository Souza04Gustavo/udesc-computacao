#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "arq.h"

int numElementosInseridos(MP *desc)
{
    //teste de verificacao de existencia da multipilha
    if (desc == NULL)
    {
        printf("Multipilha inexistente!\n\n");
        return -1;
    }

    int qnt = 0;
    //conta a quantidade de elementos da pilha 1
    if (desc->topo1 > -1)
    {
        qnt += desc->topo1 + 1;
    }
 
    //conta a quantidade de elementos da pilha 2
    if (desc->topo2 < desc->tamInfo)
    {
        qnt += (desc->tamInfo - desc->topo2);
    }

    //retorna a soma dos elementos
    return qnt;
}

MP *cria(int tamInfo)
{
    MP *desc = NULL;
    noPi *aux;

    //verificação para garantir que o tamanho que se deseja criar seja valido
    if (tamInfo > 0)
    {
        //verificação da multipilha
        if ((desc = malloc(sizeof(MP))) == NULL)
        {
            return NULL;
        }
        else
        {
            //verificacao do vetor
            if ((desc->vet = malloc(tamInfo * sizeof(noPi))) == NULL)
            {
                free(desc);
                return NULL;
            }
            else
            {
                //verificacao do vetor auxiliar
                if ((desc->vetAux = malloc(tamInfo * sizeof(int))) == NULL)
                {
                    free(desc->vet);
                    free(desc);
                    return NULL;
                }
                else//é possivel criar
                {

                    desc->topo1 = -1; //topo da pilha 1
                    desc->topo2 = tamInfo; //topo da pilha 2 comeca no final do vetor
                    desc->tamInfo = tamInfo;
                    aux = desc->vet;
                    //topo das subpilhas
                    desc->pilha1.topo = -1;
                    desc->pilha2.topo = -1;
                    for (int i = 0; i < tamInfo; i++)
                    {
                        (aux + i)->dados.inteiro = 0; //inicializa os inteiros do vetor aux como nulo 
                        (aux + i)->dados.letra = '\0'; //inicializa os inteiros do vetor aux como "nulo"
                        desc->vetAux[i] = -1;
                    }
                    //retorna o ponteiro para multipilha recem criada
                    return desc;
                }
            }
        }
    }

    return NULL;
}

int insereNaPilha(MP *p, int escPilha, info *novo)
{
   //verifica a multipilha
    if (p == NULL)
    {
        printf("ERRO! Multipilha inexistente!\n\n");
        return 0;
    }

   //verifica o vetor
    if (p->vet == NULL)
    {
        printf("ERRO! Vetor inexistente!\n\n");
        return 0;
    }

   //verifica se os topos colidem
    if (p->topo2 - p->topo1 == 1)
    {
        printf("ERRO! Vetor totalmente preenchido!!\n\n");
        return 0;
    }

    if (escPilha == 1)//se o usuario escolheu a pilha 1
    {
        //incrementa o topo
        p->pilha1.topo += 1;
        p->topo1 += 1;

        p->pilha1.pontTopo = &(p->vet[p->topo1]);//atualiza o topo da pilha 1

        if (p->pilha1.topo == 0)//ve se é o primeiro da pilha 1
        {
            p->pilha1.pontTopo->ant = NULL;//nao tem anterior
        }
        else//atualiza o novo e o antigo topo
        {
            p->pilha1.pontTopo->ant = &(p->vet[p->topo1 - 1]);
            p->pilha1.pontTopo->ant->prox = p->pilha1.pontTopo;
        }

        p->pilha1.pontTopo->prox = NULL;//proximo nó é null

        //copia o novo elemento para o topo
        p->pilha1.pontTopo->dados = (*novo);
        p->vet[p->topo1].dados = (*novo);
        return 1;
    }
    else if (escPilha == 2)//se foi escolhido a pilha 2
    {
        //incremente o top
        p->pilha2.topo += 1;
        p->topo2 -= 1;

        p->pilha2.pontTopo = &(p->vet[p->topo2]);//ponteiro do topo apontara para o novo

        if (p->pilha2.topo == 0)
        {
            p->pilha2.pontTopo->ant = NULL;
        }
        else//atualiza os ponteiros do topo novo e do anterior
        {
            p->pilha2.pontTopo->ant = &(p->vet[p->topo2 + 1]);
            p->pilha2.pontTopo->ant->prox = p->pilha2.pontTopo;
        }
        p->pilha2.pontTopo->prox = NULL;
        //copia do novo para o topo da pilha
        p->pilha2.pontTopo->dados = (*novo);
        p->vet[p->topo2].dados = (*novo);
        return 1;
    }

    return 0;

}

int removeDaPilha(MP *p, int nPilha, info *removido)
{
    //verifica a multipilha
    if (p == NULL)
    {
        printf("ERRO!! Multipilha inexistente!\n\n");
        return 0;
    }
    //verifica se ha algo nas pilhas
    if (p->pilha1.topo == -1 && p->pilha2.topo == -1)
    {
        printf("Vetor vazio!\n\n");
        return 0;
    }

    if (nPilha == 1)
    {
        if (p->topo1 == -1)
        {
            printf("A pilha está vazia!!!\n\n");
            return 0;
        }
    }
    if (nPilha == 2 && p->topo2 == p->tamInfo)
    {
        printf("A pilha está vazia!!\n\n");
        return 0;
    }

    if (nPilha == 1)
    {
        if (p->pilha1.pontTopo->ant != NULL)//verifica se a pilha tem mais de um elemento
        {
            p->pilha1.pontTopo = p->pilha1.pontTopo->ant;//atualiza o topo para apontar para o anterior
            //copiamos os dados removidos do no para a variavel "removido"
            memcpy(&(*removido), &(p->pilha1.pontTopo->prox->dados), sizeof(info)); 
            //atualiza a pilha ao anular os ponteiros do no removido
            p->pilha1.pontTopo->prox->ant = NULL;
            p->pilha1.pontTopo->prox = NULL;
        }
        else//so tem um elemento
        {
            //copiamos os dados removidos do no para a variavel "removido"
            memcpy(&(*removido), &(p->pilha1.pontTopo->dados), sizeof(info));

            //limpa os ponteiros do topo
            p->pilha1.pontTopo->ant = NULL;
            p->pilha1.pontTopo->prox = NULL;
        }
        //anula os dados do vet principal da posicao anterior
        p->vet[p->topo1].dados.inteiro = 0;
        p->vet[p->topo1].dados.letra = '\0';
        //decrementa os indices do topo da pilha 1
        p->pilha1.topo -= 1;
        p->topo1 -= 1;
    }
    else//escolheu a pilha 2
    {
        if (p->pilha2.pontTopo->ant != NULL)//verifica se tem mais de um elemento
        {
            //atualiza para apontar para o no anterior
            p->pilha2.pontTopo = p->pilha2.pontTopo->ant;

            //copia os dados do no removido
            memcpy(&(*removido), &(p->pilha2.pontTopo->prox->dados), sizeof(info));
            //desvenciula o no removido
            p->pilha2.pontTopo->prox->ant = NULL;
            p->pilha2.pontTopo->prox = NULL;
        }
        else
        {
            //copia os dados do no removido 
            memcpy(&(*removido), &(p->pilha2.pontTopo->dados), sizeof(info));
            //atualiza o topo
            p->pilha2.pontTopo->ant = NULL;
            p->pilha2.pontTopo->prox = NULL;
        }

        //limpa o vetor principal
        p->vet[p->topo2].dados.inteiro = 0;
        p->vet[p->topo2].dados.letra = '\0';
        //decrementa o topo da pilha 2
        p->pilha2.topo -= 1;
        p->topo2 += 1;
    }

    return 1;
}

int consultaTopo(MP *p, int pilhaAlvo, info *consultado)
{
    //verifica a multipilha
    if (p == NULL)
    {
        printf("Multipilha inexistente!\n\n");
        return 0;
    }

    if (pilhaAlvo == 1)
    {
        if (p->topo1 == -1)//não ha topo
        {
            printf("A pilha esta vazia!\n\n");
            return 0;
        }
        //topo sera definido aqui
        (*consultado) = p->vet[p->topo1].dados;
    }
    else
    {
        if (p->topo2 == p->tamInfo)//topo da pilha vazio
        {
            printf("A pilha esta vazia!\n\n");
            return 0;
        }
        //topo definido aqui
        (*consultado) = p->vet[p->topo2].dados;
    }
    return 1;
}

MP *destroi(MP *p)
{
    free(p->vet);//libera o vetor principal
    free(p->vetAux);//libera o auxiliar
    return NULL;//retorna null para dizer que a estrutura foi destruida
}

int reinicializacaoPilha(MP *a, int escPilha)
{
    if (a == NULL)//multipilha nao existe
    {
        printf("Multipilha inexistente!\n");
        return 0;
    }

    if (escPilha == 1)
    {
        // reinicializando a pilha 1
        for (int i = 0; i <= a->topo1; i++)
        {
            //zera os elementos do vetor auxiliar e do principal 
            a->vetAux[i] = -1;
            a->vet[i].dados.inteiro = 0;
            a->vet[i].dados.letra = '\0';
        }
        //redefinicao dos ponteiros do topo
        a->pilha1.topo = -1;
        a->topo1 = -1;
        a->pilha1.pontTopo = NULL;
    }
    else
    {
        //reinicializando a pila 2
        for (int i = a->topo2; i < a->tamInfo; i++)
        {
             //zera os elementos do vetor auxiliar e do principal 
            a->vetAux[i] = -1;
            a->vet[i].dados.inteiro = 0;
            a->vet[i].dados.letra = '\0';
        }
         //redefinicao dos ponteiros do topo
        a->pilha2.topo = -1;
        a->topo2 = a->tamInfo;
        a->pilha2.pontTopo = NULL;
    }

    return 1;

}