#include "arq_interface.h"
#include "math.h"

int main(void)
{	int tamData,tamanhoVetor, i, j;
	info data[]={{23,"Pedro"},{32,"Maria"},{18,"Ana"},{81,"Vania"}}, tmp;
	struct descLESE *p=NULL;	

	tamData=sizeof(data)/sizeof(info);
	tamanhoVetor = (int)tamData + 1;
	p=cria(tamanhoVetor,sizeof(info));
	


	system("clear");
	
		
	puts(">>>>> Testando a inserção no inicio");////
	for(i=0;i<tamData;i++)
	{	if (insereNovoPrimeiro(p,&data[i])== FRACASSO)
		{	printf("erro na insercao\n");
			exit(0);
		}
		else
			printf("Inserido no inicio da lista: %s \n", data[i].nome);
	}
	printf("tamanho da lista: %i\n\n", tamanhoDaLista(p));




	puts(">>>>> Testando a remoção do inicio");////
	for(i=1; i<=tamData;i++)
		if (removeOprimeiro(p,&tmp) == FRACASSO)
		{	printf("erro na remocao\n");
			exit(0);
		}			
		else
			printf("Removido do inicio da lista: %s \n",tmp.nome);
	printf("tamanho da lista: %i\n\n", tamanhoDaLista(p));





	puts(">>>>> Testando a inserção no final");////
	for(i=0;i<tamData;i++)
	{	if (insereNovoUltimo(p,&data[i])== FRACASSO)
		{	printf("erro na insercao\n");
			exit(0);
		}			
		else
			printf("Inserido no final da lista %i %s \n", data[i].idade,data[i].nome);
	}
	printf("tamanho da lista: %i\n\n", tamanhoDaLista(p));




	puts(">>>>> Testando a remoção do final");////
	for(i=1; i<=tamData;i++)
		if (removeOultimo(p,&tmp) == FRACASSO)
		{	printf("erro na remocao\n");
			exit(0);
		}			
		else
			printf("Removido do final da lista: %s \n",tmp.nome);
	printf("tamanho da lista: %i\n\n", tamanhoDaLista(p));





	puts(">>>>> Preparando teste da inserção em posiçao (PosLog) especificada");////
	for(i=0;i<tamData-1;i++)
	{                    
	if (insereNovoPrimeiro(p,&data[i])== FRACASSO)
		{	printf("erro na insercao\n");
			exit(0);
		}
		else
			printf("Inserido no inicio da lista: %s \n",data[i].nome);
	}
	
	
	
	
	puts(">>>>>>>>> Testando a inserção em posiçao (PosLog) especificada");////	
	i=2;
	tmp.idade=50;
	strcpy(tmp.nome,"Mr. XX");
	if(insereNaPosLog(p,&tmp,i)== FRACASSO)
	{		printf("erro na insercao\n");
			exit(0);
	}
	else
			printf("Inserido %s na posicao %i da lista\n", tmp.nome,i);





	tmp.idade=80;
	strcpy(tmp.nome,"Sr. YY");
	if(insereNaPosLog(p,&tmp,i)== FRACASSO)
	{	printf("erro na insercao\n");
		exit(0);
	}			
	else
			printf("Inserido %s na posicao %i da lista\n", tmp.nome,i);
	printf("tamanho da lista: %i\n\n", tamanhoDaLista(p));



	puts(">>>>> Testando as buscas nas extremidades");////
	if (buscaOultimo(p,&tmp)== FRACASSO)
	{	printf("erro na busca\n");
		exit(0);
	}			
	else
		printf("final da lista: %s \n",tmp.nome);
	if(buscaOprimeiro(p,&tmp)== FRACASSO)
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
		if (buscaNaPosLog(p,&tmp,i)== FRACASSO)
		{	printf("erro na busca\n");
			exit(0);
		}			
		else
			printf("%s de idade %i consta na posicao %i da lista\n", tmp.nome,tmp.idade,i);
	}




	printf("\n>>>>> Testando a remoção em posiçao (PosLog) especificada\n");////	
	printf(">>>>>>>>Removerei itens nas %i primeiras posicoes\n", j/2);
	for(i=1; i<=j/2;i++) //round(tamData/2)
		if (removeDaPosLog(p,&tmp,i) == FRACASSO)
		{	printf("erro na remocao\n");
			exit(0);
		}			
		else
			printf("%s de idade %i foi removido da posicao %i\n", tmp.nome,tmp.idade,i);
	printf("\n");
	
	
	
	
	puts(">>>>> Testando as buscas nas extremidades");////
	if (buscaOultimo(p,&tmp)== FRACASSO)
	{	printf("erro na remocao\n");
		exit(0);
	}			
	else
			printf("final da lista: %s \n", tmp.nome);

	if (buscaOprimeiro(p,&tmp)== FRACASSO)
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
