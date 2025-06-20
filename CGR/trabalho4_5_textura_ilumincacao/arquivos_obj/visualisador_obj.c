// para compilar e executar:
// gcc visualisador_obj.c -o visualisador_obj -lglut -lGL -lGLU -lm -I.
// ./visualisador_obj
#include <GL/glut.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h> // Para fmodf

// --- Definição para STB_IMAGE ---
// Coloque isso ANTES do #include "stb_image.h"
// E faça isso em APENAS UM arquivo .c do seu projeto (neste caso, este aqui)
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
// ---------------------------------

// --- Estruturas para o Modelo ---
typedef struct {
    float x, y, z;
} Vec3f;

typedef struct {
    float u, v;
} Vec2f;

typedef struct {
    int v_idx[3];  // Índices para vértices (posição)
    int vt_idx[3]; // Índices para coordenadas de textura
    int vn_idx[3]; // Índices para normais
} Face;

typedef struct {
    Vec3f *vertices;
    Vec2f *texcoords;
    Vec3f *normals;
    Face *faces;

    int num_vertices;
    int num_texcoords;
    int num_normals;
    int num_faces;

    GLuint texture_id;
    char texture_filename[256];
} Model;

Model g_model; // Modelo global

// --- Variáveis Globais de Controle ---
static GLfloat g_yRot = 0.0f;
static GLfloat g_xRot = 0.0f;
static GLfloat g_zoom = -5.0f; // Distância da câmera
int g_last_mouse_x = 0;
int g_last_mouse_y = 0;
int g_mouse_buttons[3] = {0}; // Left, Middle, Right

// --- Protótipos de Funções ---
void InitGL(int Width, int Height);
void ReSizeGLScene(int Width, int Height);
void DrawGLScene(void);
void keyPressed(unsigned char key, int x, int y);
void specialKeys(int key, int x, int y);
void mouseButton(int button, int state, int x, int y);
void mouseMotion(int x, int y);

int LoadTexture(const char *filename, GLuint *textureID);
int LoadMTL(const char *mtl_filename, char *texture_filename_out, int max_len);
int LoadOBJ(const char *obj_filename, Model *model);
void FreeModel(Model *model);
void DrawModel(Model *model);


// --- Função Principal ---
int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <caminho_para_seu_arquivo.obj>\n", argv[0]);
        return 1;
    }

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH);
    glutInitWindowSize(800, 600);
    glutInitWindowPosition(100, 100);
    glutCreateWindow("Visualizador OBJ Simples");

    glutDisplayFunc(DrawGLScene);
    glutIdleFunc(DrawGLScene); // Para animação contínua se necessário, ou redesenhar
    glutReshapeFunc(ReSizeGLScene);
    glutKeyboardFunc(keyPressed);
    glutSpecialFunc(specialKeys);
    glutMouseFunc(mouseButton);
    glutMotionFunc(mouseMotion);

    InitGL(800, 600);

    // Carregar o modelo OBJ passado como argumento
    if (!LoadOBJ(argv[1], &g_model)) {
        fprintf(stderr, "Erro ao carregar o modelo OBJ: %s\n", argv[1]);
        FreeModel(&g_model); // Tenta limpar o que pode ter sido alocado
        return 1;
    }

    glutMainLoop();

    FreeModel(&g_model); // Limpar recursos ao sair
    return 0;
}

// --- Implementação das Funções ---

