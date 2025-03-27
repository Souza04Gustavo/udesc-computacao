#include "lib.h"

#define max_contagem_carros 6 // quantidade de carros maxima no fluxo

// funcao para verificar se o estado eh um estado de aceitacao
int eh_estado_aceito(Automaton *afd, int estado) {
    for (int i = 0; i < afd->estados_de_aceitacao; i++) {
        if (afd->estados_aceitos[i] == estado) {
            return 1; // estado de aceitacao
        }
    }
    return 0;
}

// funcao para avancar para o prox estado com base no simbolo atual
int pegar_prox_estado(Automaton *afd, int estado_atual, char simbolo) {
    for (int i = 0; i < afd->num_transicoes; i++) {
        if (afd->transitions[i].estado_atual == estado_atual && afd->transitions[i].simbolo == simbolo) {
            return afd->transitions[i].prox_estado; // retorna o prox estado se tiver
        }
    }
    return -1; // transicao invalida error
}

// simula o AFD com base em uma palavra de entrada
int simulate_afd(Automaton *afd, char *palavra) {
    int estado_atual = afd->estado_inicial;
    printf(CYAN "\n--- Simulação --- \n" RESET);
    printf("Estado inicial: %d\n", estado_atual);
    
    // processa cada simbolo da palavra
    for (int i = 0; i < strlen(palavra); i++) {
        char simbolo = palavra[i];
        int prox_estado = pegar_prox_estado(afd, estado_atual, simbolo);
        
        if (prox_estado == -1) {
            printf("Erro: Transicao invalida ao ler o simbolo '%c'\n", simbolo);
            return 0; // palavra rejeitada
        }

        printf("Transicao: (%d, '%c') -> %d\n", estado_atual, simbolo, prox_estado);
        estado_atual = prox_estado;
    }

    // verifica se terminou em um estado de aceitacao
    if (eh_estado_aceito(afd, estado_atual)) {
        printf(GREEN "Palavra aceita." RESET " Estado final: %d\n", estado_atual);
        return 1;
    } else {
        printf(RED "Palavra rejeitada." RESET " Estado final: %d\n", estado_atual);
        return 0;
    }
}

void iniciar_semaforo(Semaforo *semaforo){
    semaforo->estado1 = 0; // inicializa como vermelho
    semaforo->estado2 = 1; // inicializa como verde
    semaforo->topo = -1;
    //printf("\nSemaforo inicializado com sucesso!\n");
}

void adicionar_veiculo(Semaforo *semaforo, int fluxo) {
    if (fluxo == 1 && semaforo->topo < max_contagem_carros - 1) {
        semaforo->topo++;
        semaforo->pilha[semaforo->topo] = 1; // representa veiculo no fluxo B
        printf("Veículo adicionado ao fluxo B. Total: %d\n", semaforo->topo + 1);
    } else if (fluxo == 2 && semaforo->topo < max_contagem_carros - 1) {
        semaforo->topo++;
        semaforo->pilha[semaforo->topo] = 2; // representa veiculo no fluxo C
        printf("Veículo adicionado ao fluxo C. Total: %d\n", semaforo->topo + 1);
    } else {
        printf("Fila cheia! Fluxo %d atingiu o limite de veículos.\n", fluxo);
    }
}

void desempilhar_carro(Semaforo *semaforo){
    if(semaforo->topo >= 0){ // verificacao para garantir que ha algo na pilha antes de desempilhar
        semaforo->topo--; // desempilha 
        printf("Veiculo passou no sinal! Total de veiculos empilhados: %d\n", semaforo->topo + 1);
    }else{
        printf("Não há veiculos para desempilhar!\n");
    }

}

void alternar_estado(Semaforo *semaforo) {
    // Alterna os estados do semaforo entre os dois fluxos
    semaforo->estado1 = !semaforo->estado1; // inverte o fluxo com uma logica simples
    semaforo->estado2 = !semaforo->estado2;

    // print pra teste de fluxo
    printf("Semaforo alterado: Fluxo B agora esta %s e Fluxo C está %s.\n", 
            semaforo->estado1 ? GREEN "verde" RESET : RED "vermelho" RESET, 
            semaforo->estado2 ? GREEN "verde" RESET : RED "vermelho" RESET);
}

