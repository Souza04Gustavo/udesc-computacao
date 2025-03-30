#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <stdio.h>

void render()
{
    glClear(GL_COLOR_BUFFER_BIT); // Limpa a tela
    glBegin(GL_TRIANGLES);
    glColor3f(3.0f, 5.0f, 2.0f); // branco
    glVertex2f(-0.5f, -0.5f);    // Primeiro vértice
    glVertex2f(0.5f, -0.5f);     // Segundo vértice
    glVertex2f(0.0f, 0.7f);      // Terceiro vértice
    glEnd();

    glFlush(); // Garante que os comandos OpenGL são executados
}

int main()
{
    // inicia a glfw
    if (!glfwInit())
    {
        printf("Erro ao inicializar o GLFW!\n");
        return 0;
    }

    // cria uma janela
    GLFWwindow *window = glfwCreateWindow(400, 300, "Triângulo OpenGL", NULL, NULL);
    if (!window)
    {
        fprintf(stderr, "Erro ao criar janela\n");
        glfwTerminate();
        return -1;
    }

    // Define o contexto OpenGL
    glfwMakeContextCurrent(window);
    glewExperimental = GL_TRUE;
    if (glewInit() != GLEW_OK)
    {
        fprintf(stderr, "Erro ao inicializar GLEW\n");
        return -1;
    }

    // Loop principal
    while (!glfwWindowShouldClose(window))
    {
        render();                // Renderiza o triângulo
        glfwSwapBuffers(window); // Troca os buffers
        glfwPollEvents();        // Processa eventos
    }

    // Finaliza GLFW
    glfwDestroyWindow(window);
    glfwTerminate();
    return 0;
}