void InitGL(int Width, int Height) {
    glClearColor(0.2f, 0.2f, 0.3f, 0.0f); // Cor de fundo
    glClearDepth(1.0);
    glDepthFunc(GL_LESS);
    glEnable(GL_DEPTH_TEST);
    glShadeModel(GL_SMOOTH); // Sombreamento suave

    // Habilitar e configurar iluminação
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0); // Habilitar luz 0
    glEnable(GL_NORMALIZE); // Normaliza as normais após transformações (útil com glScale)

    GLfloat light_ambient[] = {0.3f, 0.3f, 0.3f, 1.0f}; // Luz ambiente fraca
    GLfloat light_diffuse[] = {0.8f, 0.8f, 0.8f, 1.0f}; // Luz difusa principal
    GLfloat light_specular[] = {0.6f, 0.6f, 0.6f, 1.0f}; // Brilho especular
    GLfloat light_position[] = {5.0f, 5.0f, 5.0f, 0.0f}; // Luz direcional (w=0) vinda de cima/direita/frente

    glLightfv(GL_LIGHT0, GL_AMBIENT, light_ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light_diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular);
    // Posição da luz é definida no espaço do mundo antes das transformações do modelo
    // Para mantê-la fixa em relação à câmera, defina após glLoadIdentity em DrawGLScene

    // Propriedades do material (globais, podem ser sobrescritas por OBJ/MTL, mas aqui são base)
    GLfloat mat_ambient[] = {0.8f, 0.8f, 0.8f, 1.0f};
    GLfloat mat_diffuse[] = {0.8f, 0.8f, 0.8f, 1.0f}; // A cor da textura será modulada com esta
    GLfloat mat_specular[] = {0.2f, 0.2f, 0.2f, 1.0f}; // Pequeno brilho especular
    GLfloat mat_shininess[] = {32.0f};                 // Concentração do brilho

    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, mat_ambient);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, mat_diffuse);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, mat_specular);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, mat_shininess);

    // Habilitar texturização 2D
    glEnable(GL_TEXTURE_2D);
    // Define como a textura interage com a cor do material/iluminação
    // GL_MODULATE: cor_final = cor_iluminacao_material * cor_textura
    glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

    ReSizeGLScene(Width, Height); // Configura a projeção
}

void ReSizeGLScene(int Width, int Height) {
    if (Height == 0) Height = 1;
    glViewport(0, 0, Width, Height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45.0f, (GLfloat)Width / (GLfloat)Height, 0.1f, 100.0f);
    glMatrixMode(GL_MODELVIEW);
}

void DrawGLScene(void) {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();

    // Posição da Luz (se quiser que ela se mova com a câmera/mundo e não fixa na cena)
    // Se quiser fixa na cena, definir em InitGL ou aqui antes das transformações do objeto.
    // Se quiser fixa em relação à visão, definir aqui APÓS glLoadIdentity e ANTES de gluLookAt/glTranslatef.
    GLfloat light_position[] = {5.0f, 5.0f, 5.0f, 0.0f}; // Luz direcional
    glLightfv(GL_LIGHT0, GL_POSITION, light_position);


    // Transformações da câmera/visualização
    glTranslatef(0.0f, 0.0f, g_zoom); // Zoom (aproximar/afastar)
    glRotatef(g_xRot, 1.0f, 0.0f, 0.0f); // Rotação em X
    glRotatef(g_yRot, 0.0f, 1.0f, 0.0f); // Rotação em Y

    // Desenhar o modelo
    DrawModel(&g_model);

    glutSwapBuffers();
}

void DrawModel(Model *model) {
    if (!model || model->num_faces == 0) return;

    if (model->texture_id != 0) {
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, model->texture_id);
    } else {
        glDisable(GL_TEXTURE_2D); // Se não houver textura, desabilita para usar cor do material
    }

    glBegin(GL_TRIANGLES);
    for (int i = 0; i < model->num_faces; i++) {
        for (int j = 0; j < 3; j++) { // Para cada um dos 3 vértices da face
            // Os índices do OBJ são 1-based, já convertemos para 0-based no LoadOBJ
            int v_idx = model->faces[i].v_idx[j];
            int vt_idx = model->faces[i].vt_idx[j];
            int vn_idx = model->faces[i].vn_idx[j];

            if (vn_idx >= 0 && vn_idx < model->num_normals) {
                glNormal3f(model->normals[vn_idx].x, model->normals[vn_idx].y, model->normals[vn_idx].z);
            }
            if (vt_idx >= 0 && vt_idx < model->num_texcoords && model->texture_id != 0) {
                glTexCoord2f(model->texcoords[vt_idx].u, model->texcoords[vt_idx].v);
            }
            if (v_idx >= 0 && v_idx < model->num_vertices) {
                glVertex3f(model->vertices[v_idx].x, model->vertices[v_idx].y, model->vertices[v_idx].z);
            }
        }
    }
    glEnd();

    if (model->texture_id != 0) {
        glBindTexture(GL_TEXTURE_2D, 0); // Desvincula a textura
        //glDisable(GL_TEXTURE_2D); // Opcional, se outras coisas não usarem textura
    }
}