void alternar_estado_AD(Semaforo *semaforo) {
    // Alterna os estados do semaforo entre os dois fluxos
    semaforo->estado1 = !semaforo->estado1; // inverte o fluxo com uma logica simples
    semaforo->estado2 = !semaforo->estado2;

    // print pra teste de fluxo
    printf("Semaforo alterado: Fluxo A agora esta %s e Fluxo D está %s.\n", 
            semaforo->estado1 ? GREEN "verde" RESET : RED "vermelho" RESET, 
            semaforo->estado2 ? GREEN "verde" RESET : RED "vermelho" RESET);
}

int gera_caminho(int max, int min){
    int caminho = rand() % (max - min + 1) + min;
    return caminho;
}

void definir_caminhos_eficientes(char *palavra_a, char *palavra_b, char *palavra_c, char *palavra_d) {
    // Gerar caminho para A
    if (gera_caminho(2, 1) == 1) {
        strcpy(palavra_a, "p");
    } else {
        strcpy(palavra_a, "aaaraaap");
    }

    // Gerar caminho para B
    if (gera_caminho(2, 1) == 1) {
        strcpy(palavra_b, "p");
    } else {
        strcpy(palavra_b, "bbbrbbbp");
    }

    // Gerar caminho para C (fixo)
    strcpy(palavra_c, "ccp");

    // Gerar caminho para D
    if (gera_caminho(2, 1) == 1) {
        strcpy(palavra_d, "dp");
    } else {
        strcpy(palavra_d, "ddp");
    }

    // Exibir os resultados
    printf("\nCaminhos definidos:\n");
    printf("Palavra A: %s\n", palavra_a);
    printf("Palavra B: %s\n", palavra_b);
    printf("Palavra C: %s\n", palavra_c);
    printf("Palavra D: %s\n", palavra_d);
    printf("\n");
}


