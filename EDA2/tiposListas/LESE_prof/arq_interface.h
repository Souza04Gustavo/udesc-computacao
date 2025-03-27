#include "stdlib.h"
#include "stdio.h"
#include "string.h"

#define FRACASSO 0
#define SUCESSO 1

#define SIM 1
#define NAO  0
#define INI_LESE 1
#define OK 1
#define NOK -1

//======================APLICACAO=====================
typedef struct{ int idade;
		char nome[30];
	}info;
			

//======================LISTA=====================

struct noLESE{ 
    info dados;
    int prox;
};

struct descLESE { 
    struct noLESE *vet;
    int tamInfo;
    int tamanhoDaListaDeDados;
    int listDados;
    int listDispo;
};


/* operação de criação:
   pre-condição: existência de um apontador do tipo da est. de dados passado por referencia  para a função.
   pos-condição: criação e inicialização do TDA, atribuição do seu endereço ao  ponteiro passado por referencia. 
   Em caso de problemas na criação será sinalizado (retornado) o seu FRACASSO, caso contrário será sinalizado o seu SUCESSO.
*/
struct descLESE * cria(int tamanhoVetor, int tamInfo);

/*(Atenção: Em se tratando de uma LESE estaticamente alocada, temos utilizado a estratégia de passa o tamanho máximo do vetor.)*/

/* tipo de operação: função destrutora.
   pré-condição: a existência da est. de dados e um apontador declarado externamente à função, devidamente inicializado com o endereço da est. de dados e cujo endereço (deste apontador) é passado para função.
   pós-condição: destrói a est. de dados desalocando qualquer região de memória previamente alocada para o mesmo e retornando NULL.
*/  
struct descLESE * destroi(struct descLESE *p);

/* tipo de operação: função de manipulação.
   pré condição: a existência da est. de dados cujo endereço é passado para a função
   pós condição: "esvazia" o tda, de dados. O TDA volta às mesmas condições que existiam imediatamente após a sua criação
*/ 
int reinicia(struct descLESE *p);

/*tipo de operação: função de acesso.
  pré condição: a existência da est. de dados cujo endereço é passado para a função
  pós condição: se a est. de dados estiver vazio, retorna TRUE, caso contrário retorna FALSE. 
*/
int testaVazia(struct descLESE *p);

/* tipo de operação: função de acesso  (útil para casos de implementações estáticas).
   pré condição: a existência da est. de dados cujo endereço é passado para a função
   pós condição: se a est. de dados estiver cheio, retorna TRUE, caso contrário retorna FALSE. 
*/
int testaCheia(struct descLESE *p);


/************************************ Buscas ********************/

/*operação de acesso:
  pre-condição: existência do TDA cujo endereço é passado, juntamente com uma referência para uma variável do tipo info.
  pos-condição: em caso de sucesso copia o item no inicio da LESE para o local de memória apontado por pReg e retorna SUCESSO, caso contrário retorna FRACASSO
*/
int buscaOprimeiro(struct descLESE *p, info *pReg);

/*operação de acesso:
  pre-condição: existência do TDA cujo endereço é passado, juntamente com uma referência para uma variável do tipo info.
  pos-condição: em caso de sucesso copia o último item da LESE para o local de memória apontado por pReg e retorna SUCESSO, caso contrário retorna FRACASSO
*/
int buscaOultimo(struct descLESE *p, info *pReg);

/*operação de acesso:
  pre-condição: existência do TDA cujo endereço é passado, juntamente com uma referência para uma variável do tipo info e uma posição lógica válida (1 £ posLog £ tamanho da LESE) na seqüência da LESE.
  pos-condição: em caso de sucesso copia o item em posição lógica válida (1 £ posLog £ tamanho da LESE) para o local de memória apontado por pReg e retorna SUCESSO, caso contrário 
  retorna FRACASSO (posLog inválida ou LESE vazia)
*/
int buscaNaPosLog(struct descLESE *p, info *pReg, int posLog);

/************* Remoções: Perceba que as operações de3 remoção apenas executam a ação de retirada do item !!! */

/*operação de manipulação:
  pre-condição: existência do TDA cujo endereço é passado, juntamente com uma referência para uma variável do tipo info.
  pos-condição: se possível, remove o item do inicio da Fila e retorna SUCESSO, caso contrário retorna FRACASSO
*/
int removeOprimeiro(struct descLESE *p, info *pReg);

/*operação de manipulação:
  pre-condição: existência do TDA cujo endereço é passado, juntamente com uma referência para uma variável do tipo info.
  pos-condição: se possível remove o último item da Fila e retorna SUCESSO, caso contrário retorna FRACASSO
*/
int removeOultimo(struct descLESE *p,info *pReg);

/*operação de manipulação:
  pre-condição: existência do TDA cujo endereço é passado, juntamente com uma posição lógica válida (1 £ posLog £ tamanho da LESE) de onde será removido um item da seqüência da LESE.
  pos-condição: em caso de sucesso remove o item da posLog válida (1 £ posLog £ tamanho da LESE) e retorna SUCESSO, caso contrário retorna FRACASSO (posLog inválida ou LESE vazia)
*/
int removeDaPosLog(struct descLESE *p, info *pReg, int posLog);

/*********************************  Inserções *****************/

/* operação de manipulação:
   pre-condição: existência do TDA cujo endereço é passado, juntamente com uma referência para o novo registro de informação a ser inserido no inicio da LESE.
   pos-condição: em caso de sucesso retorna SUCESSO, caso contrário retorna FRACASSO
*/
int insereNovoPrimeiro(struct descLESE *p,info *pReg);

/* operação de manipulação:
   pre-condição: existência do TDA cujo endereço é passado, juntamente com uma referência para o novo registro de informação a ser inserido após o final da LESE.
   pos-condição: em caso de sucesso retorna SUCESSO, caso contrário retorna FRACASSO
*/
int insereNovoUltimo(struct descLESE *p, info *pReg);

/* operação de manipulação:
   pre-condição: existência do TDA cujo endereço é passado, juntamente com uma referência para o novo registro de informação a ser inserido e uma posição lógica válida (1 £ posLog £ tamanho da LESE) 
   onde será inserido o novo elemento na seqüência da LESE. Portanto esta operação não realiza inserção em LESE vazia pois nesse caso não há seqüência lógica e por conseguinte não há posições 
   lógicas a serem tomadas.
   pos-condição: em caso de sucesso toma-se a posição lógica de um item já existente na LESE, insere-se o novo item na posição lógica válida fornecida (1 £ posLog £ tamanho da LESE) deslocando-se o 
   antigo ocupante à frente e retorna-se SUCESSO, caso contrário retorna FRACASSO (posLog inválida)
*/
int insereNaPosLog(struct descLESE *p,info *pReg, int posLog);

/*--------------------função de acesso */
/* tipo de operação: função de acesso.
   pré condição: a existência da est. de dados cujo endereço é passado para a função
   pós condição: retorna o tamanho da LESE de dados. 
*/
int tamanhoDaLista(struct descLESE *p);


