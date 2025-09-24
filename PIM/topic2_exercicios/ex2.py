import cv2
import numpy as np
import os

caminho_script_atual = os.path.dirname(__file__)

diretorio_anterior = os.path.join(caminho_script_atual, '..')

caminho_arquivo = os.path.join(diretorio_anterior, 'database_images', 'figuraClara.jpg')


imagem = cv2.imread(caminho_arquivo)
altura, largura, canais = imagem.shape

print(f"A imagem tem {altura}x{largura} pixels e {canais} canais de cor.")

soma = 0.0
somaDoPixel = 0.0

for i in range(altura):
    for j in range(largura):
        # a ordem é BGR
        pixelAtual = imagem[i, j]
        # tem que converter usando int, pois o pixelAtual é do tipo uint8
        somaDoPixel = int(pixelAtual[0]) + int(pixelAtual[1]) + int(pixelAtual[2])
        soma = soma + somaDoPixel

media = soma / (altura*largura*canais)
print("-" * 30)
print(f"Minha Média Calculada: {media}")
print(f"Média via np.mean(): {np.mean(imagem)}")
print("-" * 30)



# para saber se uma imagem esta mais proxima de cinza, branca ou escura basta analisar a media dos valores dos pixels
if(media <= 50):
    print("A imagem é escura.")
elif(media <= 255 and media > 150):
    print("A imagem é clara.")
else:
    print("A imagem é cinza.")