void definir_caminhos_eficientes_comCurva(char *palavra_a, char *palavra_b, char *palavra_c, char *palavra_d) {

    // Exibir os resultados
    printf("\nCaminhos definidos:\n");

    // Gerar caminho para A
    int caminho_a = gera_caminho(4, 1);
    if (caminho_a == 1) {
        strcpy(palavra_a, "p"); // fluxo normal
        printf("(Estaciona em P1) ");
    } else if(caminho_a == 2) {
        strcpy(palavra_a, "aaaraaap"); // fluxo normal ao passar pelo semaforo
        printf("(Faz a rota e estaciona em P1) ");
    }else if(caminho_a == 3){
        strcpy(palavra_a, "aap"); // virou a direita e estacionou
        printf("(Faz curva a direita no semáforo e estaciona em P5) ");
    }else if(caminho_a == 4){
        strcpy(palavra_a, "aaarap"); // passo pelo semoforo e virou a esquerda
        printf("(Faz curva a esquerda no semáforo após a rotatória e estaciona em P5) ");
    }
    printf("Palavra A: %s\n", palavra_a);
    
    // Gerar caminho para B
    int caminho_b = gera_caminho(4, 1);    
    if (caminho_b == 1){
        strcpy(palavra_b, "p");
        printf("(Estaciona em P2) ");
    } else if(caminho_b == 2){
        strcpy(palavra_b, "bbbrbbbp");
        printf("(Faz a rota e estaciona em P2) ");
    } else if(caminho_b == 3){
        strcpy(palavra_b, "bp");
        printf("(Virou a esquerda no semáforo e estacionou em P3) ");
    } else if(caminho_b == 4){
        strcpy(palavra_b, "bbbrbbp");
        printf("(Faz curva a direita no semáforo após a rotatória e estaciona em P3) ");
    } 
    printf("Palavra B: %s\n", palavra_b);


    // Gerar caminho para C
    int caminho_c = gera_caminho(4, 1);
    if (caminho_c == 1){
        strcpy(palavra_c, "ccp");
        printf("(Estaciona em P3) ");
    } else if(caminho_c == 2){
        strcpy(palavra_c, "cck");
        printf("(Virou a esquerda no semáforo e estacionou em P2) ");
    } else if(caminho_c == 3){
        strcpy(palavra_c, "ccddruup");
        printf("(Virou a direita no semáforo, fez a rotatoria, virou a direita no semáforo e estacionou em P3) ");
    } else if(caminho_c == 4){
        strcpy(palavra_c, "ccddruuk");
        printf("(Virou a direita no semáforo, fez a rotatoria, não virou no semáforo e estacionou em P2) ");
    }
    printf("Palavra C: %s\n", palavra_c);


    // Gerar caminho para D
    int caminho_d = gera_caminho(5, 1);
    if (caminho_d == 1) {
        strcpy(palavra_d, "dp");
        printf("(Estaciona em P4) ");
    } else if( caminho_d == 2){
        strcpy(palavra_d, "ddp");
        printf("(Estaciona em P5) ");
    }else if(caminho_d == 3){
        strcpy(palavra_d, "dderup");
        printf("(Virou a esquerda no semáforo, fez a rotatória, virou a esquerna no semaforo e estacionou em P5) ");
    }else if(caminho_d == 4){
        strcpy(palavra_d, "dderuup");
        printf("(Virou a esquerda no semáforo, fez a rotatória, segue reto no semaforo e estacionou em P1) ");
    }else if(caminho_d == 5){
        strcpy(palavra_d, "ddup");
        printf("(Virou a direita no semáforo, e estacionou em P1) ");
    }
    printf("Palavra D: %s\n", palavra_d);
    
    printf("\n");
}

void separarCaracteres(const char *entrada, char *saida_bc, char *saida_ad) {
    int indice_bc = 0; // Índice para a string de saída com 'b' e 'c'
    int indice_ad = 0; // Índice para a string de saída com 'a' e 'd'

    for (int i = 0; entrada[i] != '\0'; i++) {
        if (entrada[i] == 'b' || entrada[i] == 'c') {
            saida_bc[indice_bc++] = entrada[i];
        } else if (entrada[i] == 'a' || entrada[i] == 'd') {
            saida_ad[indice_ad++] = entrada[i];
        }else{
            printf(RED "\nCaracter inválido detectado: " RESET "%c\n", entrada[i]);
            return;
        }
    }

    // Finaliza as strings com o caractere nulo
    saida_bc[indice_bc] = '\0';
    saida_ad[indice_ad] = '\0';
}

