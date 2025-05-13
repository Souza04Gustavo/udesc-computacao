
import pygame, sys
from pygame.locals import *
import random
import time
import math
 
pygame.init()
 
FPS = 60
FramePerSec = pygame.time.Clock()
 
# Cores
BLUE  = (0, 0, 255)
RED   = (255, 0, 0)
GREEN = (0, 255, 0)
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
 
# Screen information
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
 
DISPLAYSURF = pygame.display.set_mode((SCREEN_WIDTH,SCREEN_HEIGHT))
DISPLAYSURF.fill(WHITE)
pygame.display.set_caption("O Fugitivo")



 
class Enemy(pygame.sprite.Sprite):
	def __init__(self):
		super().__init__() 
		self.image = pygame.image.load("PlayerRed.png")
		self.rect = self.image.get_rect()
		self.rect.center=(100,100) 
		self.speed = random.randint(1, 3) # criei velocidades para o inimigo
		
		self.direction = "DOWN"
		self.counter = 0
		self.counterMax = 50
		
	def setPos(self, x, y):
		self.rect.center = (x, y)	
 
	'''
	def move(self):
		
		
		# versao do professor
		dirs = ["UP", "DOWN", "LEFT", "RIGHT"]	
		
		mx = 0; my = 0;
		newd = False
		if(self.direction == "UP"):
			my = -5
		if(self.direction == "DOWN"):
			my = 5
		if(self.direction == "LEFT"):
			mx = -5
		if(self.direction == "RIGHT"):
			mx = 5	
		
		self.counter += 1
		if(self.rect.top < 0 or self.rect.bottom > SCREEN_HEIGHT 
		or self.rect.left < 0 or self.rect.right > SCREEN_WIDTH
		or self.counter > self.counterMax):
			self.counter = 0
			self.counterMax = random.randint(20,70)
			self.direction = dirs[random.randint(0,3)]
			mx = -mx
			my = -my		
			
		self.rect.move_ip(mx,my)
	'''		

	def move(self):
			# logica "semelhante" a que eu apliquei no crab game 
			try:
				target_pos = P1.rect.center # pos do jogador
			except NameError:
				return

			current_pos = self.rect.center # pos do inimigo

			# calculo da direcao desejada para atingir o inimigo
			dx = target_pos[0] - current_pos[0]
			dy = target_pos[1] - current_pos[1]

			# calculo da distancia desejada
			distance = math.sqrt(dx**2 + dy**2)

			# prepara o movimento
			mx, my = 0, 0 
			if distance > 0: 
       			# normalizando o tamanho do vetor para 1 (distancia é 1 unidade)
				norm_dx = dx / distance
				norm_dy = dy / distance

				# Aplicar velocidade ao vetor normalizado
				mx = norm_dx * self.speed
				my = norm_dy * self.speed

			# faz o movimento
			self.rect.move_ip(round(mx), round(my))
	
	
	def draw(self, surface):
		surface.blit(self.image, self.rect)
		
	
class Player(pygame.sprite.Sprite):
	def __init__(self):
		super().__init__() 
		self.image = pygame.image.load("PlayerBlue.png")
		self.rect = self.image.get_rect()
		self.rect.center = (160, 520)
		
	def setPos(self, x, y):
		self.rect.center = (x, y)
	
	def getRect(self):
		return self.rect
 
	def update(self):
		pressed_keys = pygame.key.get_pressed()
		if pressed_keys[K_UP]:
			self.rect.move_ip(0, -5)
		if pressed_keys[K_DOWN]:
			self.rect.move_ip(0,5)
		 
		if self.rect.left > 0:
			  if pressed_keys[K_LEFT]:
				  self.rect.move_ip(-5, 0)
				  
		if self.rect.right < SCREEN_WIDTH:		
			  if pressed_keys[K_RIGHT]:
				  self.rect.move_ip(5, 0)
 
	def draw(self, surface):
		surface.blit(self.image, self.rect)	 
 
		 
P1 = Player()
E1 = Enemy()

enemies = []
N_ENEMIES = 3
for i in range(N_ENEMIES):
	enemies.append(Enemy())

while True:	 
	for event in pygame.event.get():			  
		if event.type == QUIT:
			pygame.quit()
			sys.exit()
	P1.update()
	for i in range(N_ENEMIES):
		enemies[i].move()
	 
	DISPLAYSURF.fill(WHITE)
	P1.draw(DISPLAYSURF)
	
	for i in range(N_ENEMIES):
		enemies[i].draw(DISPLAYSURF)
		
	l = P1.getRect().collidelistall(enemies)
	if(len(l) > 0):
		time.sleep(2)
		P1.setPos(int(SCREEN_WIDTH / 2), int(SCREEN_HEIGHT / 2))
		for i in range(N_ENEMIES):
			enemies[i].setPos(100,100)
	
		 
	pygame.display.update()
	FramePerSec.tick(FPS)
