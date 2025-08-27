import cv2
import numpy as np
import matplotlib.pyplot as plt

def isodata_limiar(imagem_cinza):
    t = 128
    
    for i in range(100):
        print(f"Iteração {i+1}: Limiar atual = {t:.2f}")
        t_antigo = t
        
        mascara_fundo = imagem_cinza <= t
        mascara_objeto = imagem_cinza > t
        
        if np.any(mascara_fundo):
            mu1 = np.mean(imagem_cinza[mascara_fundo])
        else:
            mu1 = 0
            
            
        if np.any(mascara_objeto):
            mu2 = np.mean(imagem_cinza[mascara_objeto])
        else:
            mu2 = 0
            
        t = (mu1 + mu2) / 2
        
        if abs(t - t_antigo) < 0.5:
            print("\nConvergência atingida!")
            break
        
    return int(round(t))


imagem_original = cv2.imread('imagem_para_ex6.jpeg')

imagem_cinza = cv2.cvtColor(imagem_original, cv2.COLOR_BGR2GRAY)

print("--- Calculando o limiar com o algoritmo Isodata ---")
limiar_isodata = isodata_limiar(imagem_cinza)
print(f"--------------------------------------------------")
print(f"O limiar Isodata final calculado é: {limiar_isodata}")

# Pixels > limiar_isodata se tornam 255 (branco), os outros se tornam 0 (preto)
ret, imagem_binaria = cv2.threshold(imagem_cinza, limiar_isodata, 255, cv2.THRESH_BINARY)

plt.figure(figsize=(12, 6))

plt.subplot(1, 2, 1)
plt.imshow(imagem_cinza, cmap='gray')
plt.title('Imagem de Entrada (Tons de Cinza)')
plt.axis('off')

plt.subplot(1, 2, 2)
plt.imshow(imagem_binaria, cmap='gray')
plt.title(f'Imagem de Saída (Limiar Isodata = {limiar_isodata})')
plt.axis('off')

plt.tight_layout()
plt.show()