void criarFluxoComSemaforo_BC(Automaton *afd_b, Automaton *afd_c, char *palavra_b, char *palavra_c, char *carros, Semaforo *semaforo) {

    // verificação para garantir que processe uma palavra que exista de fato
    if( strlen(carros) == 0 ){
    //printf( YELLOW "\nFluxo AD não iniciado!\n" RESET );
    return;
    }

    int estados[max_contagem_carros] = {0}; // Estado atual dos carros
    int indices[max_contagem_carros] = {0}; // Índices para acompanhar o progresso
    Automaton *automatos[max_contagem_carros] = {NULL}; // Vetor de autômatos
    char *palavras[max_contagem_carros] = {NULL}; // Caminhos de cada carro
    int concluidos[max_contagem_carros] = {0}; // Carros que concluíram o percurso
    int num_carros = strlen(carros); // Quantidade de carros
    int carros_fluxo_b = 0, carros_fluxo_c = 0;

    if (num_carros > max_contagem_carros) {
        printf(RED "Erro: Número de carros excede o máximo permitido (%d).\n" RESET, max_contagem_carros);
        return;
    }

    // Inicializa os carros e define seus fluxos
    for (int i = 0; i < num_carros; i++) {
        indices[i] = 0; 
        concluidos[i] = 0;

        if (carros[i] == 'b') {
            automatos[i] = afd_b;
            palavras[i] = palavra_b;
            estados[i] = afd_b->estado_inicial;
            carros_fluxo_b++;
        } else if (carros[i] == 'c') {
            automatos[i] = afd_c;
            palavras[i] = palavra_c;
            estados[i] = afd_c->estado_inicial;
            carros_fluxo_c++;
        } else {
            printf("Erro: Carro em fluxo desconhecido '%c'.\n", carros[i]);
            return;
        }
    }

    printf(CYAN "\n\n--------> INÍCIO DA SIMULAÇÃO BC <--------\n" RESET);
    printf("Simulação para o(s) carro(s): %s\n", carros);

    int ciclo = 0, todos_concluidos = 0;

    while (!todos_concluidos) {
        printf("\n--- Ciclo %d ---\n", ++ciclo);
        printf("Semáforo: Fluxo B está %s, Fluxo C está %s\n",
               semaforo->estado1 ? GREEN "verde" RESET : RED "vermelho" RESET,
               semaforo->estado2 ? GREEN "verde" RESET : RED "vermelho" RESET);

        todos_concluidos = 1; 

        for (int i = 0; i < num_carros; i++) {
            if (concluidos[i]) continue;

            if (indices[i] < strlen(palavras[i])) {
                char simbolo = palavras[i][indices[i]];

                // Verifica o semáforo para o fluxo
                if (carros[i] == 'b' &&
                    ((estados[i] == 1 && !semaforo->estado1) || (estados[i] == 5 && !semaforo->estado1))) {
                    printf(RED "Carro %d no fluxo B aguardando semáforo verde.\n" RESET, i + 1);
                    todos_concluidos = 0;
                    continue;
                }

                if (carros[i] == 'c' && (estados[i] == 2 && !semaforo->estado2)) {
                    printf( RED "Carro %d no fluxo C aguardando semáforo verde.\n" RESET, i + 1);
                    todos_concluidos = 0;
                    continue;
                }

                // Transição do estado
                printf("Carro %d: estado atual = %d, simbolo = '%c'\n", i + 1, estados[i], simbolo);

                int prox_estado = pegar_prox_estado(automatos[i], estados[i], simbolo);
                if (prox_estado == -1) {
                    printf(RED "Erro: Transição inválida para o carro %d\n" RESET, i + 1);
                    return;
                }

                estados[i] = prox_estado;
                indices[i]++;
                printf("Carro %d: novo estado = %d\n", i + 1, estados[i]);

                // Verifica se o carro concluiu o percurso
                if (indices[i] == strlen(palavras[i]) && eh_estado_aceito(automatos[i], estados[i])) {
                    printf(GREEN "Carro %d concluiu o percurso.\n" RESET, i + 1);
                    concluidos[i] = 1;

                    // Atualiza o número de carros restantes por fluxo
                    if (carros[i] == 'b') carros_fluxo_b--;
                    if (carros[i] == 'c') carros_fluxo_c--;
                } else {
                    todos_concluidos = 0;
                }
            }
        }

        // Prioriza o fluxo com mais carros
        if (carros_fluxo_b > carros_fluxo_c) {
            semaforo->estado1 = 1;
            semaforo->estado2 = 0;
        } else if (carros_fluxo_c > carros_fluxo_b) {
            semaforo->estado1 = 0;
            semaforo->estado2 = 1;
        } else {
            alternar_estado_AD(semaforo); // Alterna caso os fluxos tenham o mesmo número
        }

        printf("--- Fim do Ciclo %d ---\n", ciclo);
    }

    printf(CYAN "\n--------> SIMULAÇÃO BC CONCLUÍDA <--------\n" RESET);
}


