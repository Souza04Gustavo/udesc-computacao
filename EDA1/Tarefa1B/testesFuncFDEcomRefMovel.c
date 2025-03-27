#include "arq.h"

void menu(descFDEcRef *p)
{
    int tam = 0;
    int opc = 1;
    info auxInfo;
    noF *aux;
    int nDeIteracoesParaInserir = 0;
    int cont = 0;
    while (opc != 0)
    {
        printf("------------------------MENU----------------------------\n");
        printf("-------------INSERIR ELEMENTO NA FILA(1)----------------\n");
        printf("------------REMOVER PRIMEIRO ELEMENTO(2)----------------\n");
        printf("---------REMOVER ULTIMO ELEMENTO DA FILA(3)-------------\n");
        printf("------------------BUSCA NA CAUDA(4)---------------------\n");
        printf("-----------------BUSCA NA FRENTE(5)---------------------\n");
        printf("-----------------TAMANHO DA FILA(6)---------------------\n");
        printf("-----------------INVERTE A FILA(7)----------------------\n");
        printf("---------------------REINICIA(8)------------------------\n");
        printf("---------------------DESTROI(9)-------------------------\n");
        printf("-------------------TESTE VAZIA(10)----------------------\n\n");
        
        scanf("%d", &opc);

        switch (opc)
        {
        case 1://insercao de um elemento na fila
           if(cont < p->tamInfo){//verifica se ainda há espaco na fila
            printf("Insira o NOME:\n");
            fflush(stdin);
            __fpurge(stdin);
            scanf("%s", auxInfo.nome);
            printf("Insira a matricula:\n");
            scanf("%d", &(auxInfo.matricula));
            printf("Insira o ranking:\n");
            scanf("%d", &(auxInfo.ranking));
            printf("Insira o curso:\n");
            fflush(stdin);
            __fpurge(stdin);
            scanf("%s", auxInfo.curso);

        
            if (insereB(&auxInfo, p, compara, &nDeIteracoesParaInserir) == 0)
            {
                printf("Erro na insercao!\n\n");
            }
            else//tem espaco
            {
                cont++;
                printf("Sucesso na insecao!\n\n");
                
            }
        }else{
            printf("FILA CHEIA!!!\n");
        }
            break;

        case 2:
            if (remove_B(&auxInfo, p, 1) == 0)
            {
                printf("Erro na remocao!!\n\n");
            }
            else
            {
                cont--;
                printf("Removido:\n---------------------------------------\n|| Nome: %s\n|| Matricula: %d\n|| Ranking: %d\n|| Curso: %s\n---------------------------------------\n", auxInfo.nome, auxInfo.matricula, auxInfo.ranking, auxInfo.curso);
            }
            break;
        case 3:
            if (remove_B(&auxInfo, p, 2) == 0)
            {
                printf("Erro na remocao!!\n\n");
            }
            else
            {
                cont--;
                printf("Removido:\n---------------------------------------\n|| Nome: %s\n|| Matricula: %d\n|| Ranking: %d\n|| Curso: %s\n---------------------------------------\n", auxInfo.nome, auxInfo.matricula, auxInfo.ranking, auxInfo.curso);
            }
            break;
        case 4:
            if (buscaNaCaudaB(&auxInfo, p) == 0)
            {
                printf("Erro na busca!!\n\n");
            }
            else
            {
                printf("Elemento:\n---------------------------------------\n|| Nome: %s\n|| Matricula: %d\n|| Ranking: %d\n|| Curso: %s\n---------------------------------------\n", auxInfo.nome, auxInfo.matricula, auxInfo.ranking, auxInfo.curso);
            }

            break;
        case 5:
            if (buscaNaFrenteB(&auxInfo, p) == 0)
            {
                printf("Erro na busca!!\n\n");
            }
            else
            {
                printf("Elemento:\n---------------------------------------\n|| Nome: %s\n|| Matricula: %d\n|| Ranking: %d\n|| Curso: %s\n---------------------------------------\n", auxInfo.nome, auxInfo.matricula, auxInfo.ranking, auxInfo.curso);
            }
            break;

        case 6:
            tam = tamanhoDaFilaB(p);
            printf("Tamanho: %d\n", tam);
            break;

        case 7:
             aux = p->primeiro;
            printf("Fila normal:\n\n");
            for (int i = 0; i < tamanhoDaFilaB(p); i++)
            {
                printf("Elemento: %d\n|| Nome: %s\n|| Matricula: %d\n|| Ranking: %d\n|| Curso: %s\n", (i + 1), aux->dados.nome, aux->dados.matricula, aux->dados.ranking, aux->dados.curso);
                aux = aux->atras;
            }
           
            if (inverteB(p) == 0)
            {
                printf("Erro na inversao!!\n\n");
            }
            else
            {
                printf("Sucesso na inversao!!\n\n");
            }
            aux = p->primeiro;
            printf("Fila invertida:\n\n");
            for (int i = 0; i < tamanhoDaFilaB(p); i++)
            {
                printf("Elemento: %d\n|| Nome: %s\n|| Matricula: %d\n|| Ranking: %d\n|| Curso: %s\n", (i + 1), aux->dados.nome, aux->dados.matricula, aux->dados.ranking, aux->dados.curso);
                aux = aux->atras;
            }
            break;

        case 8:
            if (reiniciaB(p) == 0)
            {
                printf("Falha na reinicializacao!!\n\n");
            }
            else
            {
                printf("Sucesso na reinicializacao!!\n\n");
            }

            break;
        case 9:
            p = destroiB(p);
            if (p == NULL)
            {
                printf("Fila destruida!\n\n");
                opc = 0;
            }

            break;
        
        case 10:
            if(testaVaziaB(p) == 1){
                printf("FILA VAZIA!\n");
            }else{
                printf("FILA NAO VAZIA!\n");
            }
        break;

        default:
            printf("INSIRA UM NUMERO VALIDO!!\n\n");
            break;
        }

        if (opc == 0)
        {
            printf("SAINDO...\n\n");
        }
    }
}

int compara(info *a, info *b)
{
    if (a->ranking > b->ranking)
        return 1;
    else if (a->ranking < b->ranking)
        return -1;
    else
        return 0;
}

int main(void)
{
    descFDEcRef *ptr = NULL;
    int tamFila = 0;
    printf("Insira o tamanho da fila:\n");
    scanf("%d", &tamFila);
    ptr = criaB(tamFila);

    if (ptr == NULL)//verificacao durante a criacao
        printf("Erro fatal durante a criacao da fila!!\n\n");
    else
        menu(ptr);
    return 1;
}


