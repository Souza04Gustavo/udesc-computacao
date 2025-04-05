// gcc snowman_sample.c -lglut -lGL -lGLU -lm -o snowman && ./snowman
 
/*  // CORES
glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
glColor3f(0.0f, 1.0f, 0.0f);  // Verde
glColor3f(0.0f, 0.0f, 1.0f);  // Azul
glColor3f(1.0f, 1.0f, 1.0f);  // Branco
glColor3f(1.0f, 1.0f, 0.0f);  // Amarelo
glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
*/

#include <GL/glut.h>

// Rotation
static GLfloat yRot = 0.0f;
static GLfloat xRot = 0.0f;  // Rotação vertical (cima/baixo)

// Change viewing volume and viewport.  Called when window is resized
void ChangeSize(int w, int h)
{
    GLfloat fAspect;

    // Prevent a divide by zero
    if (h == 0)
        h = 1;

    // Set Viewport to window dimensions
    glViewport(0, 0, w, h);

    fAspect = (GLfloat)w / (GLfloat)h;

    // Reset coordinate system
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

    // Produce the perspective projection
    gluPerspective(35.0f, fAspect, 1.0, 40.0);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

// This function does any needed initialization on the rendering context.  Here it sets up and initializes the lighting for the scene.
void SetupRC()
{

    // Light values and coordinates
    GLfloat whiteLight[] = {0.05f, 0.05f, 0.05f, 1.0f};
    GLfloat sourceLight[] = {0.25f, 0.25f, 0.25f, 1.0f};
    GLfloat lightPos[] = {-10.f, 5.0f, 5.0f, 1.0f};

    glEnable(GL_DEPTH_TEST); // Hidden surface removal
    glFrontFace(GL_CCW);     // Counter clock-wise polygons face out
    glEnable(GL_CULL_FACE);  // Do not calculate inside

    // Enable lighting
    glEnable(GL_LIGHTING);

    // Setup and enable light 0
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, whiteLight);
    glLightfv(GL_LIGHT0, GL_AMBIENT, sourceLight);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, sourceLight);
    glLightfv(GL_LIGHT0, GL_POSITION, lightPos);
    glEnable(GL_LIGHT0);

    // Enable color tracking
    glEnable(GL_COLOR_MATERIAL);

    // Set Material properties to follow glColor values
    glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);

    // Black blue background
    glClearColor(0.25f, 0.25f, 0.50f, 1.0f);
}

// Respond to arrow keys (rotate snowman)
void SpecialKeys(int key, int x, int y)
{

    if (key == GLUT_KEY_LEFT)
        yRot -= 5.0f;

    if (key == GLUT_KEY_RIGHT)
        yRot += 5.0f;

       if (key == GLUT_KEY_UP)  // Rotação para cima
        xRot -= 5.0f;

    if (key == GLUT_KEY_DOWN)  // Rotação para baixo
        xRot += 5.0f;

    yRot = (GLfloat)((const int)yRot % 360);
    xRot = (GLfloat)((const int)xRot % 360);

    // Refresh the Window
    glutPostRedisplay();
}

