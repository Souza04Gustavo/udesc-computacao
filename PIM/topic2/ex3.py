import cv2
import numpy as np
import os
import matplotlib.pyplot as plt

caminho_script_atual = os.path.dirname(__file__)

diretorio_anterior = os.path.join(caminho_script_atual, '..')

caminho_arquivo = os.path.join(diretorio_anterior, 'database_images', 'arco_iris.jpg')

imagem = cv2.imread(caminho_arquivo)
altura, largura, canais = imagem.shape

print(f"A imagem tem {altura}x{largura} pixels e {canais} canais de cor.")

cinza_luminosidade = np.zeros((altura, largura), dtype=np.uint8)
cinza_media = np.zeros((altura, largura), dtype=np.uint8)
cinza_claridade = np.zeros((altura, largura), dtype=np.uint8)

for i in range(altura):
    for j in range(largura):
        pixel = imagem[i, j]
        b, g, r = pixel[0], pixel[1], pixel[2]

        # converter para nao dar problema
        b = int(b)
        g = int(g)
        r = int(r)
        
        # 1: metodo da luminosidade
        cinza_luminosidade[i, j] = int(0.21 * r + 0.72 * g + 0.07 * b)
        
        # 2: metodo da media
        cinza_media[i, j] = int((r + g + b) / 3)
        
        # 3: metodo da claridade
        cinza_claridade[i, j] = int((max(r, g, b) + min(r, g, b)) / 2)
        

# Exibição das conversoes
plt.figure(figsize=(12, 8)) # tamanho da janela

# --- Imagem Original ---
plt.subplot(2, 2, 1) # 2 linhas, 2 col
plt.imshow(cv2.cvtColor(imagem, cv2.COLOR_BGR2RGB)) # converter de BGR para RGB
plt.title('Imagem Original')
plt.axis('off') # nao mostrar os eixos


# --- Metodo da luminosidade ---
plt.subplot(2, 2, 2)
plt.imshow(cinza_luminosidade, cmap='gray')
plt.title('Cinza - Luminosidade')
plt.axis('off')

# --- Metodo da media ---
plt.subplot(2, 2, 3)
plt.imshow(cinza_media, cmap='gray')
plt.title('Cinza - Media')
plt.axis('off')

# --- Metodo da claridade ---
plt.subplot(2, 2, 4)
plt.imshow(cinza_claridade, cmap='gray')
plt.title('Cinza - Claridade')
plt.axis('off')

plt.show()
