#include <GL/glut.h>

// Rotation
static GLfloat yRot = 0.0f;
static GLfloat xRot = 0.0f;

static GLfloat ombroEsq1 = 0.0f; // Rotação do cubo
static GLfloat ombroEsq2 = 0.0f; // Rotação do cubo
static GLfloat cotoEsq1 = 0.0f; // Rotação do cubo
static GLfloat cotoEsq2 = 0.0f; // Rotação do cubo

static GLfloat cabeca1 = 0.0f; // Rotação do cubo
static GLfloat cabeca2 = 0.0f; // Rotação do cubo

static GLfloat pernas = 0.0f; // Rotação do cubo

static GLfloat joelho = 0.0f; // Rotação do cubo


// Change viewing volume and viewport. Called when window is resized
void ChangeSize(int w, int h)
{
    GLfloat fAspect;
    if (h == 0) h = 1;
    glViewport(0, 0, w, h);
    fAspect = (GLfloat)w / (GLfloat)h;
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(35.0f, fAspect, 1.0, 40.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

// Initialization
void SetupRC()
{
    GLfloat whiteLight[] = {0.05f, 0.05f, 0.05f, 1.0f};
    GLfloat sourceLight[] = {0.25f, 0.25f, 0.25f, 1.0f};
    GLfloat lightPos[] = {-10.f, 5.0f, 5.0f, 1.0f};

    glEnable(GL_DEPTH_TEST);
    glFrontFace(GL_CCW);
    glEnable(GL_CULL_FACE);
    glEnable(GL_LIGHTING);
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, whiteLight);
    glLightfv(GL_LIGHT0, GL_AMBIENT, sourceLight);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, sourceLight);
    glLightfv(GL_LIGHT0, GL_POSITION, lightPos);
    glEnable(GL_LIGHT0);
    glEnable(GL_COLOR_MATERIAL);
    glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);
    glClearColor(0.25f, 0.25f, 0.50f, 1.0f);
}

// Respond to keys (rotate snowman or cube)
void SpecialKeys(int key, int x, int y)
{
    if (key == GLUT_KEY_LEFT) yRot -= 1.0f;
    if (key == GLUT_KEY_RIGHT) yRot += 1.0f;
    if (key == GLUT_KEY_UP) xRot -= 1.0f;
    if (key == GLUT_KEY_DOWN) xRot += 1.0f;

    // ombro direito
    if (key == GLUT_KEY_F1) ombroEsq1 -= 5.0f;
    if (key == GLUT_KEY_F2) ombroEsq1 += 5.0f;
    if (key == GLUT_KEY_F3) ombroEsq2 -= 5.0f;
    if (key == GLUT_KEY_F4) ombroEsq2 += 5.0f;

    // cotovelo direito
    if (key == GLUT_KEY_F5) cotoEsq1 -= 5.0f;
    if (key == GLUT_KEY_F6) cotoEsq1 += 5.0f;
    if (key == GLUT_KEY_F7) cotoEsq2 -= 5.0f;
    if (key == GLUT_KEY_F8) cotoEsq2 += 5.0f;

    // cabeca
    if (key == GLUT_KEY_F9) cabeca1 -= 5.0f;
    if (key == GLUT_KEY_F10) cabeca1 += 5.0f;
    if (key == GLUT_KEY_F11) cabeca2 -= 5.0f;
    if (key == GLUT_KEY_F12) cabeca2 += 5.0f;

    if (key == GLUT_KEY_PAGE_UP) pernas -= 5.0f;
    if (key == GLUT_KEY_PAGE_DOWN) pernas += 5.0f;

    if (key == GLUT_KEY_END) joelho -= 5.0f;
    if (key == GLUT_KEY_HOME) joelho += 5.0f;


    yRot = (GLfloat)((const int)yRot % 360);
    xRot = (GLfloat)((const int)xRot % 360);
    ombroEsq1 = (GLfloat)((const int)ombroEsq1 % 360);
    ombroEsq2 = (GLfloat)((const int)ombroEsq2 % 360);
    cotoEsq1 = (GLfloat)((const int)cotoEsq1 % 360);
    cotoEsq2 = (GLfloat)((const int)cotoEsq2 % 360);
    
    cabeca1 = (GLfloat)((const int)cabeca1 % 360);
    cabeca2 = (GLfloat)((const int)cabeca2 % 360);
    
    pernas = (GLfloat)((const int)pernas % 360);
    pernas = (GLfloat)((const int)pernas % 360);
    
    joelho = (GLfloat)((const int)joelho % 360);
    joelho = (GLfloat)((const int)joelho % 360);
   



    glutPostRedisplay();
}

