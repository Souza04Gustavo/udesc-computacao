import cv2
import numpy as np
import os

caminho_script_atual = os.path.dirname(__file__)

diretorio_anterior = os.path.join(caminho_script_atual, '..')

caminho_arquivo = os.path.join(diretorio_anterior, 'database_images', 'figuraClara.jpg')

# solicitado no enunciado
image = cv2.imread(caminho_arquivo)
cv2.imshow('Imagem Original', image)
print(np.mean(image))

cv2.waitKey(0)