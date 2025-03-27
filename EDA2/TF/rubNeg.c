#include "rubNeg.h"

// Funções auxiliares
ArvoreRN* criarRN() {
    ArvoreRN *arvore = malloc(sizeof(ArvoreRN));
    arvore->nulo = NULL;
    arvore->raiz = NULL;

    arvore->nulo = criarNo(arvore, NULL, 0);
    arvore->nulo->cor = Preto;

    return arvore;
}

int vazia(ArvoreRN* arvore) {
    return arvore->raiz == NULL;
}

No* criarNo(ArvoreRN* arvore, No* pai, int valor) {
    No* no = malloc(sizeof(No));

    no->pai = pai;    
    no->valor = valor;
    no->direita = arvore->nulo;
    no->esquerda = arvore->nulo;

    return no;
}

No* adicionarNo(ArvoreRN* arvore, No* no, int valor, int* contador) {
    if (valor > no->valor) {
        if (no->direita == arvore->nulo) {
            no->direita = criarNo(arvore, no, valor);
            no->direita->cor = Vermelho;
            
            // Incrementa o contador quando o nó é adicionado
            contador[1]++;

            return no->direita;
        } else {
            return adicionarNo(arvore, no->direita, valor, contador);
        }
    } else {
        if (no->esquerda == arvore->nulo) {
            no->esquerda = criarNo(arvore, no, valor);
            no->esquerda->cor = Vermelho;
            
            // Incrementa o contador quando o nó é adicionado
            contador[1]++;
            
            return no->esquerda;
        } else {
            return adicionarNo(arvore, no->esquerda, valor, contador);
        }
    }
}

No* adicionar(ArvoreRN* arvore, int valor, int* contador) {
    if (vazia(arvore)) {
        arvore->raiz = criarNo(arvore, arvore->nulo, valor);
        arvore->raiz->cor = Preto;
        
        // Incrementa o contador quando a raiz é criada
        contador[1]++;

        return arvore->raiz;
    } else {
        No* no = adicionarNo(arvore, arvore->raiz, valor, contador);
        balancear(arvore, no, contador);
        
        return no;
    }
}

No* localizarRN(ArvoreRN* arvore, int valor) {
    if (!vazia(arvore)) {
        No* no = arvore->raiz;

        while (no != arvore->nulo) {
            if (no->valor == valor) {
                return no;
            } else {
                no = valor < no->valor ? no->esquerda : no->direita;
            }
        }
    }

    return NULL;
}

void percorrerProfundidadeInOrder(ArvoreRN* arvore, No* no, void (*callback)(int)) {
    if (no != arvore->nulo) {
        
        
        percorrerProfundidadeInOrder(arvore, no->esquerda,callback);
        callback(no->valor);
        percorrerProfundidadeInOrder(arvore, no->direita,callback);
    }
}

void percorrerProfundidadePreOrder(ArvoreRN* arvore, No* no, void (*callback)(int)) {
    if (no != arvore->nulo) {
        callback(no->valor);
        percorrerProfundidadePreOrder(arvore, no->esquerda,callback);
        percorrerProfundidadePreOrder(arvore, no->direita,callback);
    }
}

void percorrerProfundidadePosOrder(ArvoreRN* arvore, No* no, void (callback)(int)) {
    if (no != arvore->nulo) {
        percorrerProfundidadePosOrder(arvore, no->esquerda,callback);
        percorrerProfundidadePosOrder(arvore, no->direita,callback);
        callback(no->valor);
    }
}

void visitar(int valor){
    printf("%d ", valor);
}

void balancear(ArvoreRN* arvore, No* no, int* contador) {
    while (no->pai->cor == Vermelho) {
        if (no->pai == no->pai->pai->esquerda) {
            No* tio = no->pai->pai->direita;
            
            if (tio->cor == Vermelho) {
                tio->cor = Preto;  // Caso 1
                no->pai->cor = Preto;
                no->pai->pai->cor = Vermelho;  // Caso 1
                no = no->pai->pai;  // Caso 1
            } else {
                if (no == no->pai->direita) {
                    no = no->pai;  // Caso 2
                    rotacionarEsquerda(arvore, no, contador);  // Caso 2
                } else {
                    no->pai->cor = Preto;
                    no->pai->pai->cor = Vermelho;  // Caso 3
                    rotacionarDireita(arvore, no->pai->pai, contador);  // Caso 3
                }
            }
        } else {
            No* tio = no->pai->pai->esquerda;
            
            if (tio->cor == Vermelho) {
                tio->cor = Preto;  // Caso 1
                no->pai->cor = Preto;
                no->pai->pai->cor = Vermelho;  // Caso 1
                no = no->pai->pai;  // Caso 1
            } else {
                if (no == no->pai->esquerda) {
                    no = no->pai;  // Caso 2
                    rotacionarDireita(arvore, no, contador);  // Caso 2
                } else {
                    no->pai->cor = Preto;
                    no->pai->pai->cor = Vermelho;  // Caso 3
                    rotacionarEsquerda(arvore, no->pai->pai, contador);  // Caso 3
                }
            }
        }
    }
    arvore->raiz->cor = Preto;  // Conserta possível quebra regra 2
}

