#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <limits.h>

#define BLACK "\033[30m"
#define RED "\033[31m"
#define GREEN "\033[32m"
#define YELLOW "\033[33m"
#define BLUE "\033[34m"
#define MAGENTA "\033[35m"
#define CYAN "\033[36m"
#define GRAY "\033[37m"
#define RESET "\033[0m"

#define NUM_VERTICES 150
#define K 2 // Número de clusters

int matAd[NUM_VERTICES][NUM_VERTICES];
int clusters[NUM_VERTICES]; // Cluster de cada vértice
int centroids[K];           // Índices dos centroides

// variaveis de controle
float limiar = 0.15;
int chute_centro1 = 1;
int chute_centro2 = 147;

int similaridade(int vertice1, int vertice2)
{
    int similar = 0;
    for (int i = 0; i < NUM_VERTICES; i++)
    {
        if (matAd[vertice1][i] == 1 && matAd[vertice2][i] == 1)
        {
            similar++;
        }
    }
    return similar;
}

int centro_mais_proximo(int vertice)
{
    int max_similaridade = INT_MIN; // Definimos o valor mínimo possível para garantir substituição
    int cluster = -1;               // Definimos um valor inválido para que detecte erro caso não seja atualizado

    for (int i = 0; i < K; i++)
    {
        int sim = similaridade(vertice, centroids[i]);
        if (sim > max_similaridade)
        {
            max_similaridade = sim;
            cluster = i;
        }
    }

    // Verificação adicional para casos onde nenhum cluster foi encontrado
    if (cluster == -1)
    {
        printf("Erro: Nenhuma similaridade encontrada para o vértice %d.\n", vertice);
        cluster = 0; // Retorne um cluster padrão (pode definir diferente se necessário)
    }

    return cluster;
}

void recalcular_centroides()
{
    for (int i = 0; i < K; i++)
    {
        int max_similaridade = -1;
        int novo_centro = centroids[i];

        for (int v = 0; v < NUM_VERTICES; v++)
        {
            if (clusters[v] == i)
            {
                int total_similaridade = 0;
                for (int w = 0; w < NUM_VERTICES; w++)
                {
                    if (clusters[w] == i)
                    {
                        total_similaridade += similaridade(v, w);
                    }
                }
                if (total_similaridade > max_similaridade)
                {
                    max_similaridade = total_similaridade;
                    novo_centro = v;
                }
            }
        }
        centroids[i] = novo_centro;
    }
}

float euclidiana(float mati1, float mati2, float mati3, float mati4, float matj1, float matj2, float matj3, float matj4)
{
    float petL = (mati1 - matj1);
    float petA = (mati2 - matj2);
    float sepL = (mati3 - matj3);
    float sepA = (mati4 - matj4);
    petL = pow(petL, 2);
    petA = pow(petA, 2);
    sepL = pow(sepL, 2);
    sepA = pow(sepA, 2);
    float resultado = sqrt(petL + petA + sepL + sepA);
    return resultado;
}

