# Python program to explain splitting of channels 
  
# Importing cv2 
import cv2  
import numpy as np
  
# Reading the image using imread() function 
image = cv2.imread('figuraClara.jpg') 
# Displaying the original BGR image 
cv2.imshow('Image', image) 
print (np.mean(image))  
  
# Waits for user to press any key 
cv2.waitKey(0)
