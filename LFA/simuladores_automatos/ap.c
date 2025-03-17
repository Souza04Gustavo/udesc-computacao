#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define max_estados 10
#define max_transicoes 20
#define max_alfabeto 5
#define max_pilha 100

// estrutura para transicao
typedef struct {
    int estado_atual;
    char simbolo;  // simbolo de entrada
    char simbolo_pilha;  // simbolo no topo da pilha
    int prox_estado; // prox estado
    char pilha_acao;     // acao na pilha: 'E' para empilhar, 'D' para desempilhar
} Transicao;

// estrutura para o AP
typedef struct {
    int num_estados;
    int estado_inicial;
    int estados_aceitos[max_estados];
    int estados_de_aceitacao;
    char alfabeto[max_alfabeto];
    Transicao transitions[max_transicoes];
    int num_transicoes;
    char pilha[max_pilha];
    int topo_pilha; // indice do topo da pilha
} Automato;

// verificar se o estado EH um estado de aceitacao
int eh_estado_aceito(Automato *ap, int estado) {
    for (int i = 0; i < ap->estados_de_aceitacao; i++) {
        if (ap->estados_aceitos[i] == estado) {
            return 1; // eh um estado de aceitacao
        }
    }
    return 0;
}

// avançar para o proox estado com base no simbolo atual e do topo da pilha
int pegar_prox_estado(Automato *ap, int estado_atual, char simbolo, char simbolo_pilha) {
    for (int i = 0; i < ap->num_transicoes; i++) {
        if (ap->transitions[i].estado_atual == estado_atual && ap->transitions[i].simbolo == simbolo && ap->transitions[i].simbolo_pilha == simbolo_pilha) {
            return i; //indice de transicao se tiver
        }
    }
    return -1; // invalida transicao
}

// para manipular a pilha
void empilhar(Automato *ap, char simbolo) {
    if (ap->topo_pilha < max_pilha - 1) {
        ap->topo_pilha++;
        ap->pilha[ap->topo_pilha] = simbolo;
    } else {
        printf("Erro: Pilha cheia\n");
    }
}

char desempilhar(Automato *ap) {
    if (ap->topo_pilha >= 0) {
        char simbolo = ap->pilha[ap->topo_pilha];
        ap->topo_pilha--;
        return simbolo;
    } else {
        printf("Erro: Pilha vazia\n");
        return '\0'; // vazio se a pilha estiver vazia
    }
}

// simalacao do ap
int simulate_ap(Automato *ap, char *palavra) {
    int estado_atual = ap->estado_inicial;
    ap->topo_pilha = -1; // pilha vazia de inicio
    empilhar(ap, 'Z'); // empilha o fundo (Z eh o fundo)

    printf("Estado inicial: %d\n", estado_atual);
    
    // inicio do processamento da palavra
    for (int i = 0; i < strlen(palavra); i++) {
        
        char simbolo = palavra[i];
        char simbolo_pilha;

        if (ap->topo_pilha >= 0) {
            simbolo_pilha = ap->pilha[ap->topo_pilha];
        } else {
             simbolo_pilha = 'Z';
        }

        int transicao_index = pegar_prox_estado(ap, estado_atual, simbolo, simbolo_pilha);

        if (transicao_index == -1) {
            printf("Erro: Transicao invalida ao ler o simbolo '%c' com topo da pilha '%c'\n", simbolo, simbolo_pilha);
            return 0; // palavra rejeitada
        }

        Transicao t = ap->transitions[transicao_index];
        
        printf("Transicao: (%d, '%c', '%c') -> %d\n", estado_atual, simbolo, simbolo_pilha, t.prox_estado);
        
        // atualiza o estado atual
        estado_atual = t.prox_estado;

        // executa a acao na pilha
        if (t.pilha_acao == 'E') {
            empilhar(ap, t.simbolo_pilha); // Empilha o simbolo atual
        } else if (t.pilha_acao == 'D') {
            desempilhar(ap); // desempilha o símbolo
        }
    }




    // verifica se terminou em um estado de aceitacao e se a pilha ta vazia (exceto o fundo)
    if (eh_estado_aceito(ap, estado_atual) && (ap->topo_pilha == 0 && ap->pilha[0] == 'Z')) {
        printf("Palavra aceita. Estado final: %d\n", estado_atual); 
        return 1;
    } else {
        printf("Palavra rejeitada. Estado final: %d\n", estado_atual); 
        return 0;
    }


}

int main() {
    Automato ap;

    // estados definidos
    ap.num_estados = 3;
    ap.estado_inicial = 0;
    ap.estados_aceitos[0] = 2; // estado 2 é um estado de aceitação
    ap.estados_de_aceitacao = 1;

    // definindo o alfabeto
    ap.alfabeto[0] = 'a';
    ap.alfabeto[1] = 'b';

    // definindo as transicoes
    ap.num_transicoes = 6;
ap.transitions[0] = (Transicao){0, 'a', 'Z', 1, 'E'};  // Estado 0, com 'a', empilha 'X' e vai para 1
ap.transitions[1] = (Transicao){0, 'a', 'X', 0, 'E'};  // Estado 0, com 'a', empilha 'X' e fica em 0
ap.transitions[2] = (Transicao){1, 'b', 'X', 2, 'D'};  // Estado 1, com 'b', desempilha 'X' e vai para 2
ap.transitions[3] = (Transicao){2, 'b', 'X', 1, 'D'};  // Estado 2, com 'b', desempilha 'X' e vai para 1
ap.transitions[4] = (Transicao){2, 'Z', 'Z', 2, 'N'};  // Estado 2, com 'Z', não faz nada e fica em 2
ap.transitions[5] = (Transicao){1, 'Z', 'Z', 1, 'N'};  // Permite ficar no estado 1 se a pilha estiver apenas com 'Z'

    char palavra[100];  // palavra 
    
    printf("Digite a palavra: ");
    scanf("%s", palavra);

    simulate_ap(&ap, palavra);

    return 0;
}
