#include "lde.c"
#include "math.h"
#include <string.h>
int main(void){
        
        info data[] = {{20, "Gustavo"}, {18, "Ana"}, {21, "Pedro"}};

        struct descLDE *p = NULL;
        p = cria(sizeof(info));

        int tamVetDados = sizeof(data)/sizeof(info);

        printf("--- Testando add no inicio ---\n");
        for(int i = 0; i < tamVetDados;i++){
            insereNovoPrimeiro(p, &data[i]);
        }
        
        info novaI;
        novaI.idade = 13;
        strcpy(novaI.nome, "Enzo");

        
        if(insereNaPosLog(2, &novaI, p) != 0){
        tamVetDados++;
        }

        printf("Mostrando a lista: ");
        struct no *print2 = p->inicio;
        for(int i = 0; i < tamVetDados; i++){
            printf("%d ", print2->dados.idade);
            print2 = print2->prox;
        }

        info novaT;
        if(removeDaPoslog(4, &novaT, p) != 0){
            tamVetDados--;
        }

         printf("\nMostrando a lista: ");
        struct no *print3 = p->inicio;
        for(int i = 0; i < tamVetDados; i++){
            printf("%d ", print3->dados.idade);
            print3 = print3->prox;
        }
        
        printf("\nTamanho da lista: %d\n", tamanhoDaLista(p));
        reinicia(p);

}
