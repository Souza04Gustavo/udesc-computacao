#include <stdio.h>

int main(){

    int tam;
    scanf("%i", &tam);

    int vet[tam];

    //LEITURA DO VETOR
    for(int i = 0; i < tam; i++){
        scanf("%i", &vet[i]);
    }

    int maior = vet[0];
    int ind;

    for(int i = 0; i < tam; i++){
        if(maior < vet[i]){
            maior = vet[i];
            ind = i;
        }
    }
    

    if( (ind % 2) == 0){  //par 
            
        for(int i = 0; i < tam; i++){
            
        }


    }else{  //impar

    }

}