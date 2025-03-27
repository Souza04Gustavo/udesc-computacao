#include "arq.h"
#include "math.h"

int main(void)
{	int tamVet, i, j;
	info data[]={{23,"Pedro"},{32,"Maria"},{18,"Ana"},{81,"Vania"}}, tmp;
	struct descLSE *p=NULL;
	p=cria(sizeof(info));
	
	tamVet=sizeof(data)/sizeof(info);
	
	system("clear");	
	puts(">>>>> Testando a inserção no inicio");////
	for(i=0;i<tamVet;i++)
	{	if (insereNovoPrimeiro(&data[i], p)== FRACASSO)
		{	printf("erro na insercao\n");
			exit(0);
		}
		else
			printf("Inserido no inicio da lista: %s \n", data[i].nome);
	}
	printf("tamanho da lista: %i\n\n", tamanhoDaLista(p));


	puts(">>>>> Testando a remoção do inicio");////
	for(i=1; i<=tamVet;i++)
		if (removeOprimeiro(&tmp,p) == FRACASSO)
		{	printf("erro na remocao\n");
			exit(0);
		}			
		else
			printf("Removido do inicio da lista: %s \n",tmp.nome);
	printf("tamanho da lista: %i\n\n", tamanhoDaLista(p));


	puts(">>>>> Testando a inserção no final");////
	for(i=0;i<tamVet;i++)
	{	if (insereNovoUltimo(&data[i], p)== FRACASSO)
		{	printf("erro na insercao\n");
			exit(0);
		}			
		else
			printf("Inserido no final da lista %i %s \n", data[i].idade,data[i].nome);
	}
	printf("tamanho da lista: %i\n\n", tamanhoDaLista(p));

	puts(">>>>> Testando a remoção do final");////
	for(i=1; i<=tamVet;i++)
		if (removeOultimo(&tmp,p) == FRACASSO)
		{	printf("erro na remocao\n");
			exit(0);
		}			
		else
			printf("Removido do final da lista: %s \n",tmp.nome);
	printf("tamanho da lista: %i\n\n", tamanhoDaLista(p));

	puts(">>>>> Preparando teste da inserção em posiçao (Poslog) especificada");////
	for(i=0;i<tamVet-1;i++)
	{                    
	if (insereNovoPrimeiro(&data[i], p)== FRACASSO)
		{	printf("erro na insercao\n");
			exit(0);
		}
		else
			printf("Inserido no inicio da lista: %s \n",data[i].nome);
	}
	puts(">>>>>>>>> Testando a inserção em posiçao (Poslog) especificada");////	
	i=2;
	tmp.idade=50;
	strcpy(tmp.nome,"Mr. XX");
	if(insereNaPoslog(i,&tmp, p)== FRACASSO)
	{		printf("erro na insercao\n");
			exit(0);
	}
	else
			printf("Inserido %s na posicao %i da lista\n", tmp.nome,i);

	tmp.idade=80;
	strcpy(tmp.nome,"Sr. YY");
	if(insereNaPoslog(i,&tmp, p)== FRACASSO)
	{	printf("erro na insercao\n");
		exit(0);
	}			
	else
			printf("Inserido %s na posicao %i da lista\n", tmp.nome,i);
			
	printf("tamanho da lista: %i\n\n", tamanhoDaLista(p));


	puts(">>>>> Testando as buscas nas extremidades");////
	if (buscaOultimo(&tmp,p)== FRACASSO)
	{	printf("erro na busca\n");
		exit(0);
	}			
	else
		printf("final da lista: %s \n",tmp.nome);

	if(buscaOprimeiro(&tmp,p)== FRACASSO)
	{	printf("erro na busca\n");
		exit(0);
	}			
	else
		printf("inicio da lista: %s \n",tmp.nome);
	printf("\n\n");

	puts(">>>>> Testando a busca em posLog especificada");////
    j=tamanhoDaLista(p);  
	for(i=1;i<=j;i++)
	{                    
		if (buscaNaPoslog(i,&tmp, p)== FRACASSO)
		{	printf("erro na busca\n");
			exit(0);
		}			
		else
			printf("%s de idade %i consta na posicao %i da lista\n", tmp.nome,tmp.idade,i);
	}

	printf("\n>>>>> Testando a remoção em posiçao (Poslog) especificada\n");////	
	printf(">>>>>>>>Removerei itens nas %i primeiras posicoes\n", j/2);
	for(i=1; i<=j/2;i++) //round(tamVet/2)
		if (removeDaPoslog(i,&tmp,p) == FRACASSO)
		{	printf("erro na remocao\n");
			exit(0);
		}			
		else
			printf("%s de idade %i foi removido da posicao %i\n", tmp.nome,tmp.idade,i);
	printf("\n");
	
	puts(">>>>> Testando as buscas nas extremidades");////
	if (buscaOultimo(&tmp,p)== FRACASSO)
	{	printf("erro na remocao\n");
		exit(0);
	}			
	else
			printf("final da lista: %s \n", tmp.nome);

	if (buscaOprimeiro(&tmp,p)== FRACASSO)
	{	printf("erro na remocao\n");
		exit(0);
	}			
	else
			printf("inicio da lista: %s \n", tmp.nome);

	printf("tamanho da lista: %i \n\n", tamanhoDaLista(p));
	
	puts(">>>>> Testando o reset da lista");////
	puts(">>>>> Reset...");
	reinicia(p);
	printf("Tamanho da lista após reset: %i\n", tamanhoDaLista(p));
	
	p=destroi(p);
	getchar();
}
