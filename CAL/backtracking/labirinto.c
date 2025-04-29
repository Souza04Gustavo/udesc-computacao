#include <stdio.h>
#include <stdlib.h>

#define N 60

int isSafe(int maze[N][N], int x, int y) {
    return (x >= 0 && x < N && y >= 0 && y < N && maze[x][y] == 0);
}

int solveMazeUtil(int maze[N][N], int x, int y) {

     // verificacao de chegada
    if (x == N - 1 && y == N - 1) {
        maze[x][y] = 2; // Marca a saida como parte do caminho
        return 1; // Solução encontrada
    }

    // Verifica se a posição é segura
    if (isSafe(maze, x, y)) {
        //ponto atual faz parte do caminho
        maze[x][y] = 2;

        // vai pra direita
        if (solveMazeUtil(maze, x + 1, y)){
            return 1;
        }

        // vai pra baixo
        if (solveMazeUtil(maze, x, y + 1)){
            return 1;
        }   
        // vai para esquerda
        if (solveMazeUtil(maze, x - 1, y)){
            return 1;
        }

        // Tenta ir para cima
        if (solveMazeUtil(maze, x, y - 1)){
            return 1;
        }

        // Se nenhuma foi, entao desmarca o ponto atual
        maze[x][y] = 0;
        return 0;
    }

    return 0;
}

void printMaze(int maze[N][N]){
    printf("Caminho no labirinto:\n");
    printf("# ");
    for (int j = 1; j < N+1; j++) {
        printf("#");
    }
    printf("\n");
    for (int i = 0; i < N; i++) {
        printf("#");
        for (int j = 0; j < N; j++) {
            if(maze[i][j] == 1){
                printf("#");
            }else if(maze[i][j] == 2){
                printf("o");
            }else{
                printf(" ");
            }
            //printf("%d ", maze[i][j]);
        }
        printf("#\n");
    }
    for (int j = 0; j < N; j++) {
        printf("#");
    }
    printf(" #\n");
}

int solveMaze(int maze[N][N]) {
    // Iniciar a busca a partir do ponto de partida (0, 0)
    /*
    if (solveMazeUtil(maze, 0, 0) == 0) {
        printf("N�o h� solu��o para o labirinto.\n");
        return 0;
    }
    */

    // Imprimir
    printMaze(maze);
    return 1;
}

void loadMaze(int maze[N][N], char *fname){
    //gere um nesse site, cole no arquivo lab.txt ou outro
    //https://www.dcode.fr/maze-generator
    //veja quantas linhas e colunas tem e altere o valor de N
    //uma diferen�a de 1 na quantia de colunas geralmente n�o causa problema
    //pois o algoritmo aqui inclui uma borda extra
    FILE *f;
    int i, lineN = 0;
    char line[N+10];
    f = fopen(fname, "r");
    while(fgets(line, sizeof(line), f) != NULL){
        i = 0;
        if(line[0]=='0' || line[0] == '1'){
            while(line[i] != '\0'){
                maze[lineN][i] = line[i] - '0';
                i++;
                if(i>=N) break;
            }
            lineN++;
            if(lineN>=N){ break;}
        }
    }

    printf("i: %d, LineN: %d\n", i, lineN);

}

int main() {
    
    /*
    //1 = parede
    //0 = vazio
    //2 = caminho
    int maze[N][N] = {
        {0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
        {0, 1, 0, 1, 1, 0, 1, 1, 0, 1},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
        {1, 1, 0, 1, 0, 1, 1, 1, 1, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 1, 0},
        {0, 1, 0, 0, 0, 1, 1, 0, 1, 1},
        {0, 1, 1, 1, 1, 1, 1, 0, 1, 0},
        {0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
        {0, 1, 0, 1, 0, 1, 1, 1, 1, 0},
        {0, 0, 0, 1, 0, 0, 0, 0, 0, 0}
    };
    */
    
    int maze[N][N];

    loadMaze(maze, "lab.txt");

   if (solveMazeUtil(maze, 0, 0)) {
        printf("Labirinto resolvido!\n");
        printMaze(maze);
    } else {
        printf("Não foi possível encontrar uma solução.\n");

    
    }

    return 0;
}

