#include "LESE.c"
#include "math.h"
#include "string.h"

int main(void){
    info data[] = {{20, "Gustavo"}, {19, "pedro"}, {18, "Ana"}};
    struct descLESE *p = NULL;
    //testaVazia(p);
   // testaCheia(p);

    int tamData=sizeof(data)/sizeof(info);
    int tamanhoVetor = (int)tamData + 1;

    p = cria(tamanhoVetor, sizeof(info));//criando com tamanho 3
    //obtemNo(p);

    //testaVazia(p);
   // testaCheia(p);
    //info novoPrimeiro;
   // buscaOprimeiro(p, &novoPrimeiro);
   // info novoUltimo;
   // buscaOultimo(p, &novoUltimo);

    //inserindo elementos na lista
    for(int i = 0; i < tamData-1; i++){
        if(insereNovoPrimeiro(p, &data[i]) == NULL){
            printf("Erro na insercao!\n");
        }else{
            printf("inserido no inicio da lista: [%s , %d ]\n", data[i].nome, data[i].idade);
        }
    }

     info novoU;
    novoU.idade = 13;
    strcpy(novoU.nome, "enzo");
    insereNaPosLog(p, &novoU, 2);


/*
//funcionou
    info novoU;
    novoU.idade = 13;
    strcpy(novoU.nome, "enzo");
    insereNovoUltimo(p, &novoU);
*/ 

    //pritando a lista
    printf("\nlista printada: ");
    for(int i = 0; i < tamData; i++){
        printf("%d ", p->vet[i].dados.idade);
    }
    tamanhoDaLista(p);


    reinicia(p);
    destroi(p);

}