#include <stdio.h>

int main()
{

    int tam = 5;
    int vet[] = {10, 5, 2, 7, 8, 7 };
    int n;

    printf("Insira n: ");
    scanf("%d", &n);

    int vet_aux[n];
    int maior;

    for (int i = 0; i < tam; i++)
    {
        printf("\n");

            if ((i - 1 + n) > tam)//para n pegar lixo
            {
                break;
            }


        for (int j = 0; j < n; j++) // vetor que sempre pega vet[i] e vet[i+1]
        {
            vet_aux[j] = vet[i];
            i++;
            printf("%d ", vet_aux[j]);
        }

        maior = vet_aux[0];
        for(int k = 0; k < n; k++){
            if(vet_aux[k] > maior){
                maior = vet_aux[k];
            }   
        }

        printf("  elemento maior do subvetor: %d\n", maior);

        i = i - n; // restaura o valor de i
    }
}
