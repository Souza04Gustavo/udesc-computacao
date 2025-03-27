#include "arq_priv.h"

struct descLESE *cria(int tamVetor, int tamInfo){

    struct descLESE *desc = (struct descLESE*)malloc(sizeof(struct descLESE));
    if(desc != NULL){//criada de boas
        if( (desc->vet = (struct no*)malloc(tamVetor*sizeof(struct no))) != NULL){//CRIOU O VETOR PERFEITAMENTE
            desc->listaDados = -1;
            desc->listaDispo = 0;
            desc->tamInfo = tamInfo;
            desc->tamdalistadedados = 0;

            int i;
            for(i=0; i < tamVetor-1;i++){
                desc->vet[i].prox = i+1;
            }
            desc->vet[i].prox = -1;//o ultimo aponta pra -1 pois n tem relacao com ninguem
            printf("criado com sucesso!\n");
            return desc;
        }else{
            free(desc);
            return NULL;
        }
        

    }else{
        printf("FALHA NA CRIACAO!\n");
        return NULL;
    }
        return NULL;
}

struct descLESE * destroi(struct descLESE *p){
    free(p->vet);
    free(p);
    printf("\nlista destruida com sucesso!\n");
    return NULL;

}

int testaVazia(struct descLESE *p){
    if(p == NULL){
        printf("Lista nao criada!\n");
        return 0;
    }else{
       if(p->listaDados == -1){
            printf("lista vazia!!\n");
            return 1;
       }else{
        printf("Lista nao vazia!\n");
        return 0;
       }
    }
    return 0;

}

int testaCheia(struct descLESE *p){

    if(p == NULL){
        printf("Lista nao criada!\n");
        return 0;
    }

    if(p->listaDispo == -1){
        printf("lista cheia!\n");
        return 1;
    }else{
        printf("lista nao cheia!\n");
        return 0;
    }

}

int buscaOprimeiro(struct descLESE *p, info *pReg){
    if(p->listaDados != -1){
        printf("Primeiro elemento achado!\n");
        memcpy( pReg, &(p->vet[p->listaDados].dados), sizeof(info));
        return 1;
    }else{
        printf("Nada inserido na lista!\n");
        return 0;
    }
}



int buscaOultimo(struct descLESE *p, info *pReg){
    if(p->listaDados == -1){
        printf("Lista não criada!\n");
        return 0;
    }

    int aux = p->listaDados;//regista a posicao do primeiro elemento no vetor
    while(p->vet[aux].prox != -1){
         aux = p->vet[aux].prox;
    }
    
    //sai do while pq achou o ultimo ja que ele retorna -1
    memcpy(pReg, &(p->vet[aux].dados), sizeof(info));
    printf("encontrado o ultimo com sucesso!\n");
    return 1;

}

static int obtemNo(struct descLESE *p)
{ 
    int posDisponivel;
    posDisponivel = p->listaDispo; 
    printf("Posicao disponivel para insercao: %d\n", posDisponivel);
    if ( posDisponivel != -1){ 
        p->listaDispo = p->vet[p->listaDispo].prox;//atualiza o indice para o prox indice disponivel
    }
    
    return posDisponivel;
}



int insereNovoPrimeiro(struct descLESE *p,info *pReg){
    if(p != NULL ){
        int aux = obtemNo(p);
        if(aux != -1){//a lista estiver disponivel para insercao
        memcpy(&(p->vet[aux].dados), pReg,sizeof(info));
        p->vet[aux].prox = p->listaDados;
        p->listaDados = aux;
        p->tamdalistadedados++;
        printf("Sucesso na insercao!\n");
        return 1;
        }
    }else{
        printf("lista nao criada\n");
        return 0;
    }
}

int insereNovoUltimo(struct descLESE *p, info *pReg){
    if(p!= NULL){
        
        int vaga = obtemNo(p);
        int aux;

        if(vaga != -1){
            p->vet[vaga].prox = -1;
            memcpy(&(p->vet[vaga].dados), pReg, p->tamInfo);
            aux = p->listaDados;
            if(aux == -1){
                p->listaDados = vaga;//lista vazia
            }else{
                //iniciamos a busca para o penultimo elemento para fazer com que ele aponte para o novo ultimo
                while(p->vet[aux].prox != -1){
                    aux = p->vet[aux].prox;
                }
                //achou o ultimo
                p->vet[aux].prox = vaga;
                p->tamdalistadedados++;
                printf("Sucesso na insercao no final!\n");
                return 1;

            }


        }


    }else{
        return 0;
    }
}

int tamanhoDaLista(struct descLESE *p){
    printf("\nTamanho da lista: %d", p->tamdalistadedados);
    return (p->tamdalistadedados);
}


int insereNaPosLog(struct descLESE *p,info *pReg, int posLog){

    if(p->listaDispo == -1){
        printf("lista cheia!\n");
        return 0;
    }else{
        if(posLog < 0 || posLog > p->tamdalistadedados){
            printf("Posicao invalida!\n");
            return 0;
        }else{
            int vaga = obtemNo(p);
            int aux;
            //deseja inserir na primeira posicao
            if(posLog == 1){
               aux=  p->listaDados;
               p->vet[vaga].prox = aux;
               p->listaDados = vaga;
               memcpy(&(p->vet[vaga].dados), pReg, sizeof(info));
               printf("Inserido na primeira posicao com sucesso!\n");
               return 1;
            }else{
                //quer inserir em uma pos que nao é a primeira
                
                int aux1 = p->listaDados;
                int aux2 = p->vet[aux1].prox;
                int cont = 2; // contador das posicoes indexadas por aux2 
            while(aux2 != -1 && p->vet[aux2].prox != -1 && cont < posLog) 
            { 	
                aux1 = aux2;
                aux2 = p->vet[aux2].prox;
                cont++;
            }
            if (aux2 > -1 && cont == posLog) 
	    { 	
                p->vet[aux1].prox = vaga;
                p->vet[vaga].prox = aux2;
		p->tamdalistadedados += 1;
        memcpy(&(p->vet[vaga].dados), pReg, sizeof(info));

                printf("SUCESSO\n");
                return 1;
            }

            return 0;


            }




        }



    }



}

int reinicia(struct descLESE *p){
    if(p != NULL){
        int aux;

        while(p->listaDados != -1){
            aux = p->vet[p->listaDados].prox;
            devolveNo(p, p->listaDados);
            p->listaDados = aux; 
        }

        //devolveu todos os nos disponiveis
        p->tamdalistadedados = 0;
        printf("\nLista reinicializada com sucesso!\n");
        return 1;
    }else{
        return 0;
    }


}

static void devolveNo(struct descLESE *p, int posicao)
{ 
    p->vet[posicao].prox = p->listaDispo;
    p->listaDispo = posicao;
}