// fluxo AD que opera com contador de carros
void criarFluxoComSemaforo_AD(Automaton *afd_a, Automaton *afd_d, char *palavra_a, char *palavra_d, char *carros, Semaforo *semaforo) {

    // verificação para garantir que processe uma palavra que exista de fato
    if( strlen(carros) == 0 ){
    //printf( YELLOW "\nFluxo AD não iniciado!\n" RESET );
    return;
    }

    int estados[max_contagem_carros] = {0}; // Estado atual do carro
    int indices[max_contagem_carros] = {0}; // Índices para acompanhar o progresso de cada carro
    Automaton *automatos[max_contagem_carros] = {NULL}; // Vetor de autômatos
    char *palavras[max_contagem_carros] = {NULL}; // Palavras para cada carro
    int concluidos[max_contagem_carros] = {0}; // Carros que concluíram o percurso
    int num_carros = strlen(carros); // Quantidade de carros

    if (num_carros > max_contagem_carros) {
        printf(RED "Erro: Número de carros excede o máximo permitido (%d).\n" RESET, max_contagem_carros);
        return;
    }

    int carros_fluxo_a = 0, carros_fluxo_d = 0;

    // Inicializa os carros e define seus fluxos
    for (int i = 0; i < num_carros; i++) {
        indices[i] = 0; 
        concluidos[i] = 0;

        if (carros[i] == 'a') {
            automatos[i] = afd_a;
            palavras[i] = palavra_a;
            estados[i] = afd_a->estado_inicial;
            carros_fluxo_a++;
        } else if (carros[i] == 'd') {
            automatos[i] = afd_d;
            palavras[i] = palavra_d;
            estados[i] = afd_d->estado_inicial;
            carros_fluxo_d++;
        } else {
            printf("Erro: Carro em fluxo desconhecido '%c'.\n", carros[i]);
            return;
        }
    }

    printf(CYAN "\n\n--------> INÍCIO DA SIMULAÇÃO AD <--------\n" RESET);
    printf("Simulação para o(s) carro(s): %s\n", carros);

    int ciclo = 0, todos_concluidos = 0;

    while (!todos_concluidos) {
        printf("\n--- Ciclo %d ---\n", ++ciclo);
        printf("Semáforo: Fluxo A está %s, Fluxo D está %s\n",
               semaforo->estado1 ? GREEN "verde" RESET : RED "vermelho" RESET,
               semaforo->estado2 ? GREEN "verde" RESET : RED "vermelho" RESET);

        todos_concluidos = 1; 

        for (int i = 0; i < num_carros; i++) {
            if (concluidos[i]) continue; 

            if (indices[i] < strlen(palavras[i])) {
                char simbolo = palavras[i][indices[i]];

                // Verifica o semáforo para o fluxo
                if (carros[i] == 'a' && ((estados[i] == 2 || estados[i] == 4) && !semaforo->estado1)) {
                    printf(RED "Carro %d no fluxo A aguardando semáforo verde.\n" RESET, i + 1);
                    todos_concluidos = 0;
                    continue;
                }

                if (carros[i] == 'd' && (estados[i] == 2 && !semaforo->estado2)) {
                    printf(RED "Carro %d no fluxo D aguardando semáforo verde.\n" RESET , i + 1);
                    todos_concluidos = 0;
                    continue;
                }

                // Transição do estado
                printf("Carro %d: estado atual = %d, simbolo = '%c'\n", i + 1, estados[i], simbolo);

                int prox_estado = pegar_prox_estado(automatos[i], estados[i], simbolo);
                if (prox_estado == -1) {
                    printf(RED "Erro: Transição inválida para o carro %d\n" RESET, i + 1);
                    return;
                }

                estados[i] = prox_estado;
                indices[i]++;
                printf("Carro %d: novo estado = %d\n", i + 1, estados[i]);

                // Verifica se o carro concluiu o percurso
                if (indices[i] == strlen(palavras[i]) && eh_estado_aceito(automatos[i], estados[i])) {
                    printf(GREEN "Carro %d concluiu o percurso.\n" RESET, i + 1);
                    concluidos[i] = 1;

                    // Atualiza o número de carros restantes por fluxo
                    if (carros[i] == 'a') carros_fluxo_a--;
                    if (carros[i] == 'd') carros_fluxo_d--;
                } else {
                    todos_concluidos = 0;
                }
            }
        }

        // Prioriza o fluxo com mais carros
        if (carros_fluxo_a > carros_fluxo_d) {
            semaforo->estado1 = 1;
            semaforo->estado2 = 0;
        } else if (carros_fluxo_d > carros_fluxo_a) {
            semaforo->estado1 = 0;
            semaforo->estado2 = 1;
        } else {
            alternar_estado_AD(semaforo); // Alterna caso os fluxos tenham o mesmo número
        }

        printf("--- Fim do Ciclo %d ---\n", ciclo);
    }

    printf(CYAN "\n--------> SIMULAÇÃO AD CONCLUÍDA <--------\n" RESET);
}