// Called to draw scene
void RenderScene(void)
{

    GLUquadricObj *pObj; // Quadric Object

    // Clear the window with current clearing color
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // Save the matrix state and do the rotations
    glPushMatrix();

    // Move object back and do in place rotation
    glTranslatef(0.0f, -0.5f, -5.0f); // posicao inicial da camera
    glRotatef(yRot, 0.0f, 1.0f, 0.0f);
    glRotatef(xRot, 1.0f, 0.0f, 0.0f);

    // Draw something
    pObj = gluNewQuadric();
    gluQuadricNormals(pObj, GLU_SMOOTH);

    // white
    glColor3f(1.0f, 1.0f, 1.0f);

    // corpo parte 1
    glPushMatrix(); // save transform matrix state
    glTranslatef(0.0f, 0.5f, 0.0f);
    gluSphere(pObj, 0.35f, 40, 20);
    glPopMatrix(); // restore transform matrix state

    // corpo parte 2
    glPushMatrix(); // save transform matrix state
    glTranslatef(0.0f, -0.2f, 0.0f);
    gluSphere(pObj, 0.5f, 40, 20);
    glPopMatrix(); // restore transform matrix state

    // Head
    glPushMatrix(); // save transform matrix state
    glTranslatef(0.0f, 1.0f, 0.0f);
    gluSphere(pObj, 0.24f, 26, 13);
    glPopMatrix(); // restore transform matrix state

    // olhos
    glColor3f(0.0f, 0.0f, 0.0f); // preto
    glPushMatrix();              // save transform matrix state
    glTranslatef(0.1f, 1.05f, 0.22f);
    gluSphere(pObj, 0.03f, 50, 13);
    glPopMatrix(); // restore transform matrix state

    glPushMatrix(); // save transform matrix state
    glTranslatef(-0.1f, 1.05f, 0.22f);
    gluSphere(pObj, 0.03f, 50, 13);
    glPopMatrix(); // restore transform matrix state

    // botao 1
    glColor3f(0.5f, 0.5f, 0.5f); // Cinza
    glPushMatrix();              // save transform matrix state
    glTranslatef(0.0f, 0.7f, 0.28f);
    gluSphere(pObj, 0.03f, 50, 13);
    glPopMatrix(); // restore transform matrix state

    // botao 2
    glPushMatrix(); // save transform matrix state
    glTranslatef(0.0f, 0.52f, 0.34f);
    gluSphere(pObj, 0.03f, 50, 13);
    glPopMatrix(); // restore transform matrix state

    // botao 3
    glPushMatrix(); // save transform matrix state
    glTranslatef(0.0f, 0.32f, 0.3f);
    gluSphere(pObj, 0.03f, 50, 13);
    glPopMatrix(); // restore transform matrix state

    // Nose (orange)
    glColor3f(1.0f, 0.4f, 0.51f);
    glPushMatrix();
    glTranslatef(0.0f, 1.0f, 0.2f);
    gluCylinder(pObj, 0.04f, 0.0f, 0.3f, 26, 13);
    glPopMatrix();

    // chão cilindro
    glPushMatrix();
    //glColor3f(0.0f, 1.0f, 0.0f);  // Verde
    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.0f, 0.0f, 0.4f); // Posiciona no espaço
    gluCylinder(pObj, 1.0f, 1.25f, 0.3f, 20, 10); //1-Circ 2-Circ 3-altura
    glPopMatrix();

    // chão disco 1 (superior)
    glPushMatrix();
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o disco 90 graus no 
    glTranslatef(0.0f, 0.0f, -0.4f);   // Posiciona no espaço
    gluDisk(pObj, 0.0f, 1.0f, 20, 1); // Tampa inferior
    glPopMatrix();

    // chão disco 2 (baixo)
    glPushMatrix();
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o disco 90 graus no 
    glTranslatef(0.0f, 0.0f, 0.7f);   // Posiciona no espaço
    gluDisk(pObj, 0.0f, 1.25f, 20, 1); // Tampa inferior
    glPopMatrix();

    // aba chapeu
    glPushMatrix();
    glColor3f(0.0f, 0.0f, 0.0f);  // preto
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.0f, 0.0f, -1.25f); // Posiciona no espaço
    gluCylinder(pObj, 0.3f, 0.3f, 0.08f, 20, 10); //1-Circ 2-Circ 3-altura
    glPopMatrix();

    // chapeu disco 1 (inferior)
    glPushMatrix();
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o disco 90 graus no 
    glTranslatef(0.0f, 0.0f, -1.17f);   // Posiciona no espaço
    gluDisk(pObj, 0.0f, 0.3f, 20, 1); // Tampa inferior
    glPopMatrix();

    // chapeu disco 1 (superior)
    glPushMatrix();
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o disco 90 graus no 
    glTranslatef(0.0f, 0.0f, 1.25f);   // Posiciona no espaço
    gluDisk(pObj, 0.0f, 0.3f, 20, 1); // Tampa inferior
    glPopMatrix();

    // cilindro chapeu
    glPushMatrix();
    glColor3f(0.0f, 0.0f, 0.0f);  // preto
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.0f, 0.0f, 1.25f); // Posiciona no espaço
    gluCylinder(pObj, 0.2f, 0.2f, 0.4f, 20, 10); //1-Circ 2-Circ 3-altura
    glPopMatrix();
    
    // chapeu disco topo 
    glPushMatrix();
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o disco 90 graus no 
    glTranslatef(0.0f, 0.0f, 1.65f);   // Posiciona no espaço
    gluDisk(pObj, 0.0f, 0.2f, 20, 1); // Tampa inferior
    glPopMatrix();

    // braco cilindro principal
    glPushMatrix();
    glColor3f(0.0f, 0.0f, 0.0f);  // preto
    glRotatef(80.0f, 1.0f, 5.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.0f, 0.5f, -0.9f); // Posiciona no espaço
    gluCylinder(pObj, 0.01f, 0.05f, 0.75f, 20, 10); //1-Circ 2-Circ 3-altura
    glPopMatrix();

    // braco cilindro principal
    glPushMatrix();
    glColor3f(0.0f, 0.0f, 0.0f);  // preto
    glRotatef(80.0f, 1.0f, -5.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.0f, 0.5f, -0.9f); // Posiciona no espaço
    gluCylinder(pObj, 0.01f, 0.05f, 0.75f, 20, 10); //1-Circ 2-Circ 3-altura
    glPopMatrix();

    // Restore the matrix state
    glPopMatrix();

    // Buffer swap
    glutSwapBuffers();
}

int main(int argc, char *argv[])
{

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(800, 600);
    glutCreateWindow("Boneco de Neve");
    glutReshapeFunc(ChangeSize);
    glutSpecialFunc(SpecialKeys);
    glutDisplayFunc(RenderScene);
    SetupRC();
    glutMainLoop();

    return 0;
}
