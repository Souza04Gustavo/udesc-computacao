// gcc fireworks_glut.c -lglut -lGL -lGLU -lm -o fireworks_glut
#include <GL/glut.h> // Header File For The GLUT Library
#include <GL/gl.h>   // Header File For The OpenGL32 Library
#include <GL/glu.h>  // Header File For The GLu32 Library
#include <math.h>
#include <unistd.h>
#include <time.h>

#define ESCAPE 300
#define NUM_PARTICLES 7000
#define GRAVITY -0.000000001

#define VIDAMAXIMA 5
#define TOPO_TEMPO (VIDAMAXIMA * 0.1)
#define TEMPO_FADE (VIDAMAXIMA * 0.8)
#define ALTURA_MAXIMA_FOGO 2.0f

// Rotation
static GLfloat yRot = 0.0f;
static GLfloat xRot = 0.0f; // Rotação vertical (cima/baixo)

struct s_pf
{
    float x, y, z, veloc_x, veloc_y, veloc_z;
    unsigned lifetime;
} particles[NUM_PARTICLES];

int window;

float calculateParticleSize(int lifetime)
{
    if (lifetime < TOPO_TEMPO)
    {
        // Aumenta o tamanho durante a evolução
        return 1.0f + (float)lifetime / TOPO_TEMPO * 4.0f; // Exemplo: de 1.0 a 5.0
    }
    else
    {
        // Diminui o tamanho durante o esvaecimento
        return 5.0f - (float)(lifetime - TOPO_TEMPO) / (VIDAMAXIMA - TOPO_TEMPO) * 5.0f; // Exemplo: de 5.0 a 0.0
    }
}

void ParticulaCor(int lifetime, float *r, float *g, float *b, float *a)
{
    if (lifetime < TOPO_TEMPO)
    {
        // Evolução: amarelo -> laranja -> vermelho
        float progress = (float)lifetime / TOPO_TEMPO;
        *r = 1.0f;
        *g = 1.0f - progress; // Amarelo -> Laranja
        *b = 0.0f;
        *a = 1.0f; // Opacidade total
    }
    else if (lifetime < TEMPO_FADE)
    {
        // Vermelho constante
        *r = 1.0f;
        *g = 0.0f;
        *b = 0.0f;
        *a = 1.0f;
    }
    else
    {
        // Esvaecimento: diminui a opacidade
        float progress = (float)(lifetime - TEMPO_FADE) / (VIDAMAXIMA - TEMPO_FADE);
        *r = 1.0f;
        *g = 0.0f;
        *b = 0.0f;
        *a = 1.0f - progress; // Diminui a opacidade
    }
}

// Initialize the firework
void InitParticle(int pause)
{
    int i;

    if (pause)
        usleep(200000 + rand() % 2000000);

    for (i = 0; i < NUM_PARTICLES; i++)
    {
        float velocity = (float)(rand() % 100) / 500.0;
        //int angle = rand() % 360;
        particles[i].veloc_x = 0.02 + (float)(rand() % 200) / 1000.0;
        particles[i].veloc_y = (float)(rand() % 200) / 1000.0;
        particles[i].veloc_z = 0.0;

        particles[i].x = (float)(rand() % 200 - 100) / 1000.0; // varia o ponto inicial para espalhar mais o fogo
        particles[i].y = (float)(rand() % 200 - 100) / 1000.0;
        particles[i].z = 0.0; // revisar

        particles[i].lifetime = rand() % 100;
    }
}

/* A general OpenGL initialization function.  Sets all of the initial parameters. */
void InitGL(int Width, int Height)
{
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f); // This Will Clear The Background Color To Black
    glClearDepth(1.0);                    // Enables Clearing Of The Depth Buffer
    glDepthFunc(GL_LESS);                 // The Type Of Depth Test To Do
    glEnable(GL_DEPTH_TEST);              // Enables Depth Testing
    glShadeModel(GL_SMOOTH);              // Enables Smooth Color Shading

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity(); // Reset The Projection Matrix

    gluPerspective(45.0f, (GLfloat)Width / (GLfloat)Height, 0.1f, 100.0f); // Calculate The Aspect Ratio Of The Window

    glMatrixMode(GL_MODELVIEW);

    InitParticle(0); // first firework
}

/* The function called when our window is resized (which shouldn't happen, because we're fullscreen) */
void ReSizeGLScene(int Width, int Height)
{
    if (Height == 0) // Prevent A Divide By Zero If The Window Is Too Small
        Height = 1;

    glViewport(0, 0, Width, Height); // Reset The Current Viewport And Perspective Transformation

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

    gluPerspective(45.0f, (GLfloat)Width / (GLfloat)Height, 0.1f, 100.0f);
    glMatrixMode(GL_MODELVIEW);
}