// Called to draw scene
void RenderScene(void)
{
    GLUquadricObj *pObj;
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glPushMatrix();
    glTranslatef(0.0f, 0.5f, -5.0f);
    glRotatef(yRot, 0.0f, 1.0f, 0.0f);
    glRotatef(xRot, 1.0f, 0.0f, 0.0f);

    pObj = gluNewQuadric();
    gluQuadricNormals(pObj, GLU_SMOOTH);

    // braco esquerdo
    //glColor3f(1.0f, 1.0f, 1.0f);  // Branco
    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glPushMatrix();
    glTranslatef(0.0f, 0.0f, 0.0f);
    
    glRotatef(ombroEsq1, 0.0f, 1.0f, 0.0f);
    glRotatef(ombroEsq2, 1.0f, 0.0f, 0.0f); 

    gluSphere(pObj, 0.3f, 50, 13);  // ombro
    
    glColor3f(1.0f, 1.0f, 1.0f);  // Branco
    glTranslatef(0.1f, 0.0f, 0.0f);
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); 
    glutSolidCylinder(0.16f, 0.8f, 20, 10); // biceps

    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glTranslatef(0.0f, 0.0f, 0.8f);
    gluSphere(pObj, 0.2f, 50, 13);  // cotovelo

    glRotatef(cotoEsq1, 0.0f, 1.0f, 0.0f);
    glRotatef(cotoEsq2, 1.0f, 0.0f, 0.0f); 


    glColor3f(1.0f, 1.0f, 1.0f);  // Branco
    glRotatef(90.0f, 0.0f, 0.0f, 0.0f); 
    glTranslatef(0.0f, 0.0f, 0.0f);
    glutSolidCylinder(0.1f, 0.8f, 20, 10); // antebraco

    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glScalef(0.5f, 1.0f, 1.3f);
    glTranslatef(0.0f, 0.0f, 0.7f);
    glutSolidCube(0.4f); // mao

    glPopMatrix();
    // fim do braco esquerdo


    // braco direito
    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glPushMatrix();
    glTranslatef(-0.9f, 0.0f, 0.0f);
    glRotatef(180.0f, 0.0f, 1.0f, 0.0f); 
    
    glRotatef(ombroEsq1, 0.0f, 1.0f, 0.0f);
    glRotatef(ombroEsq2, 1.0f, 0.0f, 0.0f); 

    gluSphere(pObj, 0.3f, 50, 13);  // ombro
    
    glColor3f(1.0f, 1.0f, 1.0f);  // Branco
    glTranslatef(0.1f, 0.0f, 0.0f);
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); 
    glutSolidCylinder(0.16f, 0.8f, 20, 10); // biceps

    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glTranslatef(0.0f, 0.0f, 0.8f);
    gluSphere(pObj, 0.2f, 50, 13);  // cotovelo

    glColor3f(1.0f, 1.0f, 1.0f);  // Branco
    glRotatef(cotoEsq1, 0.0f, 1.0f, 0.0f);
    glRotatef(cotoEsq2, 1.0f, 0.0f, 0.0f); 

    glRotatef(90.0f, 0.0f, 0.0f, 0.0f); 
    glTranslatef(0.0f, 0.0f, 0.0f);
    glutSolidCylinder(0.1f, 0.8f, 20, 10); // antebraco

    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glScalef(0.5f, 1.0f, 1.3f);
    glTranslatef(0.0f, 0.0f, 0.7f);
    glutSolidCube(0.4f); // mao

    glPopMatrix();
    // fim do braco direito


    // Corpo do boneco (permanece fixo)
    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glPushMatrix();

    glRotatef(-90.0f, 0.0f, 1.0f, 0.0f); // Rotaciona o cilindro 90 
    glutSolidCylinder(0.3f, 0.9f, 20, 10);
    
    glTranslatef(0.0f, -0.3f, 0.05f);
    glRotatef(-90.0f, 0.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 
    glutSolidCylinder(0.2f, 0.8f, 20, 10);

    glScalef(0.5f, 1.0f, 1.0f);
    glTranslatef(0.0f, -0.25f, 0.4f);
    glutSolidCube(0.7f); // torso
    
    glScalef(1.0f, 0.5f, 0.5f);
    glTranslatef(0.0f, -0.8f, 0.0f);
    glutSolidCube(0.7f); // inferior entre pernas
   

    glPopMatrix();


    // pescoco

    glColor3f(1.0f, 1.0f, 1.0f);  // Branco
    glPushMatrix();
    glRotatef(-90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 
    glTranslatef(-0.4f, 0.0f, 0.2f);
    glutSolidCylinder(0.15f, 0.3f, 20, 10);

    //cabeca
    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glScalef(1.0f, 1.0f, 0.9f);
    glTranslatef(0.0f, 0.0f, 0.4f);
    gluSphere(pObj, 0.3f, 50, 13);

    glRotatef(cabeca1, 0.0f, 0.0f, 1.0f);
    glRotatef(cabeca2, 1.0f, 0.0f, 0.0f); 

    //olhos
    glColor3f(1.0f, 1.0f, 1.0f);  // Branco
    glTranslatef(0.1f, 0.0f, 0.0f);
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); // Rotaciona o cilindro 90 
    glutSolidCylinder(0.1f, 0.3f, 20, 10);
   
    glTranslatef(-0.2f, 0.0f, 0.0f);
    glutSolidCylinder(0.1f, 0.3f, 20, 10);
    glPopMatrix();
    
    
    //perna esquerda
    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glPushMatrix();
    glTranslatef(-0.25f, -1.0f, 0.0f);
    gluSphere(pObj, 0.23f, 50, 13);
        
    glRotatef(pernas, 1.0f, 0.0f, 0.0f); 


    glColor3f(1.0f, 1.0f, 1.0f);  // Branco
    glTranslatef(0.05f, 0.0f, 0.0f);
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); 
    glutSolidCylinder(0.15f, 0.8f, 20, 10); // coxa


    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glTranslatef(0.0f, 0.0f, 0.8f);
    gluSphere(pObj, 0.2f, 50, 13);  // joelho

    glRotatef(joelho, 1.0f, 0.0f, 0.0f); 


    glTranslatef(0.0f, 0.0f, 0.0f);
    glutSolidCylinder(0.20f, 0.8f, 20, 10); // coxa

    glScalef(1.0f, 1.7f, 0.5f);
    glTranslatef(0.0f, 0.05f, 1.5f);
    glutSolidCube(0.4f); // pe
    glPopMatrix();

    //perna direita
    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glPushMatrix();
    glTranslatef(-0.65f, -1.0f, 0.0f);
    gluSphere(pObj, 0.23f, 50, 13);
        
    
    glColor3f(1.0f, 1.0f, 1.0f);  // Branco
    glRotatef(pernas, 1.0f, 0.0f, 0.0f); 

    glTranslatef(-0.05f, 0.0f, 0.0f);
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f); 
    glutSolidCylinder(0.15f, 0.8f, 20, 10); // coxa


    glColor3f(1.0f, 0.0f, 0.0f);  // Vermelho
    glTranslatef(0.0f, 0.0f, 0.8f);
    gluSphere(pObj, 0.2f, 50, 13);  // joelho

    glRotatef(joelho, 1.0f, 0.0f, 0.0f); 

    glTranslatef(0.0f, 0.0f, 0.0f);
    glutSolidCylinder(0.20f, 0.8f, 20, 10); // coxa

    glScalef(1.0f, 1.7f, 0.5f);
    glTranslatef(0.0f, 0.05f, 1.5f);
    glutSolidCube(0.4f); // pe
    glPopMatrix();
    


    glPopMatrix();
    

    
    
    glPopMatrix();
    glutSwapBuffers();


}

int main(int argc, char *argv[])
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(800, 600);
    glutCreateWindow("Robo Humanoide");
    glutReshapeFunc(ChangeSize);
    glutSpecialFunc(SpecialKeys);
    glutDisplayFunc(RenderScene);
    SetupRC();
    glutMainLoop();
    return 0;
}
