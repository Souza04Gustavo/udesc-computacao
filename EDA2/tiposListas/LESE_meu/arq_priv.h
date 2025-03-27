#include "aqr_int.h"

static int obtemNo(struct descLESE *p);

/* devolve uma posição à lista de disponibilidade, inserindo sempre no inicio
   desta. Tal posição é um índice do vetor (pos_fisica)   
*/
static void devolveNo(struct descLESE *p, int posicao);