
// gcc fogo.c -lglut -lGL -lGLU -lm -o fogo
#include <GL/glut.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <math.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h> 
#include <stdlib.h>

#define ESCAPE 300
#define NUM_PARTICLES 15000
#define GRAVITY -0.0001
#define VIDAMAXIMA 70
#define TOPO_TEMPO (VIDAMAXIMA * 0.1)
#define TEMPO_FADE (VIDAMAXIMA * 0.8)
#define ALTURA_MAXIMA_FOGO 8.0f
#define FIRE_BASE_RADIUS 0.45f

// Rotation
static GLfloat yRot = 0.0f;
static GLfloat xRot = 0.0f;

// Texture
GLuint textureId; // ID da textura da madeira

struct s_pf {
    float x, y, z, veloc_x, veloc_y, veloc_z;
    unsigned lifetime;
} particles[NUM_PARTICLES];

int window;

int LoadBMPTexture(const char *filename, GLuint *textureID) {
    FILE *file;
    unsigned char header[54]; // Cabeçalho BMP tem 54 bytes
    unsigned int dataPos;     // Posição onde os dados da imagem começam
    unsigned int width, height;
    unsigned int imageSize;   // width * height * 3
    unsigned char *data;      // Buffer para os dados da imagem

    // Abre o arquivo
    file = fopen(filename, "rb"); // "rb" = read binary
    if (!file) {
        fprintf(stderr, "Erro: Nao foi possivel abrir o arquivo de textura %s\n", filename);
        return 0;
    }

    // Lê o cabeçalho
    if (fread(header, 1, 54, file) != 54) {
        fprintf(stderr, "Erro: Arquivo BMP invalido ou incompleto: %s\n", filename);
        fclose(file);
        return 0;
    }

    // Verifica a assinatura BMP
    if (header[0] != 'B' || header[1] != 'M') {
        fprintf(stderr, "Erro: Nao eh um arquivo BMP valido: %s\n", filename);
        fclose(file);
        return 0;
    }

    // Lê informações importantes do cabeçalho
    // (Assume formato BITMAPINFOHEADER padrão)
    dataPos   = *(int*)&(header[0x0A]); // Offset para os dados da imagem
    imageSize = *(int*)&(header[0x22]); // Tamanho dos dados da imagem
    width     = *(int*)&(header[0x12]); // Largura
    height    = *(int*)&(header[0x16]); // Altura

    // Se imageSize for 0, calcula (para BMPs não comprimidos)
    if (imageSize == 0) imageSize = width * height * 3;
    // Se dataPos for 0, assume 54 (cabeçalho padrão)
    if (dataPos == 0) dataPos = 54;

    // Aloca memória para os dados da imagem
    data = (unsigned char *)malloc(imageSize);
    if (!data) {
        fprintf(stderr, "Erro: Nao foi possivel alocar memoria para a textura %s\n", filename);
        fclose(file);
        return 0;
    }

    // Posiciona o ponteiro do arquivo no início dos dados
    fseek(file, dataPos, SEEK_SET);

    // Lê os dados da imagem
    if (fread(data, 1, imageSize, file) != imageSize) {
        fprintf(stderr, "Erro ao ler os dados da imagem de %s\n", filename);
        free(data);
        fclose(file);
        return 0;
    }

    // Fecha o arquivo
    fclose(file);

    // --- Converte BGR para RGB ---
    // Arquivos BMP geralmente armazenam cores como BGR
    for (unsigned int i = 0; i < imageSize; i += 3) {
        unsigned char temp = data[i];
        data[i] = data[i + 2];
        data[i + 2] = temp;
    }

    glGenTextures(1, textureID);
    glBindTexture(GL_TEXTURE_2D, *textureID);

    // Define parâmetros de filtragem e repetição
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); // Pode usar GL_LINEAR_MIPMAP_LINEAR para mipmaps

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);

    free(data);

    return 1; 
}

float calculateParticleSize(int lifetime) {
    if (lifetime < TOPO_TEMPO) {
        return 1.0f + (float)lifetime / TOPO_TEMPO * 4.0f;
    } else {
        return 5.0f - (float)(lifetime - TOPO_TEMPO) / (VIDAMAXIMA - TOPO_TEMPO) * 5.0f;
    }
}