int main()
{
    // pegando dados do csv e salvando na matriz
    FILE *file;
    char filename[] = "IrisDataset.csv"; // Nome do arquivo CSV
    float matrix[150][4];                // Matriz para armazenar os dados
    int row = 0, col = 0;
    char buffer[1024];

    // Abrir o arquivo CSV
    file = fopen(filename, "r");
    if (!file)
    {
        printf("Erro ao abrir o arquivo %s\n", filename);
        return 1;
    }

    // Ignorar a primeira linha
    fgets(buffer, sizeof(buffer), file);

    // Ler o arquivo linha por linha
    while (fgets(buffer, sizeof(buffer), file))
    {
        col = 0;
        char *value = strtok(buffer, ",");

        // Ignorar a primeira coluna
        value = strtok(NULL, ",");
        while (value != NULL)
        {
            matrix[row][col] = atof(value); // Adiciona o valor à matriz
            col++;
            value = strtok(NULL, ",");
        }
        row++;
    }

    fclose(file);

    // Exibir a matriz
    printf("Dados importados:\n");
    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < col; j++)
        {
            printf("%.2f ", matrix[i][j]);
        }
        printf("\n");
    }

    // criando a matriz de euclidiana
    float matrixEuc[row][row];
    float maxDE = 0, minDE = INFINITY;
    int maxDE_i, maxDE_j, minDE_i, minDE_j;

    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < row; j++)
        {
            if (i == j)
            {
                matrixEuc[i][j] = 0;
            }
            else
            {
                matrixEuc[i][j] = euclidiana(matrix[i][0], matrix[i][1], matrix[i][2], matrix[i][3], matrix[j][0], matrix[j][1], matrix[j][2], matrix[j][3]);

                // encontrar maior e menor DE
                if (matrixEuc[i][j] > maxDE)
                {
                    maxDE = matrixEuc[i][j];
                    maxDE_i = i;
                    maxDE_j = j;
                }
                if (matrixEuc[i][j] < minDE)
                {
                    minDE = matrixEuc[i][j];
                    minDE_i = i;
                    minDE_j = j;
                }
            }
        }
    }

    // Printar a matriz com dados euclidianos;
    printf("\nMATRIZ EUCLIDIANA\n");
    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < row; j++)
        {
            printf("%.2f ", matrixEuc[i][j]);
        }
        printf("\n");
    }

    // Normalizando a matriz euclidiana
    float matrixNorm[row][row];
    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < row; j++)
        {
            if (i == j)
            {
                matrixNorm[i][j] = 0; // A diagonal eh zero
            }
            else
            {
                // Normalizando os valores
                matrixNorm[i][j] = (matrixEuc[i][j] - minDE) / (maxDE - minDE);
            }
        }
    }

    // resetar as variaveis de max e min para a matriz normalizada
    float maxDEN = 0, minDEN = 1;
    int maxDEN_i = 0, maxDEN_j = 0, minDEN_i = 0, minDEN_j = 0;

    printf("\nMATRIZ EUCLIDIANA NORMALIZADA\n");
    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < row; j++)
        {
            // apenas considere valores fora da diagonal para min e max
            if (i != j)
            {
                if (matrixNorm[i][j] < minDEN)
                {
                    minDEN = matrixNorm[i][j];
                    minDEN_i = i;
                    minDEN_j = j;
                }
                if (matrixNorm[i][j] > maxDEN)
                {
                    maxDEN = matrixNorm[i][j];
                    maxDEN_i = i;
                    maxDEN_j = j;
                }
            }
            printf("%.2f ", matrixNorm[i][j]);
        }
        printf("\n");
    }

    // Matriz de adjascencia
    // int matAd[row][row];

    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < row; j++)
        {
            if ((i != j) && (matrixNorm[i][j] <= limiar))
            {
                matAd[i][j] = 1;
            }
            else
            {
                matAd[i][j] = 0;
            }
        }
    }

    printf("\nMATRIZ DE ADJASCENCIA\n");
    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < row; j++)
        {
            printf("%i ", matAd[i][j]);
        }
        printf("\n");
    }

    // salvar a matriz em um arquivo csv
    FILE *outputFile;
    outputFile = fopen("grafo_final.csv", "w");
    if (!outputFile)
    {
        printf("Erro ao abrir o arquivo para escrita.\n");
        return 1;
    }

    // escrevendo cabecalho
    fprintf(outputFile, "Total de Vértices: %d\n", row);
    fprintf(outputFile, "Maior DE: %.2f, Par: (%d, %d)\n", maxDE, maxDE_i, maxDE_j);
    fprintf(outputFile, "Menor DE: %.2f, Par: (%d, %d)\n", minDE, minDE_i, minDE_j);
    fprintf(outputFile, "Maior DEN: %.2f, Par: (%d, %d)\n", maxDEN, maxDEN_i, maxDEN_j);
    fprintf(outputFile, "Menor DEN: %.2f, Par: (%d, %d)\n", minDEN, minDEN_i, minDEN_j);

    // Adicionar uma linha em branco
    fprintf(outputFile, "\n");

    // Adicionar a matriz de adjacência
    fprintf(outputFile, "Matriz de Adjacência:\n");
    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < row; j++)
        {
            fprintf(outputFile, "%d,", matAd[i][j]);
        }
        fprintf(outputFile, "\n");
    }

    fclose(outputFile);

    // segmento extra para visualizacao do grafo em 3d usando python
    FILE *arquivo = fopen("grafo_adjascencia.txt", "w");

    if (arquivo == NULL)
    {
        printf("Erro ao criar o arquivo.\n");
        return 1;
    }

    for (int i = 0; i < row; i++)
    {
        for (int j = (i + 1); j < row; j++)
        {
            if (matAd[i][j] == 1)
            {
                fprintf(arquivo, "%i, %i\n", i, j);
            }
        }
    }

    fclose(arquivo);

    printf("Arquivo txt criado e dados gravados com sucesso!\n");

    centroids[0] = chute_centro1;
    centroids[1] = chute_centro2;

    int mudou = 1;
    while (mudou)
    {
        mudou = 0;

        // Atribuir cada vértice ao centro mais próximo
        for (int v = 0; v < NUM_VERTICES; v++)
        {
            int novo_cluster = centro_mais_proximo(v);
            if (novo_cluster != clusters[v])
            {
                clusters[v] = novo_cluster;
                mudou = 1;
            }
        }

        // Recalcular os centros
        recalcular_centroides();
    }
    int centro1, centro2;

    double medias[4] = {0, 0, 0, 0};
    int contador = 0;
    for (int i = 0; i < NUM_VERTICES; i++)
    {
        if (clusters[i] == 0)
        {
            for (int j = 0; j < 4; j++)
            {
                medias[j] += matrix[i][j];
            }
            contador++;
        }
    }
    for (int i = 0; i < 4; i++)
    {
        medias[i] /= contador;
    }
    double menorSet[4] = {100, 100, 100, 100};

    for (int i = 0; i < contador; i++)
    {
        if (fabs(medias[0] - matrix[i][0]) <= menorSet[0] && fabs(medias[1] - matrix[i][1]) <= menorSet[1] && fabs(medias[2] - matrix[i][2]) <= menorSet[2] && fabs(medias[3] - matrix[i][3]) <= menorSet[3])
        {
            for (int j = 0; j < 4; j++)
            {
                menorSet[j] = fabs(medias[j] - matrix[i][j]);
            }
            centro1 = i;
        }
    }
    // centro não setosas
    double medias2[4] = {0, 0, 0, 0};
    int contador2 = 0;
    for (int i = 0; i < NUM_VERTICES; i++)
    {
        if (clusters[i] == 1)
        {
            for (int j = 0; j < 4; j++)
            {
                medias2[j] += matrix[i][j];
            }
            contador2++;
        }
    }
    for (int i = 0; i < 4; i++)
    {
        medias2[i] /= contador2;
    }
    double menorNaoSet[4] = {100, 100, 100, 100};

    for (int i = contador; i < NUM_VERTICES; i++)
    {
        if (fabs(medias2[0] - matrix[i][0]) <= menorNaoSet[0] && fabs(medias2[1] - matrix[i][1]) <= menorNaoSet[1] && fabs(medias2[2] - matrix[i][2]) <= menorNaoSet[2] && fabs(medias2[3] - matrix[i][3]) <= menorNaoSet[3])
        {
            for (int j = 0; j < 4; j++)
            {
                menorNaoSet[j] = fabs(medias2[j] - matrix[i][j]);
            }
            centro2 = i;
        }
    }

    // Imprimir os clusters
    printf("Cluster 1:\n");
    for (int i = 0; i < NUM_VERTICES; i++)
    {
        if (clusters[i] == 0)
        {
            // printf(GREEN);
            printf(GREEN "Vertice %d" RESET "\n", i); // Usando RESET corretamente
                                                      // printf(RESET);
        }
    }

    printf("Cluster 2:\n");
    for (int i = 0; i < NUM_VERTICES; i++)
    {
        if (clusters[i] == 1)
        {
            printf(RED "Vertice %d" RESET "\n", i);
        }
    }

    printf("\nMATRIZ DE ADJASCENCIA\n");
    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < row; j++)
        {
            if (clusters[i] == 0 && clusters[j] == 0)
            {
                printf(GREEN "%i " RESET, matAd[i][j]);
            }
            else if (clusters[i] == 1 && clusters[j] == 1)
            {
                printf(RED "%i " RESET, matAd[i][j]);
            }
            else
            {
                printf("%i ", matAd[i][j]);
            }
        }
        printf("\n");
    }

    FILE *grafo_setosa = fopen("grafo_setosa.txt", "w");

    if (arquivo == NULL)
    {
        printf("Erro ao criar o arquivo.\n");
        return 1;
    }

    for (int i = 0; i < row; i++)
    {
        for (int j = (i + 1); j < row; j++)
        {
            if (matAd[i][j] == 1)
            {
                if (clusters[i] == 0 && clusters[j] == 0)
                {
                    fprintf(grafo_setosa, "%i, %i\n", i, j);
                }
            }
        }
    }

    fclose(arquivo);

    FILE *grafo_Nsetosa = fopen("grafo_Nsetosa.txt", "w");

    if (arquivo == NULL)
    {
        printf("Erro ao criar o arquivo.\n");
        return 1;
    }

    for (int i = 0; i < row; i++)
    {
        for (int j = (i + 1); j < row; j++)
        {
            if (matAd[i][j] == 1)
            {
                if (clusters[i] == 1 && clusters[j] == 1)
                {
                    fprintf(grafo_Nsetosa, "%i, %i\n", i, j);
                }
            }
        }
    }

    fclose(arquivo);
    printf("\nCentro1_k final: %i  Centro2_k final: %i \nCentro1_media final: %i  Centro2_media final: %i\n", centroids[0], centroids[1], centro1, centro2);
    printf("\n%f %f %f %f\n", medias[0], medias[1], medias[2], medias[3]);
    printf("\n%f %f %f %f\n", matrix[centro1][0], matrix[centro1][1], matrix[centro1][2], matrix[centro1][3]);
    printf("\n%f %f %f %f\n", matrix[centroids[0]][0], matrix[centroids[0]][1], matrix[centroids[0]][2], matrix[centroids[0]][3]);
    printf("\n%f %f %f %f\n", menorSet[0], menorSet[1], menorSet[2], menorSet[3]);

    printf("\n\n\n%f %f %f %f\n", medias2[0], medias2[1], medias2[2], medias2[3]);
    printf("\n%f %f %f %f\n", matrix[centro2][0], matrix[centro2][1], matrix[centro2][2], matrix[centro2][3]);
    printf("\n%f %f %f %f\n", matrix[centroids[1]][0], matrix[centroids[1]][1], matrix[centroids[1]][2], matrix[centroids[1]][3]);
    printf("\n%f %f %f %f\n", menorNaoSet[0], menorNaoSet[1], menorNaoSet[2], menorNaoSet[3]);

    int naoSet = 0;
    for (int i = 0; i < NUM_VERTICES; i++)
    {
        if (matAd[123][i] == 1)
        {
            naoSet++;
        }
    }
    printf("\n\n%i\n", naoSet);

    return 0;
}