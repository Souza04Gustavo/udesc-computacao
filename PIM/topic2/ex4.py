import cv2
import numpy as np
import os
import matplotlib.pyplot as plt

caminho_script_atual = os.path.dirname(__file__)

diretorio_anterior = os.path.join(caminho_script_atual, '..')

caminho_arquivo1 = os.path.join(diretorio_anterior, 'database_images', 'MorrisHolidayMetallic/MorrisHolidayMetallic5873_gray.png')
caminho_arquivo2 = os.path.join(diretorio_anterior, 'database_images', 'MorrisHolidayMetallic/MorrisHolidayMetallic5874_gray.png')

I1 = cv2.imread(caminho_arquivo1, cv2.IMREAD_GRAYSCALE) # Carrega direto em cinza
I2 = cv2.imread(caminho_arquivo2, cv2.IMREAD_GRAYSCALE) # Carrega direto em cinza

if I1.shape != I2.shape:
    print("dimensoes de imagens diferentes")
    exit()
    
# MUDAR PARA FLOAT
I1_float = I1.astype(float)
I2_float = I2.astype(float)

altura, largura = I1.shape
num_quadros = 15

for i in range(num_quadros + 1):
    u = i/num_quadros
    resultado = np.zeros_like(I1_float)
    
    for y in range(altura):
        for x in range(largura):
            pixel1 = I1_float[y, x]
            pixel2 = I2_float[y, x]
    
            #formula da interpolacao
            pixel_resultado = (1 - u) * pixel1 + u * pixel2
            resultado[y, x] = pixel_resultado
            
    #volta para uint8 para que o openCV consiga salvar e exibir
    imagem_resultado_uint8 = resultado.astype(np.uint8)
    cv2.imshow('Cross-Fading Manual', imagem_resultado_uint8)
    if cv2.waitKey(50) & 0xFF == ord('q'):
        break
    
cv2.destroyAllWindows()