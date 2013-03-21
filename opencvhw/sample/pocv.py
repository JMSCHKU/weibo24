#!/usr/bin/python
import cv #Import functions from OpenCV
cv.NamedWindow('a_window', cv.CV_WINDOW_AUTOSIZE)
image=cv.LoadImage('picture.png', cv.CV_LOAD_IMAGE_COLOR) #Load the image
font = cv.InitFont(cv.CV_FONT_HERSHEY_SIMPLEX, 1, 1, 0, 3, 8) #Creates a font
x = x position of text
y = y position of text
cv.PutText(frame,"Hello World!!!", (x,y),font, 255) #Draw the text
cv.ShowImage('a_window', image) #Show the image
cv.Waitkey(10000)
cv.SaveImage('image.png', image) #Saves the image
