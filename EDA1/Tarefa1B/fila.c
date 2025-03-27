#include "arq.h"

int main(int argc, char const *argv[])
{
    srand((unsigned)time(NULL));
    FILE *file;
    char const *filename;

    // arquivo ta ok
    if (argc != 2)
    {
        printf("Uso: %s arquivo.csv\n", argv[0]);
        return 1;
    }

    // nome do csv
    filename = argv[1];

    // abertura do arquivo para leitura
    file = fopen(filename, "r");

    // verificacao se o arquivo foi aberto corretamente
    if (file == NULL)
    {
        printf("Erro ao abrir o arquivo.\n");
        return 1;
    }

    char aux[50];
    aux[0] = ' ';

    //declarando os descritores das duas filas
    descFDEsRef *filaSemRefMovel;
    descFDEcRef *filaComRefMovel;
    
    int tamDesejado = 9000; //variavel que controla os testes

    //sOuN eh um vetor gerado randomicamente que contem os indices 
    int sOuN[tamDesejado];
    int valoresDeInsercao[tamDesejado];

     //criacao das filas
    filaSemRefMovel = criaA(tamDesejado);
    filaComRefMovel = criaB(tamDesejado);

    int qnt = 0, indice = 0;
    int qntIteracoesA = 0, qntIteracoesB = 0;

    //criando os valores aleatorios
    for (int i = 0; i < tamDesejado; i++)
    {
        sOuN[i] = 1 + (rand() % 9999);
        int correcao = sOuN[i];
        int flag = 0;
        while (flag == 0)
        {
            flag = 1;
           for (int j = 0; j <= i; j++)
        {

            if (correcao == sOuN[j] && i != j)
            {
                sOuN[i] = 1 + (rand() % 9999);
                correcao = sOuN[i];
                flag = 0;
            }

        }  
        }
    }    

    //ordenacao dos numeros gerados
    for (int i = 0; i < tamDesejado; i++)
    {
        for (int j = 0; j < tamDesejado; j++)
        {
            if (sOuN[i] < sOuN[j])
            {

                int c = sOuN[j];
                sOuN[j] = sOuN[i];
                sOuN[i] = c;
            }
        }
    }

    /*
    printf("Vetor com os indices que serão inseridos nas filas:\n");
    for(int i = 0; i< tamDesejado; i++){
        printf("%d ", sOuN[i]);
    }
    */

    //loop para ler o arquivo e inserir os dados na fila
    while (aux != NULL && qnt < tamDesejado && !(feof(file)))
    {

        info inserir;

        //inserindo os dados do csv de cada usario para a a struct info
        fscanf(file, "\n%[^,]s", aux);
        strcpy(inserir.nome, aux);
        fscanf(file, ",%[^,]s", aux);
        int matricula = atoi(aux);//convertendo a string para inteiro
        inserir.matricula = matricula;
        fscanf(file, ",%[^,]s", aux);
        int rank = atoi(aux);
        inserir.ranking = rank;
        fscanf(file, ",%s", aux);
        strcpy(inserir.curso, aux);
        
        //verifica se o indice atual condiz com o indice gerado aleatoriamente
        if (sOuN[qnt] == indice)
        {
            insereA(&inserir, filaSemRefMovel, compara, &qntIteracoesA);//insere na fila sem referencial movel
            insereB(&inserir, filaComRefMovel, compara, &qntIteracoesB);//insere na fila com referencial movel

            printf("\nInsercao: %d", inserir.ranking);
            printf("\nIteracoes A: %d\n", qntIteracoesA);
            printf("Iteracoes B: %d\n\n", qntIteracoesB);
            valoresDeInsercao[qnt] = inserir.ranking;
            qnt++;
        }
        indice++;
    }

    printf("Valores de ranking para inserir na fila:\n");
    for (int i = 1; i <= tamDesejado; i++)
    {
        printf("%d, ", valoresDeInsercao[i-1]);
        if (i % 30 == 0)
        {
            printf("\n");
        }
        
    }

    printf("\n\nTotal de iteracoes A: %d\n", qntIteracoesA);
    printf("Total de iteracoes B: %d\n", qntIteracoesB);

    fclose(file);
    return 0;
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