#include "arq.h"

#define RESET "\033[0m"
#define BLUE "\033[34m"
#define RED "\033[31m"
#define GREEN "\033[32m"
#define YELLOW "\033[33m"
//linha de comando para executar em linux:
//gcc -Wall pilha.c arq.c -Larq.h && ./a.out nome_do_arquivo.html

int main(int argc, char const *argv[])
{
    FILE *file;
    char const *filename;

    if (argc != 2)// arquivo ta ok
    {
        printf("Uso: %s arquivo.html\n", argv[0]);
        return 1;
    }

    filename = argv[1];// nome do html

    file = fopen(filename, "r");//abertura do arquivo para leitura

    if (file == NULL)//verificacao da abertura
    {
        printf("Erro ao abrir o arquivo.\n");
        return 1;
    }

    descPilha *pilha;//declaracao da pilha

    noPilha *ajuda;//auxiliar para mostrar a pilha

    info aux;//auxiliar para insercao

    char *token1;//token para o strtok

    //varias flags: 
    //'aberturaParaTag' indica se houve uma abertura de tag (simbolo de '<')
    //'fecharTag' indica se eh uma tag de fechamento (composto por </..?)
    //'erro' indica se houve erro de aninhamento para fechar a execucao do codigo
    //'sFecha' indica se a tag em questao eh sem fechamento(tags dos tipos: !DOCTYPE, img, frame, input, br e comentarios[<!--...-->]) 
    int aberturaParaTag = 0, fecharTag = 0, erro = 0, sFecha = 0;

    //delimitadores e auxiliares para verificacao(todos menos v1) e realizacao do strtok(v1)
    char v1[3] = {'>', ' '};
    char v2[2] = "/";
    char v3[2] = "<";
    char v4[2] = "!";
    char nFecha1[4] = "img"; 
    char nFecha2[3] = "br"; 
    char nFecha3[6] = "input";
    char nFecha4[6] = "frame";

    //strings auxiliares:
    char strAux[50];//string que coleta o token e faz as verificacoes e demais processos (basicamente a string auxiliar principal)
    char strParaExcluir[50];//string auxiliar para analise e exclusao

    //strings principais:
    char html[10000];//armazena uma string que concatena todos os 'c' lidos por todas as iteracoes do fgets ate que este retorne NULL na leitura do arquivo .html
    char c[5000];//armazena a linha que o fgets lê

    info removido;//indica a string removida nos processos de remocao

   //auxiliar para montagem das strings auxiliares com o objetivo de ignorar o que nao indica uma tag no codigo
   int indice = 0;

    //criacao da pilha
    pilha = criaPilha();

//inicializacao da string html com um dos argumentos delimitadores(sem ser os de abertura e fechamento)
    html[0] = ' ';

    //realizacao da leitura do arquivo ate que o fgets retorne NULL (fim do arquivo)
    printf(YELLOW "--- INICIO DA ANALISE DO HTML ---\n" RESET);
    while (fgets(c, 5000, file) != NULL)
    {
        //concatena a string 'c' em 'html' verificando a existencia de um valor de retorno (no caso um ponteiro) 
        //se não existir eh porque deu erro na funcao
        strcat(html, c); 
        
        printf("Linha da html: %s\n", c);
    }
    printf(YELLOW "--- FIM DA ANALISE DO HTML ---\n" RESET);

    printf(YELLOW "\n--- STRING SALVA DO HTML COMPLETO ---\n" RESET);
    printf("%s\n", html);
    printf(YELLOW "--- FIM DA STRING SALVA DO HTML COMPLETO ---\n" RESET);

    token1 = strtok(html, v1);//primeiro token '>' e ' '

        //passagem pelos outros tokens e verificacao se houve um erro de aninhamento
        printf("\nExibição da evolução da pilha:\n");
        while (token1 != NULL && erro == 0)
        {
            //mostrando a pilha
            ajuda = pilha->topo;
            printf(BLUE "\nPilha:\n" RESET);
            for (int i = 0; i < pilha->tam; i++)
            {
                printf("%s\n", ajuda->data.str);
                ajuda = ajuda->anterior;   
            }

            //verificacao se há a abertura de tags ate o primeiro ' ' ou primeiro '>'
            for (int i = 0; i <= (int)strlen(token1); i++)
            {
                if (token1[i] == v3[0])//ve se tem abertura de tag
                {
                    if (token1[i + 1] == v4[0])//ve se eh um comentario ou !DOCTYPE 
                    {
                        sFecha = 1;
                    }
                    else
                    {
                        indice = i;
                        aberturaParaTag = 1;
                    }
                }
            }

            int j = 0; //auxiliar para montagem da strAux e da strParaExcluir
            if (aberturaParaTag == 1)//verifica se houve abertura de tag
            {
                //monta a strAux para auxiliar a analisar a string posteriormente
                for (int i = indice + 1; i <= (int)strlen(token1); i++)
                {
                    strAux[j] = token1[i];
                    j++;
                }

                //verificacoes se eh uma tag especifica que nao tem fechamento (nao serao inseridas na pilha)
                if (strcmp(strAux, nFecha1) == 0)
                {
                    printf("Encontrou: TAG DO TIPO <img>! (Nao iremos adicionar)\n\n");
                    sFecha = 1;
                }
                if (strcmp(strAux, nFecha2) == 0)
                {
                    printf("Encontrou: TAG DO TIPO <br>!! (Nao iremos adicionar)\n\n");
                    sFecha = 1;
                }
                if (strcmp(strAux, nFecha3) == 0)
                {
                    printf("Encontrou: TAG DO TIPO <input>!! (Nao iremos adicionar)\n\n");
                    sFecha = 1;
                }
                if (strcmp(strAux, nFecha4) == 0)
                {
                    printf("Encontrou: TAG DO TIPO <frame>!! (Nao iremos adicionar)\n\n");
                    sFecha = 1;
                }
            }

            if (aberturaParaTag == 1 && sFecha == 0)//verifica se houve abertura de tag e se a tag tem fechamento
            {

                if (strAux[0] == v2[0])//verificacao se a tag tem '/' o que indica ser uma tag de fechamento
                {
                    fecharTag = 1;
                }
                if (fecharTag == 1)//verifica se eh uma tag de fechamento
                {
                    j = 0;
                    //montagem do strParaExcluir
                    for (int i = 1; i <= (int)strlen(strAux); i++)
                    {
                        strParaExcluir[j] = strAux[i];
                        j++;
                    }

                    //comparacao entre o topo da pilha e a tag que eh para ser fechada, verificando se sao iguais
                    if (strcmp(pilha->topo->data.str, strParaExcluir) == 0)
                    {

                        //executa a remocao do elemento da pilha verificando se deu certo
                        if (removeDaPilha(pilha, &removido) == 1)
                        {
                            printf(RED "\n(Atualizacao da pilha) String removida (encontrou fechamento): "RESET);
                            printf("%s", removido.str);

                            //redefinicao da strAux
                            strcpy(strAux, pilha->topo->data.str);
                        }
                        else
                        {
                            printf(RED "FALHA NA REMOCAO\n\n" RESET);
                        }
                    }
                    else
                    {
                        erro = 1;
                        //mensagem de erro de aninhamento
                        printf("\nERRO! Esperado </%s>, recebido <%s>.\n Sugestao: Fechar a tag <%s> com </%s> ou abrir uma tag <%s> antes de fechá-la!\n\n", pilha->topo->data.str, strAux, pilha->topo->data.str, pilha->topo->data.str, strParaExcluir);
                    }
                }
                else
                {
                    //definindo o 'aux' para insercao na pilha com verificacao
                    strcpy(aux.str, strAux);
                    

                        //insercao na pilha com verificacao
                        if (insereNaPilha(pilha, &aux) == 1)
                        {
                            printf(GREEN "\nSUCESSO NA INSERCAO (ENCONTROU ABERTURA)! ATUALIZANDO PILHA:" RESET);
                        }
                        else
                        {
                            printf(RED "FALHA NA INSERCAO!" RESET);
                        }                    
                        
                }
                fecharTag = 0;//reinicializacao da 'fecharTag'
            }
            aberturaParaTag = 0;//reinicializacao da 'aberturaParaTag'
            sFecha = 0;//reinicializacao da 'sFecha'

            //passagem para o proximo token
            token1 = strtok(NULL, v1);
        }
    
        if (erro == 1)//verifica se houve erro de aninhamento
        {
            printf(RED "Encerrando a execucao do programa...\n\n" RESET);
        }
        else
        {
            printf(GREEN "\nCodigo sem erros de aninhamento!\n\n" RESET);
        }
        fclose(file);//fechamento do arquivo

        //liberacao da memoria alocada dinamicamento
        free(pilha->vetor);
        free(pilha);
        return 0;
    
}