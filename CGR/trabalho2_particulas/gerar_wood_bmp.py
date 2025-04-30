import struct
import random

# --- Configurações da Textura ---
width = 128  # Largura da textura em pixels
height = 128 # Altura da textura em pixels
filename = "wood.bmp" # Nome do arquivo de saída
# --------------------------------

# --- Cálculos do Cabeçalho BMP ---
bytes_per_pixel = 3
row_padding = (4 - (width * bytes_per_pixel) % 4) % 4
image_data_size = (width * bytes_per_pixel + row_padding) * height
file_header_size = 14
info_header_size = 40
offset_to_data = file_header_size + info_header_size
file_size = offset_to_data + image_data_size

# --- Função para gerar cor de madeira simples ---
def get_wood_color(x, y, width, height):
    # Base color (um marrom médio) - RGB
    base_r, base_g, base_b = 160, 110, 60

    # Simular grãos verticais com ruído
    noise_factor = random.uniform(0.8, 1.2)
    # Adicionar alguma variação baseada na posição x (grãos)
    grain_variation = (x / width) * 30 - 15 # Pequena variação horizontal
    # Adicionar ruído aleatório
    random_noise = random.randint(-15, 15)

    r = base_r * noise_factor + grain_variation + random_noise
    g = base_g * noise_factor + grain_variation // 2 + random_noise # Menos variação no verde
    b = base_b * noise_factor + random_noise

    # Adicionar linhas mais escuras ocasionais (simulando veios)
    if random.random() < 0.08: # 8% de chance de um veio mais escuro
        r *= 0.6
        g *= 0.6
        b *= 0.6

    # Clamp values to 0-255
    r = max(0, min(255, int(r)))
    g = max(0, min(255, int(g)))
    b = max(0, min(255, int(b)))

    # BMP armazena em BGR
    return (b, g, r)

# --- Escrever o Arquivo BMP ---
try:
    with open(filename, 'wb') as f:
        # File Header (14 bytes)
        f.write(b'BM')                            # bfType
        f.write(struct.pack('<I', file_size))     # bfSize (Little-endian unsigned int)
        f.write(struct.pack('<H', 0))             # bfReserved1 (Little-endian unsigned short)
        f.write(struct.pack('<H', 0))             # bfReserved2
        f.write(struct.pack('<I', offset_to_data))# bfOffBits

        # Info Header (BITMAPINFOHEADER - 40 bytes)
        f.write(struct.pack('<I', info_header_size)) # biSize
        f.write(struct.pack('<i', width))           # biWidth (Little-endian signed int)
        f.write(struct.pack('<i', height))          # biHeight (Positivo = bottom-up DIB)
        f.write(struct.pack('<H', 1))               # biPlanes
        f.write(struct.pack('<H', bytes_per_pixel * 8)) # biBitCount (24 bits)
        f.write(struct.pack('<I', 0))               # biCompression (0 = BI_RGB, no compression)
        f.write(struct.pack('<I', image_data_size)) # biSizeImage
        f.write(struct.pack('<i', 0))               # biXPelsPerMeter (Não usado)
        f.write(struct.pack('<i', 0))               # biYPelsPerMeter (Não usado)
        f.write(struct.pack('<I', 0))               # biClrUsed (Não usado para 24bpp)
        f.write(struct.pack('<I', 0))               # biClrImportant (Não usado)

        # Pixel Data (Bottom-up BGR)
        for y in range(height):
            for x in range(width):
                b, g, r = get_wood_color(x, y, width, height)
                f.write(struct.pack('<BBB', b, g, r)) # Escreve B, G, R (1 byte cada)

            # Adiciona padding no final da linha
            f.write(bytes([0] * row_padding))

    print(f"Arquivo '{filename}' ({width}x{height}, 24-bit BMP) criado com sucesso!")

except Exception as e:
    print(f"Erro ao criar o arquivo BMP: {e}")