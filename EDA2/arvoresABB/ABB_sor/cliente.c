#include <stdio.h>
#include <stdlib.h>
#include "ABB.c"

int main()
{  
    ABB *p = NULL;
    info vet[]={{300,30,"Pedro"},{200,32,"Paulo"},{400,35,"Judas"},{100,31,"Manuel"},
        {250,33,"Lucas"},{350,32,"Andre"},{450,34,"Thiago"},
        {330,33,"Lucasa"}, /*{272,32,"Andrea"},{392,34,"Thiagoa"},
                             {258,33,"Lucasb"},{274,32,"Andreb"},{394,34,"Thiagob"},
                             {259,33,"Lucasc"},{276,32,"Andrec"},{396,34,"Thiagoc"},
                             {1250,33,"Lucasw"},{1270,32,"Andrew"},{1390,34,"Thiagow"},
                             {2250,33,"Lucasq"},{2270,32,"Andreq"},{2390,34,"Thiagoq"},
                             {30,30,"Pedrow"},{20,32,"Paulow"},{10,35,"Judasa"},{40,31,"Manuel"},
                             {35,30,"Pedror"},{25,32,"Paulor"},{105,35,"Judase"},{405,31,"Manuele"},
                             {135,30,"Pedrore"},{125,32,"Paulore"},{1105,35,"Judasei"},{1405,31,"Manuelew"},
                             {3335,30,"Pediror"},{3325,32,"Paulior"},{33105,35,"Judasie"},{33405,31,"Manuelie"},
                             {535,30,"Wedror"},{525,32,"Pawlor"},{505,35,"Judawe"},{515,31,"Wanuele"},
                             {635,30,"Wuedror"},{625,32,"Pauwlor"},{605,35,"Judauwe"},{615,31,"Wanueule"},
                             {5,30,"Wedrori"},{7,32,"Pawlori"},{9,35,"Judawei"},{6,31,"Wanuelie"},
                             {4005,30,"Wori"},{4007,32,"Pori"},{4009,35,"Jawei"},{4006,31,"Waelie"},
                             {5300,30,"LECO"},{5200,32,"Peco"},{5100,35,"Luas"},{5400,31,"Manulo"},*/ {-1,-1,"\0"}};

    unsigned int i=0;
    p=criaABB(sizeof(info));	
    if (p) {

        i=0;
        do { // carregando a ABB
            if(insereABB(p, &vet[i]) == SUCESSO) {	
                printf("%i) inserido: %s, idade: %i anos, matricula: %i \n",i+1,vet[i].nome,vet[i].idade,vet[i].identificador);
                i++;
            }
            else { 
                puts(">>> Fracasso na inser��o");
                return 1;
            }
        } while(vet[i].idade > 0);
        puts("");
        puts("tecle para continuar...");
        getchar();
        menu(p);
    }

    return 0;
}



//////////////////////////////////////////////////////////
void flush(FILE *in)
{ 
    int c;

    do { 
        c = fgetc(in);
    } while(c!='\n' && c != EOF);
}


/////////////////////////////////////////////////////////
void menu(ABB *p)
{    	
    unsigned int opc=1;
    info aux, retorno;
    int identificador;
    while(1) {
        system("clear");
        printf("\n");
        puts("0:sair         1:inserir          2:remover             3:buscar  ");
        puts("4:reiniciar    5:perc. em ordem   6:perc. em pos-ordem  7:perc. em pre-ordem");
        puts("8:ABB vazia? ");
        printf("\n:> ");
        scanf("%u",&opc);

        switch (opc) { 
            case 0:
                p=destroiABB(p);
                return;
            case 1:
                printf("entre com 'nome matricula': ");
                flush(stdin);
                scanf("%s %i", aux.nome,&(aux.identificador));
                if (insereABB(p, &aux) == SUCESSO)
                    puts(">>> Sucesso na inser��o");
                else
                    puts(">>> Fracasso na inser��o");
                break;
            case 2:
                printf("entre com matricula: ");

                scanf("%i", &identificador);
                if (removeABB(p, identificador, &retorno) == SUCESSO)
                    printf(">>> Removeu: %i",retorno.identificador);
                else
                    puts(">>> Fracasso na remocao");
                break;
            case 3:
                printf("entre com matricula: ");

                scanf("%i", &identificador);
                if (buscaABB(p, &retorno, identificador) == SUCESSO)
                    printf(">>> Buscou: %s %i",retorno.nome, retorno.identificador);
                else
                    puts(">>> Fracasso na busca");
                break;
            case 4:
                reiniciaABB(p);
                puts(">>> ABB purgada!");
                break;
            case 5:
                if (emOrdem(p) == FRACASSO)
                    puts(">>> ABB vazia");
                break;
            case 6:
                if (posOrdem(p) == FRACASSO)
                    puts(">>> ABB vazia");
                break;
            case 7:
                if (preOrdem(p) == FRACASSO)
                    puts(">>> ABB vazia");
                break;
            case 8:
                if (testaVaziaABB(p) == SIM)
                    puts(">>> ABB vazia");
                else
                    puts(">>> ABB nao vazia");

        }
        printf("\n tecle para continuar...");
        flush(stdin);
        getchar();
    }
}
