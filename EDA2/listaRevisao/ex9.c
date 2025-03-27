#include <stdio.h>
#include <string.h>

int main(){
    char palavra[] = "ABCDppppp";
    int tam = strlen(palavra);
    int cont = 0;

    char analise = palavra[0];
    for(int i = 0; i <= tam; i++){
    
        if(analise == palavra[i]){
            cont++;
        }else{
            printf("%d%c", cont, analise);
            cont = 1;
            analise = palavra[i];
        }    
    }
    printf("\n");

    
}