void ParticulaCor(int lifetime, float y, float *r, float *g, float *b, float *a) {
    float altura_normalizada = y / ALTURA_MAXIMA_FOGO;
    float fator_altura = 1.0f - altura_normalizada;

    if (lifetime < TOPO_TEMPO) {
        float progress = (float)lifetime / TOPO_TEMPO;
        *r = 1.0f;
        *g = 1.0f - progress;
        *b = 0.0f;
        *a = 1.0f * fator_altura;
    } else if (lifetime < TEMPO_FADE) {
        *r = 1.0f;
        *g = 0.0f;
        *b = 0.0f;
        *a = 1.0f * fator_altura;
    } else {
        float progress = (float)(lifetime - TEMPO_FADE) / (VIDAMAXIMA - TEMPO_FADE);
        *r = 1.0f;
        *g = 0.0f;
        *b = 0.0f;
        *a = (1.0f - progress) * fator_altura;
    }
}

void InitParticle(int pause) {
    int i;

    if (pause)
        usleep(200000 + rand() % 2000000);

    for (i = 0; i < NUM_PARTICLES; i++) {
        float angle = (float)(rand() % 360) * 3.14 / 180.0f;
        float radius = FIRE_BASE_RADIUS * sqrt((float)rand() / RAND_MAX);
        float height = (float)rand() / RAND_MAX * 0.5f;

        particles[i].x = radius * cos(angle);
        particles[i].y = height;
        particles[i].z = radius * sin(angle);

        particles[i].veloc_x = (float)(rand() % 200 - 100) / 5000.0;
        particles[i].veloc_y = 0.02 + (float)(rand() % 200) / 5000.0;
        particles[i].veloc_z = (float)(rand() % 200 - 100) / 5000.0;

        particles[i].lifetime = rand() % VIDAMAXIMA;
    }
}

void InitGL(int Width, int Height) {
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClearDepth(1.0);
    glDepthFunc(GL_LESS);
    glEnable(GL_DEPTH_TEST);
    glShadeModel(GL_SMOOTH);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); // Mantem o blend para as particulas

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45.0f, (GLfloat)Width / (GLfloat)Height, 0.1f, 100.0f);

    glMatrixMode(GL_MODELVIEW);

    InitParticle(0);

    // Carrega a textura usando a função C
    if (!LoadBMPTexture("wood.bmp", &textureId)) { // Substitua "wood.bmp" pelo caminho da sua textura
        fprintf(stderr, "Falha ao carregar textura, saindo.\n");
        exit(1); // Sai se a textura não puder ser carregada
    }
    glEnable(GL_TEXTURE_2D); // Habilita o uso de texturas 2D
}

void ReSizeGLScene(int Width, int Height) {
    if (Height == 0)
        Height = 1;

    glViewport(0, 0, Width, Height);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

    gluPerspective(45.0f, (GLfloat)Width / (GLfloat)Height, 0.1f, 100.0f);
    glMatrixMode(GL_MODELVIEW);
}

void AddTurbulence(int i) {
    float turbulenceX = (float)(rand() % 200 - 100) / 20000.0;
    float turbulenceZ = (float)(rand() % 200 - 100) / 20000.0;
    particles[i].veloc_x += turbulenceX;
    particles[i].veloc_z += turbulenceZ;
}

void UpdateParticle(int i) {
    particles[i].veloc_y += GRAVITY;
    AddTurbulence(i);

    particles[i].x += particles[i].veloc_x;
    particles[i].y += particles[i].veloc_y;
    particles[i].z += particles[i].veloc_z;
    particles[i].lifetime--;

    if (particles[i].y > ALTURA_MAXIMA_FOGO || particles[i].lifetime <= 0) {
        float angle = (float)(rand() % 360) * 3.14 / 180.0f;
        float radius = FIRE_BASE_RADIUS * sqrt((float)rand() / RAND_MAX);
        float height = (float)rand() / RAND_MAX * 0.5f;

        particles[i].x = radius * cos(angle);
        particles[i].y = height;
        particles[i].z = radius * sin(angle);

        particles[i].veloc_x = (float)(rand() % 200 - 100) / 5000.0;
        particles[i].veloc_y = 0.02 + (float)(rand() % 200) / 5000.0;
        particles[i].veloc_z = (float)(rand() % 200 - 100) / 5000.0;
        particles[i].lifetime = rand() % VIDAMAXIMA;
    }
}

void DrawTexturedCylinder(GLUquadricObj *quadric, GLfloat radius, GLfloat height, GLint slices, GLint stacks) {

    gluQuadricTexture(quadric, GL_TRUE); // Gera coordenadas de textura automaticamente
    gluCylinder(quadric, radius, radius, height, slices, stacks);
    // Adicionar tampas texturizadas seria mais complexo (gluDisk com coords manuais)
}

