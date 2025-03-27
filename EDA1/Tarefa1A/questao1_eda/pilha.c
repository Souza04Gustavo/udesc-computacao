
#include "arq.h"
//se for compilar no terminal do linux deve se usar #include "arq.h"
//se for compilar vs code deve se usar #include "arq.c"
//caso contrario ele retornará problema de mais de uma chamada para as funcoes

int menu()
{
    int escolha;
    printf("\n--------Menu-------\n");
    printf("Sair do programa (0)\n");
    printf("Escolher tamanho do vetor (1)\n");
    printf("Inserir em alguma pilha (2)\n");
    printf("Remover o topo de uma piha (3)\n");
    printf("Consultar o topo de uma pilha (4)\n");
    printf("Numeros de elementos inseridos no vetor(5)\n");
    printf("Reiniciar uma pilha (6)\n");
    printf("Destruir multipilha (7)\n");
    printf("Consultar o vetor (8)\n");
    printf("---------------------\n");

    scanf("%d", &escolha);
    return escolha;
}

int main(void)
{
    MP *mps;
    int esc = 1;
    int criado = 0;
    int escPilha;

    while (esc != 0)
    {
        esc = menu();

        switch (esc)
        {
        case 0://encerra o programa
            printf("Saindo...\n\n\n");
            break;
        case 1://selecionar o tamanho do vetor principal
            int tam = 0;
            if (criado == 1)
            {
                printf("O vetor ja foi criado!!!\n");
                break;
            }
            printf("Insira o tamanho do vetor que deseja criar:\n");
            scanf("%d", &tam);
            mps = cria(tam);

            if(mps == NULL){
                printf("Não foi possivel criar o vetor!!!\n");
            }else{
                printf("Vetor criado com sucesso!\n");
                criado = 1;
            }

            break;
        case 2:
            info novo;
            printf("Deseja inserir em qual pilha (1 ou 2)?\n");
            int escP;
            scanf("%d", &escP);

            while (escP != 1 && escP != 2)//garante que o usuario insira um valor condizente
            {
                printf("Entrada invalida!\n\n");
                printf("Deseja inserir em qual pilha (1 ou 2)?\n");
                scanf("%d", &escP);
            }

            switch (escP)
            {
            case 1://insercao na pilha 1
                printf("Deseja inserir um inteiro (Digite 0) ou um caractere (Digite 1)?\n");
                int escT;
                scanf("%d", &escT);
                while (escT != 1 && escT != 0)//garante que o usuario insira um valor condizente
                {
                    printf("Insira um numero valido!\n\n");
                    scanf("%d", &escT);
                }
                switch (escT)
                {
                case 0:
                    printf("Insira o numero que deseja inserir:\n");
                    scanf("%d", &(novo.inteiro));//escaneou um inteiro
                    break;
                case 1:
                
                    fflush(stdin);
                    __fpurge(stdin);
                    printf("Insira o caractere que deseja inserir:\n");
                    scanf("%c", &(novo.letra));//escaneou um char
                    
                    
                    
                    break;
                }
                int verify = insereNaPilha(mps, 1, &novo);//insere de fato
                if (verify == 0)
                {
                    printf("FALHA AO INSERIR NA PILHA!\n");
                    break;
                }
                printf("SUCESSO AO INSERIR NA PILHA!\n");
                
                if (escT == 0)
                {
                    mps->vetAux[mps->topo1] = 0;//se o usuario inserir um numero inteiro guardaremos 0 em aux
                }
                else
                {
                    mps->vetAux[mps->topo1] = 1;//se for um char guardaremos 1
                }

                break;
            case 2://insercao na pilha 2
                printf("Deseja inserir um inteiro (Digite 0) ou um caractere (Digite 1)?\n");
                int escT_2;
                scanf("%d", &escT_2);
                while (escT_2 != 1 && escT_2 != 0)
                {
                    printf("Insira um numero valido!\n");
                    scanf("%d", &escT_2);
                }
                switch (escT_2)
                {
                case 0:
                    printf("Insira o numero que deseja inserir:\n");
                    scanf("%d", &(novo.inteiro));
                    break;
                case 1:
                    fflush(stdin);
                    __fpurge(stdin);
                    printf("Insira o caractere que deseja inserir:\n");
                    scanf("%c", &(novo.letra));
                    break;
                }
                int verify2 = insereNaPilha(mps, 2, &novo);
                if (verify2 == 0)
                {
                    printf("FALHA AO INSERIR NA PILHA!\n");
                    break;
                }
                printf("SUCESSO AO INSERIR NA PILHA!\n");

                if (escT_2 == 0)
                {
                    mps->vetAux[mps->topo2] = 0;//se o usuario inserir um numero inteiro guardaremos 0 em aux
                }
                else
                {
                    mps->vetAux[mps->topo2] = 1;//se for um char guardaremos 1
                }

                break;
            }

            break;
        case 3:
            info removido;
            printf("Qual pilha (1 ou 2)?\n");
            escPilha = -1;
            scanf("%d", &escPilha);

            if(criado != 1){//verificacao da multipilha
                printf("Multipilha inexistente!\n");
                break;
            }

            while (escPilha != 1 && escPilha != 2)//verificacao de valores validos
            {
                printf("Insira um valor valido!!\n\n");
                scanf("%d", &escPilha);
            }

            if (escPilha == 1)//pilha 1 escolhida
            {
                int indiceT = mps->topo1;
                if (removeDaPilha(mps, 1, &removido) == 0)//erro
                {
                    printf("Erro na remocao!!\n\n");
                    break;
                }

                printf("Removido com sucesso!\n");
                if (mps->vetAux[indiceT] == 0)
                {
                    printf("Item removido: %d\n", removido.inteiro);
                }
                if (mps->vetAux[indiceT] == 1)
                {
                    printf("Item removido: %c\n", removido.letra);
                }
                mps->vetAux[indiceT] = -1;
            }
            else//pilha 2 escolhida
            {
                int indiceT = mps->topo2;

                if (removeDaPilha(mps, 2, &removido) == 0)
                {
                    printf("Erro na remocao!!\n\n");
                    break;
                }

                printf("Removido com sucesso!\n\n");
                if (mps->vetAux[indiceT] == 0)
                {
                    printf("%d\n", removido.inteiro);
                }
                if (mps->vetAux[indiceT] == 1)
                {
                    printf("%c\n", removido.letra);
                }
                mps->vetAux[indiceT] = -1;
            }
            break;
        case 4:
            info consultado;
            escPilha = -1;
            printf("Consultar o topo da pilha 1 ou 2?\n");
            scanf("%d", &escPilha);
            while (escPilha != 1 && escPilha != 2)
            {
                printf("Escolha um numero valido!\n(Insira 1 ou 2)\n\n");
                scanf("%d", &escPilha);
            }

            if (consultaTopo(mps, escPilha, &consultado) == 0)
            {
                printf("Topo inexistente!\n");
                break;
            }

            if (escPilha == 1)//consulta pilha 1
            {
                printf("Consultando o topo da pilha 1:\n");
                if (mps->vetAux[mps->topo1] == 0)
                {
                    printf("Elemento: %d\n\n", consultado.inteiro);
                }
                else
                {
                    printf("Elemento: %c\n\n", consultado.letra);
                }
            }
            else//consulta pilha 2
            {
                printf("Consultando o topo da pilha 2:\n");
                if (mps->vetAux[mps->topo2] == 0)
                {
                    printf("Elemento: %d\n\n", consultado.inteiro);
                }
                else
                {
                    printf("Elemento: %c\n\n", consultado.letra);
                }
            }
            break;
        case 5:
            int a = numElementosInseridos(mps);//retornara o numero de elementos
            if (a < 0)
            {
                printf("\nFalha na contagem!!\n\n");
                break;
            }
            printf("\nNumero de elementos inseridos no vetor: %d\n\n", a);
            break;
        case 6:
            escPilha = -1;
            printf("\nQual pilha deseja reinicializar (1 ou 2)?\n");
            scanf("%d", &escPilha);
            while (escPilha != 1 && escPilha != 2)//verificacao da entrada
            {
                printf("Escolha um numero valido! (Insira 1 ou 2)\n");
                scanf("%d", &escPilha);
            }
            if (reinicializacaoPilha(mps, escPilha) == 0)
            {
                printf("FRACASSO NA REINICIALIZAÇÃO!\n\n");
                break;
            }
            printf("SUCESSO NA REINICIALIZAÇÃO!\n\n");
            break;

        case 7:

            if (mps == NULL) {
                printf("\nMultipilha não foi criada ainda!\n");
                break;
            }

            printf("ATENCAO! OS DADOS INSERIDOS SERÃO PERDIDOS!\n");
            printf("Deseja prosseguir? (0 = NÃO) e (1 = SIM)\n");
            int escolha;
            scanf("%d", &escolha);
            while (escolha != 0 && escolha != 1)
            {
                printf("Digite um valor valido!!!\n\n");
                scanf("%d", &escolha);
            }
            if (escolha == 1)
            {
                mps = destroi(mps);//libera memoria alocada
                mps = NULL;//destroi a estrutura
                criado = 0;
                printf("\nMultipilha destruida com sucesso!\n");
            }else{
                printf("\nCancelando operacao...\n");
            }
            break;

        case 8:

           if (criado == 1) {
        // para testes
        printf("\nPrintando o vetor atualizado:\n");
        for (int i = 0; i < mps->tamInfo; i++) {
            if (mps->vetAux[i] == 0) {
                printf("%d ", mps->vet[i].dados.inteiro);
            } else if (mps->vetAux[i] == 1) {
                printf("%c ", mps->vet[i].dados.letra);
            } else{
                printf("_ ");
            }
        }
        printf("\n");
    } else {
        printf("Multipilha não foi criada ainda!\n");
    }

        break;

        default:
        printf("Insira um numero valido!!\n\n");
            break;
        
        }
    }
    
   
  //desalocando a memoria para fechamento do codigo
    if (mps != NULL)
    {
        free(mps->vet);
        free(mps->vetAux);
        free(mps);
    }
   	
   
    return 0;
}

