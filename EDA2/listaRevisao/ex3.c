#include <stdio.h>

int main(){


    int tam;
    scanf("%i", &tam);

    int vet[tam];

    //LEITURA DO VETOR
    for(int i = 0; i < tam; i++){
        scanf("%i", &vet[i]);
    }

    int aux;
    for(int i = 0; i < tam; i++){
        for(int j = 0; j < tam; j++){
            if( vet[i] < vet[j]){
                aux = vet[i];
                vet[i] = vet[j];
                vet[j] = aux;
            }
        }
    }

    //pritando a ordenacao
    for(int i = 0; i< tam; i++){
        printf("%i, ", vet[i]);
    }
    
    int cont  = 0;
    for(int i = 0; i<tam; i++){
        if(vet[i] > cont+1){
            printf("\n%i\n", cont+1);
            cont = -1;
            break;
        }
        else if(vet[i]== cont+1){
            cont++;
        }
        else{

        }
    }
    if(cont != -1){
        printf("\n%i\n", cont+1);
    }
}