// gcc castelo.c -lglut -lGL -lGLU -lm -o castelo && ./castelo
 
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

    // Cilindro chão
    glColor3f(0.0f, 1.0f, 0.0f);  // Verde
    glPushMatrix();              // save transform matrix state
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.0f, 0.0f, 0.0f);
    glutSolidCylinder(2.0f, 0.55f, 20, 10);
    glPopMatrix(); // restore transform matrix state

    // Cubo cinza principal castelo
    glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
    glPushMatrix();              // save transform matrix state
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.0f, 0.0f, -0.5f);
    //glScalef(2.0f, 2.0f, 0.5f);
    glutSolidCube(1.5f);
    glPopMatrix(); // restore transform matrix state

    // Cubo cinza topo
    glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
    glPushMatrix();              // save transform matrix state
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.0f, 0.0f, -1.5f);
    //glScalef(2.0f, 2.0f, 0.5f);
    glutSolidCube(0.7f);
    glPopMatrix(); // restore transform matrix state

    // cilindro 1
    glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.7f, -0.7f, -0.5f);
    glutSolidCylinder(0.3f, 2.1f, 20, 10);
    glPopMatrix(); // restore transform matrix state
    

    // cilindro 2
    glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.7f, 0.7f, -0.5f);
    glutSolidCylinder(0.3f, 2.1f, 20, 10);
    glPopMatrix(); // restore transform matrix state
    

    // cilindro 3
    glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(-0.7f, 0.7f, -0.5f);
    glutSolidCylinder(0.3f, 2.1f, 20, 10);
    glPopMatrix(); // restore transform matrix state
    
    // cilindro 4
    glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(-0.7f, -0.7f, -0.5f);
    glutSolidCylinder(0.3f, 2.1f, 20, 10);
    glPopMatrix(); // restore transform matrix state
    

    // cone 1
    glColor3f(1.0f, 0.66f, 0.0f);  // Laranja
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(-0.7f, -0.7f, 1.5f);
    glutSolidCone(0.4f, 1.3f, 20, 10);
    glPopMatrix(); // restore transform matrix state
    
    // cone 2
    glColor3f(1.0f, 0.66f, 0.0f);  // Laranja
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.7f, -0.7f, 1.5f);
    glutSolidCone(0.4f, 1.3f, 20, 10);
    glPopMatrix(); // restore transform matrix state
    
    // cone 3
    glColor3f(1.0f, 0.66f, 0.0f);  // Laranja
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.7f, 0.7f, 1.5f);
    glutSolidCone(0.4f, 1.3f, 20, 10);
    glPopMatrix(); // restore transform matrix state

    // cone 4
    glColor3f(1.0f, 0.66f, 0.0f);  // Laranja
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(-0.7f, 0.7f, 1.5f);
    glutSolidCone(0.4f, 1.3f, 20, 10);
    glPopMatrix(); // restore transform matrix state
    
    // cone 5 meio do topo
    glColor3f(1.0f, 0.66f, 0.0f);  // Laranja
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.0f, 0.0f, 1.8f);
    glutSolidCone(0.55f, 1.3f, 20, 10);
    glPopMatrix(); // restore transform matrix state
    
    // cilindro embaixo do telhado central
    glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.0f, 0.0f, 1.7f);
    glutSolidCylinder(0.58f, 0.15f, 20, 10);
    glPopMatrix(); // restore transform matrix state

    // cilindro embaixo de um cone 1
    glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(-0.7f, 0.7f, 1.45f);
    glutSolidCylinder(0.4f, 0.15f, 20, 10);
    glPopMatrix(); // restore transform matrix state
    
    // cilindro embaixo de um cone 2
    glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.7f, 0.7f, 1.45f);
    glutSolidCylinder(0.4f, 0.15f, 20, 10);
    glPopMatrix(); // restore transform matrix state

    // cilindro embaixo de um cone 3
    glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(0.7f, -0.7f, 1.45f);
    glutSolidCylinder(0.4f, 0.15f, 20, 10);
    glPopMatrix(); // restore transform matrix state

    // cilindro embaixo de um cone 4
    glColor3f(0.5f, 0.5f, 0.5f);  // Cinza
    glPushMatrix();              // save transform matrix state
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 graus no eixo X
    glTranslatef(-0.7f, -0.7f, 1.45f);
    glutSolidCylinder(0.4f, 0.15f, 20, 10);
    glPopMatrix(); // restore transform matrix state
    
    //PORTAO
    glColor3f(0.58f, 0.29f, 0.0f);  // Marrom
    glPushMatrix();              // save transform matrix state
    glTranslatef(0.0f, 0.32f, 0.7f);
    glScalef(0.5f, 0.9f, 0.2f);
    glutSolidCube(0.7f);
    glPopMatrix(); // restore transform matrix state


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
    glutCreateWindow("Castelo");
    glutReshapeFunc(ChangeSize);
    glutSpecialFunc(SpecialKeys);
    glutDisplayFunc(RenderScene);
    SetupRC();
    glutMainLoop();

    return 0;
}
