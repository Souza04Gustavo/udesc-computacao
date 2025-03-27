#include "lista.c"
#include "math.h"

int main(){

    int tam = 1;
    int comprimento;
    //criacao da fila
    struct descLSE *p = NULL;
    p = cria(tam);
	
     if (p != NULL) {

        struct no *aux;
        aux = p->inicio;
        if(p->inicio == NULL){
            printf("nada ainda\n");
        }else{
        while(aux->prox != NULL){
            printf("%d", aux->dado);
            aux = aux->prox;
        }

        }

    
        printf("Lista criada com tamanho total: %d\n", p->tamTotal);

        info novo;
        novo.numero = 12;

        info novoU;
        novoU.numero = 21;
        
        info novoLog;
        novoLog.numero = 5;
        
        info novoBusca;

        insereNovoPrimeiro(&novo, p);
        insereNovoPrimeiro(&novo, p);
        insereNovoUltimo(&novoU, p);
        insereNaPoslog(2, &novoLog, p);

        buscaNaPosLog(8, &novoBusca, p);
        printf("Mostrando o elemento achado na lista: %d\n", novoBusca.numero);

        comprimento = tamDaLista(p);
        printf("Tamanho atualizado: %d\n", comprimento);
        
        printf("Mostrando a lista: ");
        struct no *print = p->inicio;
        for(int i = 0; i < (p->tamTotal)-1; i++){
            printf("%d ", print->dado);
            print = print->prox;
        }
        printf("\n");

        //testando remocao
        info novoRem;
comprimento = tamDaLista(p);
        printf("Tamanho atualizado: %d\n", comprimento);

        removeDaPoslog(-1, &novoRem, p);
        printf("Mostrando o elemento removido na lista: %d\n", novoRem.numero);

        printf("Mostrando a lista: ");
        struct no *print2 = p->inicio;
        for(int i = 0; i < (p->tamTotal)-1; i++){
            printf("%d ", print2->dado);
            print2 = print2->prox;
        }
        printf("\n");

       inverte(p);

        
        printf("\nMostrando a lista invertida: ");
        struct no *print3 = p->inicio;
        for(int i = 0; i < (p->tamTotal)-1; i++){
            printf("%d ", print3->dado);
            print3 = print3->prox;
        }
        
        

     printf("\n");


        reinicia(p);
        destroi(p);
        return 0;

    } else {
        printf("Erro ao criar a lista.\n");
    }
	



}