void criarFluxoComCurvas_BC(Automaton *afd_b, Automaton *afd_c, char *palavra_b, char *palavra_c, char *carros, Semaforo *semaforo) {
    if (strlen(carros) == 0) {
        return;
    }

    int estados[max_contagem_carros] = {0};
    int indices[max_contagem_carros] = {0};
    Automaton *automatos[max_contagem_carros] = {NULL};
    char *palavras[max_contagem_carros] = {NULL};
    int concluidos[max_contagem_carros] = {0};
    int num_carros = strlen(carros);
    int carros_fluxo_b = 0, carros_fluxo_c = 0;

    if (num_carros > max_contagem_carros) {
        printf(RED "Erro: Número de carros excede o máximo permitido (%d).\n" RESET, max_contagem_carros);
        return;
    }

    for (int i = 0; i < num_carros; i++) {
        indices[i] = 0;
        concluidos[i] = 0;

        if (carros[i] == 'b') {
            automatos[i] = afd_b;
            palavras[i] = palavra_b;
            estados[i] = afd_b->estado_inicial;
            carros_fluxo_b++;
        } else if (carros[i] == 'c') {
            automatos[i] = afd_c;
            palavras[i] = palavra_c;
            estados[i] = afd_c->estado_inicial;
            carros_fluxo_c++;
        } else {
            printf("Erro: Carro em fluxo desconhecido '%c'.\n", carros[i]);
            return;
        }
    }

    printf(CYAN "\n\n--------> INÍCIO DA SIMULAÇÃO BC <--------\n" RESET);
    printf("Simulação para o(s) carro(s): %s\n", carros);

    int ciclo = 0, todos_concluidos = 0;

    while (!todos_concluidos) {
        printf("\n--- Ciclo %d ---\n", ++ciclo);
        printf("Semáforo: Fluxo B está %s, Fluxo C está %s\n",
               semaforo->estado1 ? GREEN "verde" RESET : RED "vermelho" RESET,
               semaforo->estado2 ? GREEN "verde" RESET : RED "vermelho" RESET);

        todos_concluidos = 1;

        for (int i = 0; i < num_carros; i++) {
            if (concluidos[i]) continue;

            if (indices[i] < strlen(palavras[i])) {
                char simbolo = palavras[i][indices[i]];

                // Verifica o semáforo para o fluxo
                if (carros[i] == 'b' &&
                    ((estados[i] == 1 && !semaforo->estado1) || (estados[i] == 5 && !semaforo->estado1))) {
                    printf(RED "Carro %d no fluxo B aguardando semáforo verde.\n" RESET, i + 1);
                    todos_concluidos = 0;
                    continue;
                }

                if (carros[i] == 'c') {
                    // Caso fluxo C em seu semáforo
                    if (estados[i] == 2 && !semaforo->estado2) {
                        printf(RED "Carro %d no fluxo C aguardando semáforo verde.\n" RESET, i + 1);
                        todos_concluidos = 0;
                        continue;
                    }
                    // Caso fluxo C dependa do semáforo de B após curvas
                    if ((estados[i] == 7 || estados[i] == 10) && !semaforo->estado1) {
                        printf(RED "Carro %d no fluxo C aguardando semáforo verde de B.\n" RESET, i + 1);
                        todos_concluidos = 0;
                        continue;
                    }
                }

                // Transição do estado
                printf("Carro %d: estado atual = %d, simbolo = '%c'\n", i + 1, estados[i], simbolo);

                int prox_estado = pegar_prox_estado(automatos[i], estados[i], simbolo);
                if (prox_estado == -1) {
                    printf(RED "Erro: Transição inválida para o carro %d\n" RESET, i + 1);
                    return;
                }

                estados[i] = prox_estado;
                indices[i]++;
                printf("Carro %d: novo estado = %d\n", i + 1, estados[i]);

                // Atualiza contadores de carros se mudar de via
                if (carros[i] == 'c' && (prox_estado == 6 || prox_estado == 7 || prox_estado == 10)) {
                    carros_fluxo_c--;
                    carros_fluxo_b++;
                    printf(YELLOW "Carro %d mudou do fluxo C para o fluxo B.\n" RESET, i + 1);
                }

                if (carros[i] == 'b' && prox_estado == 8) {
                    carros_fluxo_b--;
                    carros_fluxo_c++;
                    printf(YELLOW "Carro %d mudou do fluxo B para o fluxo C.\n" RESET, i + 1);
                }

                // Verifica se o carro concluiu o percurso
                if (indices[i] == strlen(palavras[i]) && eh_estado_aceito(automatos[i], estados[i])) {
                    printf(GREEN "Carro %d concluiu o percurso.\n" RESET, i + 1);
                    concluidos[i] = 1;

                    if (carros[i] == 'b') carros_fluxo_b--;
                    if (carros[i] == 'c') carros_fluxo_c--;
                } else {
                    todos_concluidos = 0;
                }
            }
        }

        // Prioriza o fluxo com mais carros
        if (carros_fluxo_b > carros_fluxo_c) {
            semaforo->estado1 = 1;
            semaforo->estado2 = 0;
        } else if (carros_fluxo_c > carros_fluxo_b) {
            semaforo->estado1 = 0;
            semaforo->estado2 = 1;
        } else {
            alternar_estado(semaforo);
        }

        printf("--- Fim do Ciclo %d ---\n", ciclo);
    }

    printf(CYAN "\n--------> SIMULAÇÃO BC CONCLUÍDA <--------\n" RESET);
}


