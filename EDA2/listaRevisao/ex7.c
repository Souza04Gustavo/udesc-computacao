#include <stdio.h>
#include <stdlib.h>

typedef struct no
{
    struct no *ant;
    struct no *prox;
    int valor;
} No;

typedef struct lista
{
    No *cabeca;
    No *cauda;
} Lista;

Lista *cria()
{
    return malloc(sizeof(Lista));
}

int vazia(Lista *l)
{
    return l->cabeca == NULL;
}

void adiciona(Lista *l, int v)
{
    No *no = malloc(sizeof(No));
    no->valor = v;

    if (l->cauda != NULL)
    { // se nao estiver vazio add
        l->cauda->prox = no;
    }

    no->prox = NULL;
    no->ant = l->cauda;

    l->cauda = no;

    if (l->cabeca == NULL)
    {
        l->cabeca = l->cauda;
    }
}

int main()
{
    Lista *a = cria();
    Lista *b = cria();

    adiciona(a, 3);
    adiciona(a, 7);
    adiciona(a, 1);
    adiciona(a, 10);

    adiciona(b, 99);
    adiciona(b, 1);
    adiciona(b, 8);
    adiciona(b, 10);

    No *noa = a->cabeca;

    while (noa != NULL)
    { // vai percorendo por a
        No *nob = b->cabeca;

        while (nob != NULL)
        {
            if (noa->valor == nob->valor)
            {
                printf("Igual em %d\n", noa->valor);
                return 0;
            }
            nob = nob->prox; // avanca para o proximo elemento da lista
        }

        noa = noa->prox; // avanca para o proximo elemento da lista b
    }
    printf("SEM INTERSECÇÃO\n");
}