int LoadTexture(const char *filename, GLuint *textureID) {
    int width, height, nrChannels;
    unsigned char *data = stbi_load(filename, &width, &height, &nrChannels, 0);                     

    if (data) {
        GLenum format_stb; // Formato dos dados carregados por STB
        GLint internal_format_gl; // Formato interno que OpenGL usará

        if (nrChannels == 1) {
            format_stb = GL_RED; // Ou GL_LUMINANCE se preferir
            internal_format_gl = GL_LUMINANCE; // Ou GL_R8 se usar GL moderno
        } else if (nrChannels == 3) {
            format_stb = GL_RGB;
            internal_format_gl = GL_RGB; // Ou GL_RGB8
        } else if (nrChannels == 4) {
            format_stb = GL_RGBA;
            internal_format_gl = GL_RGBA; // Ou GL_RGBA8
        } else {
            fprintf(stderr, "Formato de canal de imagem desconhecido para %s: %d canais\n", filename, nrChannels);
            stbi_image_free(data);
            return 0;
        }

        glGenTextures(1, textureID);
        glBindTexture(GL_TEXTURE_2D, *textureID);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR); // Requer mipmaps

        // Use gluBuild2DMipmaps para carregar a textura e gerar mipmaps
        int glu_error = gluBuild2DMipmaps(GL_TEXTURE_2D, internal_format_gl, width, height,
                                          format_stb, GL_UNSIGNED_BYTE, data);
        if (glu_error != 0) {
            fprintf(stderr, "Erro ao construir mipmaps com gluBuild2DMipmaps para %s: %s\n", filename, gluErrorString(glu_error));
            glDeleteTextures(1, textureID); // Limpa a textura se falhar
            *textureID = 0; // Marca como inválida
            stbi_image_free(data);
            return 0;
        }

        stbi_image_free(data);
        printf("Textura '%s' carregada com mipmaps: %dx%d, %d canais.\n", filename, width, height, nrChannels);
        return 1;
    } else {
        fprintf(stderr, "Erro ao carregar textura '%s': %s\n", filename, stbi_failure_reason());
        return 0;
    }
}

int LoadMTL(const char *mtl_filename, char *texture_filename_out, int max_len) {
    FILE *file = fopen(mtl_filename, "r");
    if (!file) {
        fprintf(stderr, "Erro: Nao foi possivel abrir o arquivo MTL %s\n", mtl_filename);
        return 0;
    }

    char line[256];
    int found_map_kd = 0;
    texture_filename_out[0] = '\0'; // Inicializa como string vazia

    while (fgets(line, sizeof(line), file)) {
        // Remove espaços em branco no início da linha
        char *trimmed_line = line;
        while (*trimmed_line == ' ' || *trimmed_line == '\t') {
            trimmed_line++;
        }

        if (strncmp(trimmed_line, "map_Kd ", 7) == 0 || strncmp(trimmed_line, "map_Ka ", 7) == 0 || strncmp(trimmed_line, "map_Bump ", 9) == 0) { // Prioriza map_Kd
            char *tex_name_start = NULL;
            if (strncmp(trimmed_line, "map_Kd ", 7) == 0) tex_name_start = trimmed_line + 7;
            else if (strncmp(trimmed_line, "map_Ka ", 7) == 0 && !found_map_kd) tex_name_start = trimmed_line + 7; // Usa Ka se Kd nao achado
            else if (strncmp(trimmed_line, "map_Bump ", 9) == 0 && !found_map_kd) tex_name_start = trimmed_line + 9;


            if (tex_name_start) {
                // Remove o newline do final, se houver, e espaços no final
                char *end = tex_name_start + strlen(tex_name_start) - 1;
                while(end > tex_name_start && (*end == '\n' || *end == '\r' || *end == ' ' || *end == '\t')) {
                    *end = '\0';
                    end--;
                }
                strncpy(texture_filename_out, tex_name_start, max_len - 1);
                texture_filename_out[max_len - 1] = '\0';
                printf("Textura encontrada no MTL: %s\n", texture_filename_out);
                found_map_kd = 1; // Considera encontrado se map_Kd for lido
                if (strncmp(trimmed_line, "map_Kd ", 7) == 0) break; // Se for map_Kd, é o principal
            }
        }
    }
    fclose(file);
    if (!found_map_kd && texture_filename_out[0] == '\0') { // Se nenhum mapa foi encontrado
         fprintf(stderr, "Aviso: Nenhuma textura (map_Kd, map_Ka, map_Bump) encontrada no arquivo MTL %s\n", mtl_filename);
         return 0;
    }
    return 1; // Retorna 1 se qualquer nome de textura foi lido
}

