#include <stdio.h>
#include <stdlib.h>
#include "ABB.c"


int main(){

    ABB *p = NULL;
    info vet[] = {{300,30,"Pedro"},{200,32,"Paulo"},{400,35,"Judas"},{100,31,"Manuel"},{250,33,"Lucas"},{350,32,"Andre"},{450,34,"Thiago"}, {330,33,"Lucasa"}};

    p = cria(sizeof(info));
    int tamVet = 8;

    for(int i = 0; i < tamVet; i++){
            if(insereABB(p, &vet[i]) == 1) {	
                printf("%i) inserido: %s, idade: %i anos, matricula: %i \n",i+1,vet[i].nome,vet[i].idade,vet[i].identificador);
            }
            else { 
                puts(">>> Fracasso na inser��o");
            }

    }


    printf("PERCORRENDO EM PREORDEM:\n");
    percorreEmPosOrdem(p->raiz);
    printf("\n");

    printf("Numero de folhas: %d\n", calcNumFolhas(p->raiz));

    
    info remove;
    if(removeABB(p, 200, &remove) == 1){
        
        printf(">>> Removeu: %i\n", remove.identificador);
    }else{
        printf("nao efetuamos a remocao!\n");
    }


      for(int i = 0; i < tamVet; i++){	
                printf("%i) inserido: %s, idade: %i anos, matricula: %i \n",i+1,vet[i].nome,vet[i].idade,vet[i].identificador);
         
    }

    


    destroi(p);

}