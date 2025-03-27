#include <stdio.h>

int main(){

    int tam;
    scanf("%i", &tam);

    int vet[tam];

    //LEITURA DO VETOR
    for(int i = 0; i < tam; i++){
        scanf("%i", &vet[i]);
    }

    int vetn[tam];

    for(int i = 0; i < tam; i++){
        vetn[i] = 1;
        for(int j = 0; j < tam; j++){
            if( i != j ){
                vetn[i] *= vet[j];
            }
        }
    }
    for(int i = 0; i< tam; i++){
        printf("%i ", vetn[i]);
    }

}