int LoadOBJ(const char *obj_filename, Model *model) {
    FILE *file = fopen(obj_filename, "r");
    if (!file) {
        fprintf(stderr, "Erro: Nao foi possivel abrir o arquivo OBJ %s\n", obj_filename);
        return 0;
    }

    memset(model, 0, sizeof(Model));

    Vec3f *temp_vertices = NULL;
    Vec2f *temp_texcoords = NULL;
    Vec3f *temp_normals = NULL;
    Face *temp_faces = NULL;

    int cap_v = 0, cap_vt = 0, cap_vn = 0, cap_f = 0;
    char line[256];
    char mtl_filename_relative[256] = "";
    mtl_filename_relative[0] = '\0'; // Inicializa

    printf("DEBUG: Iniciando carregamento do OBJ: %s\n", obj_filename);

    while (fgets(line, sizeof(line), file)) {
        // Remover newline do final da linha para printf mais limpo
        line[strcspn(line, "\r\n")] = 0;

        if (strncmp(line, "mtllib ", 7) == 0) {
            sscanf(line, "mtllib %s", mtl_filename_relative);
            printf("DEBUG: Encontrado mtllib: %s\n", mtl_filename_relative);
        } else if (strncmp(line, "v ", 2) == 0) {
            if (model->num_vertices >= cap_v) {
                cap_v = (cap_v == 0) ? 128 : cap_v * 2;
                temp_vertices = (Vec3f*)realloc(temp_vertices, cap_v * sizeof(Vec3f));
                if (!temp_vertices) { fprintf(stderr, "Falha ao alocar temp_vertices\n"); fclose(file); return 0; }
            }
            sscanf(line, "v %f %f %f", &temp_vertices[model->num_vertices].x,
                                       &temp_vertices[model->num_vertices].y,
                                       &temp_vertices[model->num_vertices].z);
            // printf("  DEBUG v: %f %f %f\n", temp_vertices[model->num_vertices].x, temp_vertices[model->num_vertices].y, temp_vertices[model->num_vertices].z);
            model->num_vertices++;
        } else if (strncmp(line, "vt ", 3) == 0) {
            if (model->num_texcoords >= cap_vt) {
                cap_vt = (cap_vt == 0) ? 128 : cap_vt * 2;
                temp_texcoords = (Vec2f*)realloc(temp_texcoords, cap_vt * sizeof(Vec2f));
                 if (!temp_texcoords) { fprintf(stderr, "Falha ao alocar temp_texcoords\n"); fclose(file); return 0; }
            }
            sscanf(line, "vt %f %f", &temp_texcoords[model->num_texcoords].u,
                                      &temp_texcoords[model->num_texcoords].v);
            // Se a textura aparecer invertida, descomente a linha abaixo:
            temp_texcoords[model->num_texcoords].v = 1.0f - temp_texcoords[model->num_texcoords].v;
            // printf("  DEBUG vt: %f %f\n", temp_texcoords[model->num_texcoords].u, temp_texcoords[model->num_texcoords].v);
            model->num_texcoords++;
        } else if (strncmp(line, "vn ", 3) == 0) {
            if (model->num_normals >= cap_vn) {
                cap_vn = (cap_vn == 0) ? 128 : cap_vn * 2;
                temp_normals = (Vec3f*)realloc(temp_normals, cap_vn * sizeof(Vec3f));
                if (!temp_normals) { fprintf(stderr, "Falha ao alocar temp_normals\n"); fclose(file); return 0; }
            }
            sscanf(line, "vn %f %f %f", &temp_normals[model->num_normals].x,
                                        &temp_normals[model->num_normals].y,
                                        &temp_normals[model->num_normals].z);
            // printf("  DEBUG vn: %f %f %f\n", temp_normals[model->num_normals].x, temp_normals[model->num_normals].y, temp_normals[model->num_normals].z);
            model->num_normals++;
        } else if (strncmp(line, "f ", 2) == 0) {
            if (model->num_faces >= cap_f) {
                cap_f = (cap_f == 0) ? 256 : cap_f * 2;
                temp_faces = (Face*)realloc(temp_faces, cap_f * sizeof(Face));
                if (!temp_faces) { fprintf(stderr, "Falha ao alocar temp_faces\n"); fclose(file); return 0; }
            }

            printf("DEBUG FACE LINE: [%s]\n", line);

            int v_indices[3], vt_indices[3], vn_indices[3];
            // Inicializa com 0 (que significa "não presente" antes de decrementar)
            for(int k=0; k<3; ++k) { v_indices[k] = vt_indices[k] = vn_indices[k] = 0; }

            int matches = 0;
            // Formato f v/vt/vn
            matches = sscanf(line, "f %d/%d/%d %d/%d/%d %d/%d/%d",
                   &v_indices[0], &vt_indices[0], &vn_indices[0],
                   &v_indices[1], &vt_indices[1], &vn_indices[1],
                   &v_indices[2], &vt_indices[2], &vn_indices[2]);
            printf("  DEBUG: Parsed as v/vt/vn, matches = %d. Raw: %d/%d/%d %d/%d/%d %d/%d/%d\n", matches,
                   v_indices[0],vt_indices[0],vn_indices[0], v_indices[1],vt_indices[1],vn_indices[1], v_indices[2],vt_indices[2],vn_indices[2]);

            if (matches != 9) {
                // Formato f v//vn
                matches = sscanf(line, "f %d//%d %d//%d %d//%d",
                       &v_indices[0], &vn_indices[0],
                       &v_indices[1], &vn_indices[1],
                       &v_indices[2], &vn_indices[2]);
                printf("  DEBUG: Parsed as v//vn, matches = %d. Raw: %d//%d %d//%d %d//%d\n", matches,
                       v_indices[0],vn_indices[0], v_indices[1],vn_indices[1], v_indices[2],vn_indices[2]);
                if (matches == 6) {
                    for(int k=0; k<3; ++k) vt_indices[k] = 0; // vt ausente
                } else {
                    // Formato f v/vt (Blender não costuma exportar assim sem normais se normais existem)
                    matches = sscanf(line, "f %d/%d %d/%d %d/%d",
                       &v_indices[0], &vt_indices[0],
                       &v_indices[1], &vt_indices[1],
                       &v_indices[2], &vt_indices[2]);
                    printf("  DEBUG: Parsed as v/vt, matches = %d. Raw: %d/%d %d/%d %d/%d\n", matches,
                           v_indices[0],vt_indices[0], v_indices[1],vt_indices[1], v_indices[2],vt_indices[2]);
                    if (matches == 6) {
                        for(int k=0; k<3; ++k) vn_indices[k] = 0; // vn ausente
                    } else {
                        // Formato f v v v (só vértices)
                        matches = sscanf(line, "f %d %d %d",
                            &v_indices[0], &v_indices[1], &v_indices[2]);
                        printf("  DEBUG: Parsed as v, matches = %d. Raw: %d %d %d\n", matches,
                               v_indices[0], v_indices[1], v_indices[2]);
                        if (matches == 3) {
                            for(int k=0; k<3; ++k) { vt_indices[k] = 0; vn_indices[k] = 0; }
                        } else {
                            fprintf(stderr, "AVISO: Formato de face nao suportado ou malformado na linha: [%s]. Pulando face.\n", line);
                            continue; // Pula esta face
                        }
                    }
                }
            }

            // Atribuir e converter para 0-based
            for (int i = 0; i < 3; i++) {
                // Vértice é obrigatório
                if (v_indices[i] <= 0) {
                     fprintf(stderr, "ERRO: Indice de vertice invalido (<=0) na face %d, vertice %d. Linha: [%s]\n", model->num_faces, i, line);
                     // Decide como tratar: pular face? sair?
                     // Por ora, vamos tentar continuar, mas isso é um problema.
                     // Poderia atribuir um índice inválido para ser pego depois, ou pular a face.
                     // Para pular a face, você precisaria de um 'goto next_face_in_loop;' ou uma flag.
                     // Vamos apenas marcar como inválido por enquanto
                     temp_faces[model->num_faces].v_idx[i] = -1; // Sinal de erro
                } else {
                    temp_faces[model->num_faces].v_idx[i]  = v_indices[i] - 1;
                }

                temp_faces[model->num_faces].vt_idx[i] = (vt_indices[i] > 0) ? (vt_indices[i] - 1) : -1;
                temp_faces[model->num_faces].vn_idx[i] = (vn_indices[i] > 0) ? (vn_indices[i] - 1) : -1;

                printf("    Face %d, Vert %d (0-based): v_idx=%d, vt_idx=%d, vn_idx=%d\n",
                       model->num_faces, i,
                       temp_faces[model->num_faces].v_idx[i],
                       temp_faces[model->num_faces].vt_idx[i],
                       temp_faces[model->num_faces].vn_idx[i]);

                // Verificação de limites (muito importante!)
                if (temp_faces[model->num_faces].v_idx[i] >= model->num_vertices || temp_faces[model->num_faces].v_idx[i] < 0) {
                    fprintf(stderr, "ERRO CRITICO: Indice de vertice v_idx[%d]=%d fora dos limites (0 a %d) para face %d. Linha: [%s]\n",
                            i, temp_faces[model->num_faces].v_idx[i], model->num_vertices - 1, model->num_faces, line);
                    // Aqui você PRECISA tratar. Ou pular a face, ou o programa vai quebrar.
                    // Para simplificar a depuração agora, podemos deixar, mas isso é um crash esperando para acontecer.
                }
                if (temp_faces[model->num_faces].vt_idx[i] >= model->num_texcoords && model->num_texcoords > 0) { // Só checa se texcoords existem
                    fprintf(stderr, "ERRO CRITICO: Indice de textura vt_idx[%d]=%d fora dos limites (0 a %d) para face %d. Linha: [%s]\n",
                            i, temp_faces[model->num_faces].vt_idx[i], model->num_texcoords - 1, model->num_faces, line);
                }
                 if (temp_faces[model->num_faces].vn_idx[i] >= model->num_normals && model->num_normals > 0) { // Só checa se normais existem
                    fprintf(stderr, "ERRO CRITICO: Indice de normal vn_idx[%d]=%d fora dos limites (0 a %d) para face %d. Linha: [%s]\n",
                            i, temp_faces[model->num_faces].vn_idx[i], model->num_normals - 1, model->num_faces, line);
                }
            }
            model->num_faces++;
        }
    }
    fclose(file);

    printf("DEBUG: Fim da leitura do arquivo. Total lido: %d Verts, %d TexCoords, %d Normals, %d Faces preliminares\n",
           model->num_vertices, model->num_texcoords, model->num_normals, model->num_faces);

    // Copia os dados dos arrays temporários para a estrutura final do modelo
    if (model->num_vertices > 0 && temp_vertices) {
        model->vertices = (Vec3f*)malloc(model->num_vertices * sizeof(Vec3f));
        if (!model->vertices) { fprintf(stderr, "Falha ao alocar model->vertices\n"); free(temp_vertices); /* ... free others ...*/ return 0;}
        memcpy(model->vertices, temp_vertices, model->num_vertices * sizeof(Vec3f));
    }
    if (model->num_texcoords > 0 && temp_texcoords) {
        model->texcoords = (Vec2f*)malloc(model->num_texcoords * sizeof(Vec2f));
        if (!model->texcoords) { fprintf(stderr, "Falha ao alocar model->texcoords\n"); /* ... free ...*/ return 0;}
        memcpy(model->texcoords, temp_texcoords, model->num_texcoords * sizeof(Vec2f));
    }
    if (model->num_normals > 0 && temp_normals) {
        model->normals = (Vec3f*)malloc(model->num_normals * sizeof(Vec3f));
        if (!model->normals) { fprintf(stderr, "Falha ao alocar model->normals\n"); /* ... free ...*/ return 0;}
        memcpy(model->normals, temp_normals, model->num_normals * sizeof(Vec3f));
    }
    if (model->num_faces > 0 && temp_faces) {
        model->faces = (Face*)malloc(model->num_faces * sizeof(Face));
        if (!model->faces) { fprintf(stderr, "Falha ao alocar model->faces\n"); /* ... free ...*/ return 0;}
        memcpy(model->faces, temp_faces, model->num_faces * sizeof(Face));
    }

    free(temp_vertices);
    free(temp_texcoords);
    free(temp_normals);
    free(temp_faces);

    printf("Modelo OBJ '%s' processado: %d Verts, %d TexCoords, %d Normals, %d Faces efetivas\n",
           obj_filename, model->num_vertices, model->num_texcoords, model->num_normals, model->num_faces);

    // Carregar o arquivo MTL e a textura
    if (strlen(mtl_filename_relative) > 0) {
        // ... (resto da função para carregar MTL e textura, sem alterações) ...
        char full_mtl_path[512];
        const char *last_slash_obj = strrchr(obj_filename, '/');

        if (last_slash_obj) {
            strncpy(full_mtl_path, obj_filename, last_slash_obj - obj_filename + 1);
            full_mtl_path[last_slash_obj - obj_filename + 1] = '\0';
            strcat(full_mtl_path, mtl_filename_relative);
        } else {
            strcpy(full_mtl_path, mtl_filename_relative);
        }
        printf("DEBUG: Tentando carregar MTL de: %s\n", full_mtl_path);

        if (LoadMTL(full_mtl_path, model->texture_filename, sizeof(model->texture_filename))) {
            if (model->texture_filename[0] != '\0') {
                printf("DEBUG: Nome da textura do MTL: %s\n", model->texture_filename);
                char full_texture_path[512];
                const char *last_slash_mtl = strrchr(full_mtl_path, '/');

                if (last_slash_mtl) {
                    strncpy(full_texture_path, full_mtl_path, last_slash_mtl - full_mtl_path + 1);
                    full_texture_path[last_slash_mtl - full_mtl_path + 1] = '\0';
                    strcat(full_texture_path, model->texture_filename);
                } else {
                     if (strrchr(model->texture_filename, '/') || strrchr(model->texture_filename, '\\')) {
                         strcpy(full_texture_path, model->texture_filename);
                    } else {
                        if (last_slash_obj && !last_slash_mtl) {
                             strncpy(full_texture_path, obj_filename, last_slash_obj - obj_filename + 1);
                             full_texture_path[last_slash_obj - obj_filename + 1] = '\0';
                             strcat(full_texture_path, model->texture_filename);
                        } else {
                             strcpy(full_texture_path, model->texture_filename);
                        }
                    }
                }
                printf("DEBUG: Tentando carregar textura de: %s\n", full_texture_path);
                if (!LoadTexture(full_texture_path, &model->texture_id)) {
                    fprintf(stderr, "Falha ao carregar a textura: %s\n", full_texture_path);
                }
            } else {
                 printf("DEBUG: Nenhum nome de arquivo de textura encontrado no MTL.\n");
            }
        } else {
            printf("DEBUG: Falha ao carregar MTL ou nenhuma textura especificada nele.\n");
        }
    } else {
        printf("DEBUG: Nenhum arquivo mtllib especificado no OBJ.\n");
    }

    if (model->num_vertices == 0 || model->num_faces == 0) {
        fprintf(stderr, "Erro: Modelo OBJ nao contem vertices ou faces validas apos processamento.\n");
        return 0;
    }
    printf("DEBUG: Carregamento do OBJ concluido.\n");
    return 1;
}

