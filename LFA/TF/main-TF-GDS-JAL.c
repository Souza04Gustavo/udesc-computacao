#include <time.h>
#include "lib.h"

#define carros 100

int main() {
    
    printf(CYAN "\n==================================================================\n" RESET);
    printf("\n---- TRABALHO FINAL DA MATÉRIA LINGUAGENS FORMAIS E AUTÕMATOS ----\n");
    printf("\nProfessor: Ricardo Ferreira Martins.\n");
    printf("Alunos: Gustavo de Souza; José Augusto Laube.\n");
    printf(CYAN "\n==================================================================\n" RESET);

    srand(time(NULL));
    
    // MODELO SEM CURVAS
    Automaton afd_a;

    // definindo os estados
    afd_a.num_estados = 8;
    afd_a.estado_inicial = 0;
    afd_a.estados_aceitos[0] = 7; // estado final
    afd_a.estados_de_aceitacao = 1; // quantidade de estados finais

    // deefinindo o alfabeto 
    afd_a.alfabeto[0] = 'a';
    afd_a.alfabeto[1] = 'r';
    afd_a.alfabeto[2] = 'p';

    // definindo as transições
    afd_a.num_transicoes = 9;
    afd_a.transitions[0] = (Transicao){0, 'a', 1};
    afd_a.transitions[1] = (Transicao){0, 'p', 7};
    afd_a.transitions[2] = (Transicao){1, 'a', 2};  
    afd_a.transitions[3] = (Transicao){2, 'a', 3};  
    afd_a.transitions[4] = (Transicao){3, 'r', 3};  
    afd_a.transitions[5] = (Transicao){3, 'a', 4};
    afd_a.transitions[6] = (Transicao){4, 'a', 5};
    afd_a.transitions[7] = (Transicao){5, 'a', 6};
    afd_a.transitions[8] = (Transicao){6, 'p', 7};


    // MODELO COM CURVAS
    Automaton afd_a_curva;

    // definindo os estados
    afd_a_curva.num_estados = 10;
    afd_a_curva.estado_inicial = 0;
    afd_a_curva.estados_aceitos[0] = 7; // estado final1
    afd_a_curva.estados_aceitos[1] = 9; // estado final2
    afd_a_curva.estados_de_aceitacao = 2; // quantidade de estados finais
    // deefinindo o alfabeto (usuario pode definir como desejar)
    afd_a_curva.alfabeto[0] = 'a';
    afd_a_curva.alfabeto[1] = 'r';
    afd_a_curva.alfabeto[2] = 'p';
    afd_a_curva.alfabeto[3] = 'd';  // se entrar no 

    // definindo as transições (usuario pode definir como desejar)
    afd_a_curva.num_transicoes = 14;
    afd_a_curva.transitions[0] = (Transicao){0, 'a', 1};
    afd_a_curva.transitions[1] = (Transicao){0, 'p', 7};
    afd_a_curva.transitions[2] = (Transicao){1, 'a', 2};  
    // estado 2 é o estado C3
    afd_a_curva.transitions[3] = (Transicao){2, 'a', 3};  
    afd_a_curva.transitions[4] = (Transicao){2, 'd', 8}; // estado 8 é rotatoria R1 
    afd_a_curva.transitions[5] = (Transicao){2, 'p', 9}; // estado 9 é o P5 (VIROU PARA DIREITA)
    afd_a_curva.transitions[6] = (Transicao){3, 'r', 3};  
    afd_a_curva.transitions[7] = (Transicao){3, 'a', 4};
    // estado 4 é o estado C3'
    afd_a_curva.transitions[8] = (Transicao){4, 'a', 5};  // estado 5 é C1'
    afd_a_curva.transitions[9] = (Transicao){4, 'd', 8}; // estado 8 é R1
    afd_a_curva.transitions[10] = (Transicao){4, 'p', 9};  // estado 9 é P5 (VIROU ESQUERDA)

    afd_a_curva.transitions[11] = (Transicao){5, 'a', 6};
    afd_a_curva.transitions[12] = (Transicao){6, 'p', 7};

    afd_a_curva.transitions[13] = (Transicao){8, 'r', 8}; // rotatoria

    
    // MODELO SEM CURVAS
    Automaton afd_b;

    // definindo os estados
    afd_b.num_estados = 8;
    afd_b.estado_inicial = 0;
    afd_b.estados_aceitos[0] = 7; // estado final
    afd_b.estados_de_aceitacao = 1; // quantidade de transacoes por vez

    // deefinindo o alfabeto 
    afd_b.alfabeto[0] = 'b';
    afd_b.alfabeto[1] = 'r';
    afd_b.alfabeto[2] = 'p';

    // definindo as transições 
    afd_b.num_transicoes = 9;
    afd_b.transitions[0] = (Transicao){0, 'b', 1};
    afd_b.transitions[1] = (Transicao){0, 'p', 7};
    afd_b.transitions[2] = (Transicao){1, 'b', 2};  
    afd_b.transitions[3] = (Transicao){2, 'b', 3};  
    afd_b.transitions[4] = (Transicao){3, 'r', 3};  
    afd_b.transitions[5] = (Transicao){3, 'b', 4};
    afd_b.transitions[6] = (Transicao){4, 'b', 5};
    afd_b.transitions[7] = (Transicao){5, 'b', 6};
    afd_b.transitions[8] = (Transicao){6, 'p', 7};


    // MODELO COM CURVAS
    Automaton afd_b_curva;

    // definindo os estados 
    afd_b_curva.num_estados = 8;
    afd_b_curva.estado_inicial = 0;
    afd_b_curva.estados_aceitos[0] = 7; // estado final1
    afd_b_curva.estados_aceitos[1] = 9; // estado final2
    afd_b_curva.estados_de_aceitacao = 2; //quantidade de estados finais

    // deefinindo o alfabeto
    afd_b_curva.alfabeto[0] = 'b';
    afd_b_curva.alfabeto[1] = 'r';
    afd_b_curva.alfabeto[2] = 'p';
    afd_b_curva.alfabeto[3] = 'c';

    // definindo as transições 
    afd_b_curva.num_transicoes = 14;
    afd_b_curva.transitions[0] = (Transicao){0, 'b', 1};
    afd_b_curva.transitions[1] = (Transicao){0, 'p', 7};
    // estado 1 é o semaforo
    afd_b_curva.transitions[2] = (Transicao){1, 'b', 2};  
    afd_b_curva.transitions[3] = (Transicao){1, 'p', 9}; // estado 9 é P3 (VIROU ESQ)
    afd_b_curva.transitions[4] = (Transicao){1, 'c', 8}; // estado 8 é R4
    afd_b_curva.transitions[5] = (Transicao){8, 'r', 8}; // rotatoria
    afd_b_curva.transitions[6] = (Transicao){2, 'b', 3};  
    afd_b_curva.transitions[7] = (Transicao){3, 'r', 3};  
    afd_b_curva.transitions[8] = (Transicao){3, 'b', 4};
    afd_b_curva.transitions[9] = (Transicao){4, 'b', 5};
    afd_b_curva.transitions[10] = (Transicao){5, 'b', 6}; // estado 5 é o semaforo 
    afd_b_curva.transitions[11] = (Transicao){5, 'p', 9}; // estado 9 e P3 (VIROU DIREITA)
    afd_b_curva.transitions[12] = (Transicao){5, 'c', 8}; // estado 8 é R4
    afd_b_curva.transitions[13] = (Transicao){6, 'p', 7};

    // MODELO SEM CURVAS
    Automaton afd_c;

    // definindo os estados 
    afd_c.num_estados = 5;
    afd_c.estado_inicial = 0;
    afd_c.estados_aceitos[0] = 4; // estado final
    afd_c.estados_de_aceitacao = 1; // quantidade de transacoes por vez

    // deefinindo o alfabeto 
    afd_c.alfabeto[0] = 'c';
    afd_c.alfabeto[1] = 'r';
    afd_c.alfabeto[2] = 'p';

    // definindo as transições 
    afd_c.num_transicoes = 5;
    afd_c.transitions[0] = (Transicao){0, 'c', 1};
    afd_c.transitions[1] = (Transicao){1, 'c', 2};
    afd_c.transitions[2] = (Transicao){2, 'p', 4};  
    afd_c.transitions[3] = (Transicao){2, 'c', 3};  
    afd_c.transitions[4] = (Transicao){3, 'r', 3};  



    // MODELO COM CURVAS
    Automaton afd_c_curva;

    // definindo os estados 
    afd_c_curva.num_estados = 11;
    afd_c_curva.estado_inicial = 0;
    afd_c_curva.estados_aceitos[0] = 4; // estado final1
    afd_c_curva.estados_aceitos[1] = 5; // estado final2
    afd_c_curva.estados_de_aceitacao = 2; //quantidade de estados finais

    // deefinindo o alfabeto
    afd_c_curva.alfabeto[0] = 'c';
    afd_c_curva.alfabeto[1] = 'r';
    afd_c_curva.alfabeto[2] = 'p';
    afd_c_curva.alfabeto[3] = 'd';
    afd_c_curva.alfabeto[4] = 'k';
    afd_c_curva.alfabeto[5] = 'u';

    // definindo as transições
    afd_c_curva.num_transicoes = 16;
    afd_c_curva.transitions[0] = (Transicao){0, 'c', 1};
    afd_c_curva.transitions[1] = (Transicao){1, 'c', 2};
    // estado 2 representa C2 que é o semaforo
    afd_c_curva.transitions[2] = (Transicao){2, 'p', 4}; // estado 4 é P3 (ESTACIONA RETO)
    afd_c_curva.transitions[3] = (Transicao){2, 'c', 3}; // estado 3 é R4 (SEGUE RETO)
    afd_c_curva.transitions[4] = (Transicao){3, 'r', 3}; // rotatoria
    afd_c_curva.transitions[5] = (Transicao){2, 'k', 5}; // estado 5 é P2 (ESTACIONA VIRANDO A ESQ)
    afd_c_curva.transitions[6] = (Transicao){2, 'u', 6}; // estado 6 é B  (B NA ESQ)
    afd_c_curva.transitions[7] = (Transicao){2, 'd', 7}; // estado 7 é C4 (VIRA DIREITA)
        
    afd_c_curva.transitions[8] = (Transicao){7, 'd', 8}; // estado 8 é R3 
    afd_c_curva.transitions[9] = (Transicao){8, 'u', 9}; // estado 9 é C4'
    afd_c_curva.transitions[10] = (Transicao){8, 'r', 8}; // rotatoria
    afd_c_curva.transitions[11] = (Transicao){9, 'u', 10}; // estado 10 é C2' (SEMAFORO)

    // estado 10 representa C2' que é o semaforo após fazer a rotatoria
    afd_c_curva.transitions[12] = (Transicao){10, 'c', 3}; // estado 3 é R4 (VIRA DIREITA)
    afd_c_curva.transitions[13] = (Transicao){10, 'p', 4}; // estado 4 é P3 (ESTACIONA VIRANDO A DIR)
    afd_c_curva.transitions[14] = (Transicao){10, 'k', 5}; // estado 5 é P2 (ESTACIONA RETO)
    afd_c_curva.transitions[15] = (Transicao){10, 'u', 6}; // estado 6 é B (SEGUE RETO)
   


    // MODELO SEM CURVAS
    Automaton afd_d;

    // definindo os estados
    afd_d.num_estados = 6;
    afd_d.estado_inicial = 0;
    afd_d.estados_aceitos[0] = 4; // estado final
    afd_d.estados_aceitos[1] = 5; // estado final 2
    afd_d.estados_de_aceitacao = 2; // quantidade de transacoes por vez

    // deefinindo o alfabeto
    afd_d.alfabeto[0] = 'd';
    afd_d.alfabeto[1] = 'r';
    afd_d.alfabeto[2] = 'p';

    // definindo as transições 
    afd_d.num_transicoes = 6;
    afd_d.transitions[0] = (Transicao){0, 'd', 1}; //estado 1 é C4
    afd_d.transitions[1] = (Transicao){1, 'd', 2}; // estado 2 é C2
    afd_d.transitions[2] = (Transicao){1, 'p', 4}; // estado 4 é P4
    afd_d.transitions[3] = (Transicao){2, 'd', 3}; // estado 3 é R1
    afd_d.transitions[4] = (Transicao){2, 'p', 5}; // estado 5 é P5
    afd_d.transitions[5] = (Transicao){3, 'r', 3};  


    // MODELO COM CURVAS
    Automaton afd_d_curva;

    // definindo os estados 
    afd_d_curva.num_estados = 11;
    afd_d_curva.estado_inicial = 0;
    afd_d_curva.estados_aceitos[0] = 4; // estado final1
    afd_d_curva.estados_aceitos[1] = 5; // estado final2
    afd_d_curva.estados_aceitos[2] = 10; // estado final2
    afd_d_curva.estados_de_aceitacao = 3; // quantidade de transacoes por vez

    // deefinindo o alfabeto 
    afd_d_curva.alfabeto[0] = 'd';
    afd_d_curva.alfabeto[1] = 'r';
    afd_d_curva.alfabeto[2] = 'p';
    afd_d_curva.alfabeto[3] = 'e';
    afd_d_curva.alfabeto[4] = 'u';

    // definindo as transições 
    afd_d_curva.num_transicoes = 15;
    afd_d_curva.transitions[0] = (Transicao){0, 'd', 1}; //estado 1 é C4
    afd_d_curva.transitions[1] = (Transicao){1, 'd', 2}; // estado 2 é C2
    afd_d_curva.transitions[2] = (Transicao){1, 'p', 4}; // estado 4 é P4
    //estado 2 é o semaforo
    afd_d_curva.transitions[3] = (Transicao){2, 'd', 3}; // estado 3 é R1
    afd_d_curva.transitions[4] = (Transicao){2, 'p', 5}; // estado 5 é P5
    afd_d_curva.transitions[5] = (Transicao){2, 'e', 6}; // estado 6 é R2 (VIROU ESQ) 
    afd_d_curva.transitions[6] = (Transicao){2, 'u', 8}; // estado 8 é C1 (VIROU PARA DIREITA) 

    afd_d_curva.transitions[7] = (Transicao){3, 'r', 3}; // rotatoria 
    afd_d_curva.transitions[8] = (Transicao){6, 'r', 6}; // rotatoria
    afd_d_curva.transitions[9] = (Transicao){6, 'u', 7}; // estado 7 é C2'(semaforo)  

    afd_d_curva.transitions[10] = (Transicao){7, 'p', 5};  // estado 5 é P5 (VIROU ESQ)
    afd_d_curva.transitions[11] = (Transicao){7, 'e', 3};
    afd_d_curva.transitions[12] = (Transicao){7, 'u', 8}; // estado 8 é C1
    afd_d_curva.transitions[13] = (Transicao){8, 'p', 10}; // estado 10 é P1
    afd_d_curva.transitions[14] = (Transicao){8, 'u', 9}; //estado 9 é A   

    char palavra_a[100];  // palavra a ser processada com inicio em A
    char palavra_b[100];  // palavra a ser processada com inicio em B
    char palavra_c[100];  // palavra a ser processada com inicio em C
    char palavra_d[100];  // palavra a ser processada com inicio em D

    char palavra_a_curva[100]; 
    char palavra_b_curva[100];  
    char palavra_c_curva[100]; 
    char palavra_d_curva[100];  

    int menu = 1;
    int cont= 0;
    int opcao;
    char selecao;
    char palavra_teste[100];

    while(menu){
            printf(CYAN "\n\n\n===============" RESET  " MENU DE SELEÇÃO " CYAN "===============\n" RESET );
            printf("(1) Simular AFDs de fluxo sem curva no semaforo;\n");
            printf("(2) Simular AFDs de fluxo com curva no semaforo;\n");
            printf("(3) Simular fluxo com semaforos (SEM TROCA DE DIREÇÃO);\n");
            printf("(4) Simular fluxo com semaforos (COM TROCA DE DIREÇÃO);\n");
            printf("(0) Para finalizar o programa;\n");

            scanf("%d", &opcao);
            getchar();

            switch(opcao){

                case 0:
                menu--; // finaliza o menu
                break;    

                case 1: // testes de AFDs sem curva
                printf("\nDigite (A, B, C ou D) para simular um AFD (SEM CURVA):\n");
                scanf(" %c", &selecao);
                switch(selecao){    

                    case 'A':
                    printf("Insira uma palavra para testar o AFD A:\n");
                    getchar();
                    fgets(palavra_teste, sizeof(palavra_teste), stdin);
                    palavra_teste[strcspn(palavra_teste, "\n")] = '\0'; // remover o \n do final caso tenha
    
                    simulate_afd(&afd_a, palavra_teste);
                    break;

                    case 'B':
                    printf("Insira uma palavra para testar o AFD B:\n");
                    getchar();
                    fgets(palavra_teste, sizeof(palavra_teste), stdin);
                    palavra_teste[strcspn(palavra_teste, "\n")] = '\0'; // remover o \n do final caso tenha
                    
                    simulate_afd(&afd_b, palavra_teste);
                    break;

                    case 'C':
                    printf("Insira uma palavra para testar o AFD C:\n");
                    getchar();
                    fgets(palavra_teste, sizeof(palavra_teste), stdin);
                    palavra_teste[strcspn(palavra_teste, "\n")] = '\0'; // remover o \n do final caso tenha
                    
                    simulate_afd(&afd_c, palavra_teste);
                    break;

                    case 'D':
                    printf("Insira uma palavra para testar o AFD D:\n");
                    getchar();
                    fgets(palavra_teste, sizeof(palavra_teste), stdin);
                    palavra_teste[strcspn(palavra_teste, "\n")] = '\0'; // remover o \n do final caso tenha
                    
                    simulate_afd(&afd_d, palavra_teste);
                    break;

                    default:
                    printf("AFD invalido selecionado!\n");
                    break;
                }

                break; // break do case 1 do switch opcao

                case 2: // testes de AFDs com curva
                
                printf("\nDigite (A, B, C ou D) para simular um AFD (COM CURVA):\n");
                scanf(" %c", &selecao);
                switch(selecao){    

                    case 'A':
                    printf("Insira uma palavra para testar o AFD A:\n");
                    getchar();
                    fgets(palavra_teste, sizeof(palavra_teste), stdin);
                    palavra_teste[strcspn(palavra_teste, "\n")] = '\0'; // remover o \n do final caso tenha
    
                    simulate_afd(&afd_a_curva, palavra_teste);
                    break;

                    case 'B':
                    printf("Insira uma palavra para testar o AFD B:\n");
                    getchar();
                    fgets(palavra_teste, sizeof(palavra_teste), stdin);
                    palavra_teste[strcspn(palavra_teste, "\n")] = '\0'; // remover o \n do final caso tenha
    
                    simulate_afd(&afd_b_curva, palavra_teste);
                    break;

                    case 'C':
                    printf("Insira uma palavra para testar o AFD C:\n");
                    getchar();
                    fgets(palavra_teste, sizeof(palavra_teste), stdin);
                    palavra_teste[strcspn(palavra_teste, "\n")] = '\0'; // remover o \n do final caso tenha
    
                    simulate_afd(&afd_c_curva, palavra_teste);
                    break;

                    case 'D':
                    printf("Insira uma palavra para testar o AFD D:\n");
                    getchar();
                    fgets(palavra_teste, sizeof(palavra_teste), stdin);
                    palavra_teste[strcspn(palavra_teste, "\n")] = '\0'; // remover o \n do final caso tenha
    
                    simulate_afd(&afd_d_curva, palavra_teste);
                    break;

                    default:
                    printf("AFD invalido selecionado!\n");
                    break;

                }

                break;


                case 3: // simulação do fluxo (SEM CURVA)
                
                char palavra[carros];
                definir_caminhos_eficientes(palavra_a, palavra_b, palavra_c, palavra_d);

                printf("\nInsira a palavra que deseja testar:\n");
                scanf("%s", palavra);

                Semaforo c2;
                iniciar_semaforo(&c2);
                
                Semaforo c3;
                iniciar_semaforo(&c3);
                
                char palavra_ad[100];
                char palavra_bc[100];
                separarCaracteres(palavra, palavra_bc, palavra_ad);
                
                // Simulação do fluxo
                // fluxo divido em rezão dos modelos e não haver conflito de vias
                criarFluxoComSemaforo_BC(&afd_b, &afd_c, palavra_b, palavra_c, palavra_bc, &c2);
                
                criarFluxoComSemaforo_AD(&afd_a, &afd_d, palavra_a, palavra_d, palavra_ad, &c3);

                break;

                case 4: // simulação do fluxo (COM CURVA)

                char palavra_comCurva[carros];

                definir_caminhos_eficientes_comCurva(palavra_a_curva, palavra_b_curva, palavra_c_curva, palavra_d_curva);

                printf("\nInsira a palavra que deseja testar:\n");
                scanf("%s", palavra_comCurva);

                Semaforo c2_curva;
                iniciar_semaforo(&c2_curva);
                
                Semaforo c3_curva;
                iniciar_semaforo(&c3_curva);
                
                char palavra_ad_curva[100];
                char palavra_bc_curva[100];
                separarCaracteres(palavra_comCurva, palavra_bc_curva, palavra_ad_curva);
                
                // Simulação do fluxo
                // fluxo divido em rezão dos modelos e não haver conflito de vias
                criarFluxoComCurvas_BC(&afd_b_curva, &afd_c_curva, palavra_b_curva, palavra_c_curva, palavra_bc_curva, &c2_curva);

                criarFluxoComCurvas_AD(&afd_a_curva, &afd_d_curva, palavra_a_curva, palavra_d_curva, palavra_ad_curva, &c3_curva);

            

                break; 

                default:
                printf("Digito invalido!\n");
                break;

            }
    }

    printf("\nPrograma finalizado!\n");

    return 0;
}