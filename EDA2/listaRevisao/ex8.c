#include <stdio.h>
#include <string.h>

#define tam 50

typedef struct pilha
{
    int topo;
    char string[tam];

} Pilha;

int vazia(Pilha *p)
{

    if (p->topo == -1)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

int cheia(Pilha *p) {
    return (p->topo == tam - 1);
}

int empilhar(Pilha *p, char c)
{
    if (cheia(p))
    {
        printf("Pilha cheia, nao da pra empilhar!\n");
        return 0;
    }
    p->topo++;              // aumenta o topo
    p->string[p->topo] = c; // add o char
    return 1;
}

void inicializar(Pilha *p)
{
    p->topo = -1; // pilha vazia
}

char desempilhar(Pilha *p)
{
    if (vazia(p))
    {
        printf("Pilha vazia!\n");
        return -1;
    }
    int elemento = p->string[p->topo];
    p->topo--;

    return elemento; // return o topo
}

int analise(char *expressao)
{

    Pilha p;
    inicializar(&p);

    int tamanho = strlen(expressao);

    for (int i = 0; i < tamanho; i++)
    {
        char atual = expressao[i];

        if (atual == '(' || atual == '[' || atual == '{')
        {
            empilhar(&p, atual);
        }
        else if (atual == '}' || atual == ']' || atual == ')')
        {

            if (vazia(&p))
            {
                return 0; // pilha vazia
            }

            char topo = desempilhar(&p);
            if ((topo != '(' && atual == ')') || (topo != '{' && atual == '}') || (topo != '[' && atual == ']'))
            {
                return 0; // nao esta correto a ordem
            }
        }
    }

    if (!vazia(&p))
    {
        return 0; // ainda existe elemento e nao chegou la
    }

    return 1;
}

int main()
{

    char expressao[] = "()";

    if(analise(expressao)){
    printf("TRUE\n"); // esta organizado a ordem dos char
    }else{
    printf("FALSE\n");  // nao esta
    }

}