void FreeModel(Model *model) {
    if (model) {
        free(model->vertices); model->vertices = NULL;
        free(model->texcoords); model->texcoords = NULL;
        free(model->normals); model->normals = NULL;
        free(model->faces); model->faces = NULL;
        if (model->texture_id != 0) {
            glDeleteTextures(1, &model->texture_id);
            model->texture_id = 0;
        }
        model->num_vertices = 0;
        model->num_texcoords = 0;
        model->num_normals = 0;
        model->num_faces = 0;
    }
}


// --- Funções de Callback para Input ---
void keyPressed(unsigned char key, int x, int y) {
    switch (key) {
        case 27: // ESCAPE key
            FreeModel(&g_model);
            exit(0);
            break;
        case 'r': // Resetar rotação/zoom
        case 'R':
            g_xRot = 0.0f;
            g_yRot = 0.0f;
            g_zoom = -5.0f;
            break;
    }
    glutPostRedisplay();
}

void specialKeys(int key, int x, int y) {
    switch (key) {
        case GLUT_KEY_UP:    g_xRot -= 5.0f; break;
        case GLUT_KEY_DOWN:  g_xRot += 5.0f; break;
        case GLUT_KEY_LEFT:  g_yRot -= 5.0f; break;
        case GLUT_KEY_RIGHT: g_yRot += 5.0f; break;
        case GLUT_KEY_PAGE_UP: g_zoom += 0.2f; break;   // Zoom in
        case GLUT_KEY_PAGE_DOWN: g_zoom -= 0.2f; break; // Zoom out
    }
    g_xRot = fmodf(g_xRot, 360.0f);
    g_yRot = fmodf(g_yRot, 360.0f);
    glutPostRedisplay();
}