void UpdateParticle(int i) {
    if (particles[i].lifetime > 0) {
        // Atualiza a posição
        particles[i].veloc_y -= GRAVITY;
        particles[i].x += particles[i].veloc_x;
        particles[i].y += particles[i].veloc_y;
        particles[i].z += particles[i].veloc_z;

        // Verificação da altura máxima
        if (particles[i].y > ALTURA_MAXIMA_FOGO) {
           particles[i].veloc_y = - particles[i].veloc_y;
        }

        particles[i].lifetime--; // Decrementa o tempo de vida
    } else {
        // Reinicializa a partícula
        particles[i].veloc_x = (float)(rand() % 200 - 100) / 10000.0;
        particles[i].veloc_y = 0.02 + (float)(rand() % 100) / 5000.0;
        particles[i].veloc_z = (float)(rand() % 200 - 100) / 10000.0;

        particles[i].x = (float)(rand() % 200 - 100) / 500.0;
        particles[i].y = (float)(rand() % 200 - 100) / 500.0;
        particles[i].z = 0.0;

        particles[i].lifetime = VIDAMAXIMA + rand() % 200;
    }
}


//versao nova
void DrawGLScene()
{

    GLUquadricObj *pObj; // Quadric Object

    
    int i, ative_particles = 0;
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // Clear The Screen And The Depth Buffer
    glLoadIdentity();                                   // Reset The View

    glTranslatef(0.0f, -1.5f, -6.0f); // Move particles 6.0 units into the screen

    glRotatef(xRot, 1.0f, 0.0f, 0.0f);
    glRotatef(yRot, 0.0f, 1.0f, 0.0f);

    glPushMatrix();

    // Draw something
    pObj = gluNewQuadric();
    gluQuadricNormals(pObj, GLU_SMOOTH);
    
   
    // Cilindro tronco

    glColor3f(0.4f, 0.26f, 0.13f);    
    glPushMatrix();              
    //glRotatef(90.0f, 1.0f, 0.0f, 0.0f);
    glTranslatef(0.0f, -0.2f, -0.3f);
    glutSolidCylinder(0.1f, 0.5f, 20, 10);
    glPopMatrix(); // restore transform matrix stat 

    glColor3f(0.4f, 0.26f, 0.13f); 
    glPushMatrix();              
    glRotatef(90.0f, 0.0f, 1.0f, 0.0f);
    glTranslatef(0.05f, -0.2f, -0.25f);
    glutSolidCylinder(0.1f, 0.5f, 20, 10);
    glPopMatrix(); // restore transform matrix stat 


    glBegin(GL_POINTS);
    for (i = 0; i < NUM_PARTICLES; i++)
    {
        UpdateParticle(i);
        if (particles[i].lifetime > 0)
        {
            
            /*ative_particles++;
            particles[i].veloc_y -= GRAVITY;
            // particles[i].x += particles[i].veloc_x;
            particles[i].y += particles[i].veloc_y;
            particles[i].lifetime--;
            */

            float r, g, b, a;
            ParticulaCor(particles[i].lifetime, &r, &g, &b, &a);
            glColor4f(r, g, b, a);

            glPointSize(calculateParticleSize(particles[i].lifetime));

            glVertex3f(particles[i].x, particles[i].y, particles[i].z); // draw pixel
        }
    }
    glEnd();

    // swap buffers to display, since we're double buffered.
    glutSwapBuffers();
    usleep(20000);

    //if (!ative_particles)
        //InitParticle(1); // reset particles

    
}


/* The function called whenever a key is pressed. */
void keyPressed(unsigned char key, int x, int y)
{

    if (key == ESCAPE)
    {
        glutDestroyWindow(window);

        exit(0);
    }
}

void specialKeys(int key, int x, int y)
{
    if (key == GLUT_KEY_LEFT)
        yRot -= 5.0f;

    if (key == GLUT_KEY_RIGHT)
        yRot += 5.0f;

    if (key == GLUT_KEY_UP) // Rotação para cima
        xRot -= 5.0f;

    if (key == GLUT_KEY_DOWN) // Rotação para baixo
        xRot += 5.0f;

    yRot = (GLfloat)((const int)yRot % 360);
    xRot = (GLfloat)((const int)xRot % 360);

    glutPostRedisplay();
}

int main(int argc, char **argv)
{
    srand(time(NULL));
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH);
    glutInitWindowSize(640, 480);
    glutInitWindowPosition(0, 0);
    window = glutCreateWindow("Fogo");
    glutDisplayFunc(&DrawGLScene);
    glutFullScreen();
    glutIdleFunc(&DrawGLScene);
    glutReshapeFunc(&ReSizeGLScene);
    glutSpecialFunc(&specialKeys);
    // glutKEFunc(&specialKeys);
    InitGL(640, 480);
    glutMainLoop();

    return 0;
}