void DrawGLScene() {
    GLUquadricObj *pObj;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();

    glTranslatef(0.0f, -1.5f, -6.0f);

    glRotatef(xRot, 1.0f, 0.0f, 0.0f);
    glRotatef(yRot, 0.0f, 1.0f, 0.0f);

    glEnable(GL_TEXTURE_2D); // Certifica-se que texturas estao ativas para os cilindros
    glBindTexture(GL_TEXTURE_2D, textureId); // Define qual textura usar
    glColor3f(1.0f, 1.0f, 1.0f);

    pObj = gluNewQuadric();
    gluQuadricNormals(pObj, GLU_SMOOTH);
    // Cilindro 1
    glPushMatrix(); 
    glTranslatef(0.0f, -0.1f, -0.5f); 
    DrawTexturedCylinder(pObj, 0.1f, 1.0f, 20, 10);
    glPopMatrix();

    // Cilindro 2
    glPushMatrix();
    glRotatef(90.0f, 0.0f, 1.0f, 0.0f);
    //glRotatef(-5.0f, 1.0f, 0.0f, 0.0f);
    glTranslatef(0.0f, -0.1f, -0.5f); 
    DrawTexturedCylinder(pObj, 0.1f, 1.0f, 20, 10);
    glPopMatrix();

    // Cilindro 3
    glPushMatrix();
    glRotatef(140.0f, 0.0f, 1.0f, 0.0f);  
    //glRotatef(-5.0f, 1.0f, 0.0f, 0.0f);
    glTranslatef(0.0f, -0.1f, -0.5f);
    DrawTexturedCylinder(pObj, 0.1f, 1.0f, 20, 10);
    glPopMatrix();


    // Cilindro 4
    glPushMatrix();
    glRotatef(230.0f, 0.0f, 1.0f, 0.0f);
    //glRotatef(-5.0f, 1.0f, 0.0f, 0.0f);
    glTranslatef(0.0f, -0.1f, -0.5f); 
    DrawTexturedCylinder(pObj, 0.1f, 1.0f, 20, 10);
    glPopMatrix();

    gluDeleteQuadric(pObj);

    // Desenha as Partículas de Fogo 
    glDisable(GL_TEXTURE_2D); // Desabilita texturas para as particulas (que são pontos coloridos)
    glEnable(GL_BLEND);       // blend estq ativo para as partículas

    int i;
    glBegin(GL_POINTS);
    
    for (i = 0; i < NUM_PARTICLES; i++) {
        UpdateParticle(i);
        if (particles[i].lifetime > 0) {
            float r, g, b, a;
            ParticulaCor(particles[i].lifetime, particles[i].y, &r, &g, &b, &a);
            glColor4f(r, g, b, a); // Define a cor e transparecia da particula

            glPointSize(calculateParticleSize(particles[i].lifetime)); // Define o tamanho

            glVertex3f(particles[i].x, particles[i].y, particles[i].z); // Desenha o ponto
        }
    }
    glEnd();


    glutSwapBuffers(); // Troca os buffers (double buffering)
    usleep(20000);     // Pequena pausa para controlar a velocidade da animação
}

void keyPressed(unsigned char key, int x, int y) {
    usleep(100); // Pequena pausa para evitar múltiplas detecções
    if (key == ESCAPE || key == 'q' || key == 'Q') { // Adiciona 'q' para sair
        glutDestroyWindow(window);
        exit(0);
    }
}

void specialKeys(int key, int x, int y) {
    if (key == GLUT_KEY_LEFT)
        yRot -= 5.0f;
    if (key == GLUT_KEY_RIGHT)
        yRot += 5.0f;
    if (key == GLUT_KEY_UP)
        xRot -= 5.0f;
    if (key == GLUT_KEY_DOWN)
        xRot += 5.0f;

    // if(xRot > 89.0f) xRot = 89.0f;
    // if(xRot < -89.0f) xRot = -89.0f;

    yRot = fmodf(yRot, 360.0f); 
    xRot = fmodf(xRot, 360.0f);

    glutPostRedisplay(); 
}

int main(int argc, char **argv) {
   
    srand(time(NULL)); 

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH);
    glutInitWindowSize(800, 600); 
    glutInitWindowPosition(100, 100); 
    window = glutCreateWindow("Fogo"); 
    
    glutDisplayFunc(DrawGLScene);
    glutIdleFunc(DrawGLScene); 
    
    glutReshapeFunc(ReSizeGLScene); 
    glutKeyboardFunc(keyPressed);
       
    glutSpecialFunc(specialKeys);

    InitGL(800, 600);

    glutMainLoop();

    return 0;
}