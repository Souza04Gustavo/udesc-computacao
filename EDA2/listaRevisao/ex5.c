#include <stdio.h>

int degrau(int n) {

    int resposta = 0, i;

    if (n <= 1)
        return n;

    for (i = 1; i <= 2 && i <= n; i++) {
        resposta = resposta + degrau(n - i);
    }
    
    return resposta;
}

int main () {
   int valor;
    valor = degrau(2);
    printf("%d\n", valor);
    return 0;
}