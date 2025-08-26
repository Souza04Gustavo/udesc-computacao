import cv2
import numpy as np
import os
import matplotlib.pyplot as plt

# tom de cinza para SP: 156
# tom de cinza para SC: 121
# tom de cinza para AM: 57

caminho_script_atual = os.path.dirname(__file__)

diretorio_anterior = os.path.join(caminho_script_atual, '..')

caminho_arquivo = os.path.join(diretorio_anterior, 'database_images', 'taxaRouboCarros/taxaPerCapitaRouboCarros.png')

imagem_cinza = cv2.imread(caminho_arquivo, cv2.IMREAD_GRAYSCALE)

# adicionando os 3 canais de cores
imagem_saida_colorida = cv2.cvtColor(imagem_cinza, cv2.COLOR_GRAY2BGR)

altura, largura = imagem_cinza.shape

for i in range(altura):
    for j in range(largura):
        valor_cinza = imagem_cinza[i, j]
        
        if valor_cinza >= 120 and valor_cinza <= 125 :
            imagem_saida_colorida[i, j] = [255, 0, 0]
            
            
plt.figure(figsize=(4, 4)) # tamanho da janela

plt.subplot(2, 2, 1)
plt.imshow(cv2.cvtColor(imagem_cinza, cv2.COLOR_GRAY2RGB))
plt.title('Imagem Original')
plt.axis('off')

plt.subplot(2, 2, 2)
plt.imshow(cv2.cvtColor(imagem_saida_colorida, cv2.COLOR_BGR2RGB))
plt.title('Imagem Colorida')
plt.axis('off')


plt.show()