void mouseButton(int button, int state, int x, int y) {
    g_last_mouse_x = x;
    g_last_mouse_y = y;

    if (button == GLUT_LEFT_BUTTON)   g_mouse_buttons[0] = (state == GLUT_DOWN);
    if (button == GLUT_MIDDLE_BUTTON) g_mouse_buttons[1] = (state == GLUT_DOWN); // Geralmente scroll para zoom
    if (button == GLUT_RIGHT_BUTTON)  g_mouse_buttons[2] = (state == GLUT_DOWN);

    // Roda do mouse para zoom (GLUT específico)
    if (button == 3) { // Roda para cima (Scroll Up)
        g_zoom += 0.2f;
    } else if (button == 4) { // Roda para baixo (Scroll Down)
        g_zoom -= 0.2f;
    }
    glutPostRedisplay();
}

void mouseMotion(int x, int y) {
    int dx = x - g_last_mouse_x;
    int dy = y - g_last_mouse_y;

    if (g_mouse_buttons[0]) { // Botão esquerdo: Rotacionar
        g_yRot += dx * 0.5f;
        g_xRot += dy * 0.5f;
    }
    // if (g_mouse_buttons[1]) { // Botão do meio: Pan (não implementado aqui) }
    // if (g_mouse_buttons[2]) { // Botão direito: Zoom (alternativa ao scroll)
    //     g_zoom += dy * 0.05f;
    // }

    g_last_mouse_x = x;
    g_last_mouse_y = y;
    glutPostRedisplay();
}