void rotacionarEsquerda(ArvoreRN* arvore, No* no, int* contador) {
    No* direita = no->direita;
    no->direita = direita->esquerda;

    if (direita->esquerda != arvore->nulo) {
        direita->esquerda->pai = no;
    }

    direita->pai = no->pai;

    if (no->pai == arvore->nulo) {
        arvore->raiz = direita;
    } else if (no == no->pai->esquerda) {
        no->pai->esquerda = direita;
    } else {
        no->pai->direita = direita;
    }

    direita->esquerda = no;
    no->pai = direita;

    // Incrementa o contador após a rotação
    contador[1]++;
}

void rotacionarDireita(ArvoreRN* arvore, No* no, int* contador) {
    No* esquerda = no->esquerda;
    no->esquerda = esquerda->direita;

    if (esquerda->direita != arvore->nulo) {
        esquerda->direita->pai = no;
    }

    esquerda->pai = no->pai;

    if (no->pai == arvore->nulo) {
        arvore->raiz = esquerda;
    } else if (no == no->pai->esquerda) {
        no->pai->esquerda = esquerda;
    } else {
        no->pai->direita = esquerda;
    }

    esquerda->direita = no;
    no->pai = esquerda;

    // Incrementa o contador após a rotação
    contador[1]++;
}

void transplante(ArvoreRN* arvore, No* u, No* v) {
    if (u->pai == arvore->nulo) {
        arvore->raiz = v;
    } else if (u == u->pai->esquerda) {
        u->pai->esquerda = v;
    } else {
        u->pai->direita = v;
    }
    v->pai = u->pai;
}

No* minimoSubarvore(ArvoreRN* arvore, No* no) {
    while (no->esquerda != arvore->nulo) {
        no = no->esquerda;
    }
    return no;
}

void correcaoRemocao(ArvoreRN* arvore, No* x, int* contador) {
    while (x != arvore->raiz && x->cor == Preto) {
        if (x == x->pai->esquerda) {
            No* w = x->pai->direita;
            if (w->cor == Vermelho) {
                w->cor = Preto;
                x->pai->cor = Vermelho;
                rotacionarEsquerda(arvore, x->pai, contador);
                w = x->pai->direita;

                // Incrementa o contador de rotações
                contador[1]++;

            }
            if (w->esquerda->cor == Preto && w->direita->cor == Preto) {
                w->cor = Vermelho;
                x = x->pai;
            } else {
                if (w->direita->cor == Preto) {
                    w->esquerda->cor = Preto;
                    w->cor = Vermelho;
                    rotacionarDireita(arvore, w, contador);
                    w = x->pai->direita;
                    // Incrementa o contador de rotações
                    contador[1]++;

                }
                w->cor = x->pai->cor;
                x->pai->cor = Preto;
                w->direita->cor = Preto;
                rotacionarEsquerda(arvore, x->pai, contador);
                contador[1]++;
                x = arvore->raiz;
            }
        } else {
            No* w = x->pai->esquerda;
            if (w->cor == Vermelho) {
                w->cor = Preto;
                x->pai->cor = Vermelho;
                rotacionarDireita(arvore, x->pai, contador);
                 contador[1]++;
                w = x->pai->esquerda;
            }
            if (w->direita->cor == Preto && w->esquerda->cor == Preto) {
                w->cor = Vermelho;
                x = x->pai;
            } else {
                if (w->esquerda->cor == Preto) {
                    w->direita->cor = Preto;
                    w->cor = Vermelho;
                    rotacionarEsquerda(arvore, w, contador);
                    w = x->pai->esquerda;
                     contador[1]++;

                }
                w->cor = x->pai->cor;
                x->pai->cor = Preto;
                w->esquerda->cor = Preto;
                rotacionarDireita(arvore, x->pai, contador);
                 contador[1]++;
                x = arvore->raiz;
            }
        }
    }
    x->cor = Preto;
}

void remover(ArvoreRN* arvore, int valor, int* contador) {
    // Procurar o nó com o valor especificado
    No* z = arvore->raiz;
    while (z != arvore->nulo && z->valor != valor) {
        z = (valor < z->valor) ? z->esquerda : z->direita;
        
        // Incrementa o contador de comparações
        contador[1]++;
    }

    // Se o nó não foi encontrado, retornar
    if (z == arvore->nulo) {
        printf("Valor %d não encontrado na árvore.\n", valor);
        return;
    }

    // Início do processo de remoção
    No* y = z;
    No* x;
    Cor corOriginal = y->cor;

    if (z->esquerda == arvore->nulo) {
        x = z->direita;
        transplante(arvore, z, z->direita);
        
        // Incrementa o contador de transplantes
        contador[1]++;
    } else if (z->direita == arvore->nulo) {
        x = z->esquerda;
        transplante(arvore, z, z->esquerda);
        
        // Incrementa o contador de transplantes
        contador[1]++;
    } else {
        y = minimoSubarvore(arvore, z->direita);
        corOriginal = y->cor;
        x = y->direita;
        if (y->pai == z) {
            x->pai = y;
        } else {
            transplante(arvore, y, y->direita);
            y->direita = z->direita;
            y->direita->pai = y;
        }
        transplante(arvore, z, y);
        y->esquerda = z->esquerda;
        y->esquerda->pai = y;
        y->cor = z->cor;
        
        // Incrementa o contador de transplantes
        contador[1]++;
    }
    
    if (corOriginal == Preto) {
        correcaoRemocao(arvore, x, contador);
    }
    free(z);
}