void criarFluxoComCurvas_AD(Automaton *afd_a, Automaton *afd_d, char *palavra_a, char *palavra_d, char *carros, Semaforo *semaforo) {
    if (strlen(carros) == 0) {
        return;
    }

    int estados[max_contagem_carros] = {0};
    int indices[max_contagem_carros] = {0};
    Automaton *automatos[max_contagem_carros] = {NULL};
    char *palavras[max_contagem_carros] = {NULL};
    int concluidos[max_contagem_carros] = {0};
    int num_carros = strlen(carros);
    int carros_fluxo_a = 0, carros_fluxo_d = 0;

    if (num_carros > max_contagem_carros) {
        printf(RED "Erro: Número de carros excede o máximo permitido (%d).\n" RESET, max_contagem_carros);
        return;
    }

    for (int i = 0; i < num_carros; i++) {
        indices[i] = 0;
        concluidos[i] = 0;

        if (carros[i] == 'a') {
            automatos[i] = afd_a;
            palavras[i] = palavra_a;
            estados[i] = afd_a->estado_inicial;
            carros_fluxo_a++;
        } else if (carros[i] == 'd') {
            automatos[i] = afd_d;
            palavras[i] = palavra_d;
            estados[i] = afd_d->estado_inicial;
            carros_fluxo_d++;
        } else {
            printf("Erro: Carro em fluxo desconhecido '%c'.\n", carros[i]);
            return;
        }
    }

    printf(CYAN "\n\n--------> INÍCIO DA SIMULAÇÃO AD <--------\n" RESET);
    printf("Simulação para o(s) carro(s): %s\n", carros);

    int ciclo = 0, todos_concluidos = 0;

    while (!todos_concluidos) {
        printf("\n--- Ciclo %d ---\n", ++ciclo);
        printf("Semáforo: Fluxo A está %s, Fluxo D está %s\n",
               semaforo->estado1 ? GREEN "verde" RESET : RED "vermelho" RESET,
               semaforo->estado2 ? GREEN "verde" RESET : RED "vermelho" RESET);

        todos_concluidos = 1;

        for (int i = 0; i < num_carros; i++) {
            if (concluidos[i]) continue;

            if (indices[i] < strlen(palavras[i])) {
                char simbolo = palavras[i][indices[i]];

                // Verifica o semáforo para o fluxo
                if (carros[i] == 'a' &&
                    ((estados[i] == 1 && !semaforo->estado1) || (estados[i] == 5 && !semaforo->estado1))) {
                    printf(RED "Carro %d no fluxo A aguardando semáforo verde.\n" RESET, i + 1);
                    todos_concluidos = 0;
                    continue;
                }

                if (carros[i] == 'd') {
                    if (estados[i] == 2 && !semaforo->estado2) {
                        printf(RED "Carro %d no fluxo D aguardando semáforo verde.\n" RESET, i + 1);
                        todos_concluidos = 0;
                        continue;
                    }
                    if ((estados[i] == 6 || estados[i] == 7 || estados[i] == 10) && !semaforo->estado1) {
                        printf(RED "Carro %d no fluxo D aguardando semáforo verde de A.\n" RESET, i + 1);
                        todos_concluidos = 0;
                        continue;
                    }
                }

                // Transição do estado
                printf("Carro %d: estado atual = %d, simbolo = '%c'\n", i + 1, estados[i], simbolo);

                int prox_estado = pegar_prox_estado(automatos[i], estados[i], simbolo);
                if (prox_estado == -1) {
                    printf(RED "Erro: Transição inválida para o carro %d\n" RESET, i + 1);
                    return;
                }

                estados[i] = prox_estado;
                indices[i]++;
                printf("Carro %d: novo estado = %d\n", i + 1, estados[i]);

                // Atualiza contadores de carros se mudar de via
                if (carros[i] == 'd' && (prox_estado == 6 || prox_estado == 7 || prox_estado == 10)) {
                    carros_fluxo_d--;
                    carros_fluxo_a++;
                    printf(YELLOW "Carro %d mudou do fluxo D para o fluxo A.\n" RESET, i + 1);
                }

                if (carros[i] == 'a' && prox_estado == 8) {
                    carros_fluxo_a--;
                    carros_fluxo_d++;
                    printf(YELLOW "Carro %d mudou do fluxo A para o fluxo D.\n" RESET, i + 1);
                }

                // Verifica se o carro concluiu o percurso
                if (indices[i] == strlen(palavras[i]) && eh_estado_aceito(automatos[i], estados[i])) {
                    printf(GREEN "Carro %d concluiu o percurso.\n" RESET, i + 1);
                    concluidos[i] = 1;

                    if (carros[i] == 'a') carros_fluxo_a--;
                    if (carros[i] == 'd') carros_fluxo_d--;
                } else {
                    todos_concluidos = 0;
                }
            }
        }

        // Prioriza o fluxo com mais carros
        if (carros_fluxo_a > carros_fluxo_d) {
            semaforo->estado1 = 1;
            semaforo->estado2 = 0;
        } else if (carros_fluxo_d > carros_fluxo_a) {
            semaforo->estado1 = 0;
            semaforo->estado2 = 1;
        } else {
            alternar_estado(semaforo);
        }

        printf("--- Fim do Ciclo %d ---\n", ciclo);
    }

    printf(CYAN "\n--------> SIMULAÇÃO AD CONCLUÍDA <--------\n" RESET);
}

