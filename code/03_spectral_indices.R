# Code for calculating spectral indices in R

library(imageRy) # beloved package developed at unibo
library(terra)
library(ggplot2)
library(viridis)

im.list()

mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg" )
mato1992 = flip(mato1992)
plot(mato1992)

# layer 1: NIR
# layer 2: red
# layer 3: green
im.plotRGB(mato1992, r=1, g=2, b=3)   #tutta la vegetazione è diventata rossa perchè abbamo messo il NIR sul red
im.plotRGB(mato1992, r=2, g=1, b=3)
im.plotRGB(mato1992, r=2, g=3, b=1)

mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 = flip(mato2006)
plot(mato2006)

im.plotRGB(mato2006, r=1, g=2, b=3) 
im.multiframe(1,2)
im.plotRGB(mato1992, r=1, g=2, b=3) 
im.plotRGB(mato2006, r=1, g=2, b=3)

im.multiframe(3,2)
# NIR ontop of red
im.plotRGB(mato1992, r=1, g=2, b=3) 
im.plotRGB(mato2006, r=1, g=2, b=3)


# NIR ontop of GREEN
im.plotRGB(mato1992, r=2, g=1, b=3) 
im.plotRGB(mato2006, r=2, g=1, b=3)

# NIR ontop of BLUE
im.plotRGB(mato1992, r=3, g=2, b=1) 
im.plotRGB(mato2006, r=3, g=2, b=1)

#Exercise: plot only the first layer of 2006
dev.off()

plot(mato2006[[1]])
plot(mato2006[[1]], col=magma(100))
plot(mato2006[[1]], col=mako(100))


# parliamo un attimo di riflettanza, che è la combinazione tra quello che viene assorbito e quello che viene riflesso, vedi formula
Se noi abbiamo un oggetto che riflette tuttao la riflettanza è massima, uguale a 1; al contrario se assorbe tutto è uguale a 0. 
quindi hanno un range tra 0 e 1 ma se vediamo le immagini su cui abbiamo lavorato vediamo dei valori con numeri interi (100,150,200 ecc)
che cos'è un bit? è una singola informazione all'interno di un computer. 0 o 1. all'interno di un bit abbiamo una informazione 0 o 1. 
con 2 bit abbiamo 4 combinazioni possibili (informazioni), con 3 bit abbiamo 8 possibili valori.
vedi la regola su slide: 
quindi gran parte delle immagini sono riscalate a 8 bit (2^8)= 256 possibili valori.
questa forma di risoluzione si chiama risoluzione radiometrica. 
dalle immgini a 8 bit è possibile ricavare indici spettrali. utili per esempio per valutare la salute delle piante.

# DVI - Differenze Vegetation Index
# immaginiamo di avere un albero sano, nellalbero sano la luce viene riflessa nell'infrarosso vicino
Tree: NIR=255 (8 bit), red=0 (8 bit), DVI=NIR-red=255-0=255. questo è l'indice DVI per una pianta sana.
#Stressed tree; vediamo cosa succede in una pianta malata
Stressed tree:  NIR=100 (8bit), red=30 (perchè la fotosintesi non funziona bene e una parte viene riflessa) DVI=NIR-red=100-30=70

##Calculatind DVI
im.multiframe(1,2)
plot(mato1992)
plot(mato2006)

# 1 = NIR
# 2 = red

dvi1992 = mato1992[[1]] - mato1992[[2]] # NIR - red
plot(dvi1992)

# range DVI
# maximum: NIR - red = 255 - 0 = 255
# minimum: NIR - red = 0 - 255 = -255

plot(dvi1992, col=inferno(100))           ## 100 indica che ci sono 100 sfumature del colore

# Calculate DVI for 2006

> dvi2006 = mato2006[[1]] - mato2006[[2]] # NIR - red
> plot(dvi2006)
> plot(dvi2006, col=inferno(100))

im.multiframe(1,2)   ## per metterle una accanto all'altra
plot(dvi1992, col=inferno(100))
plot(dvi2006, col=inferno(100))

## Different radiometric resolutions

# DVI 8 bit: range
# maximum: NIR - red = 255 - 0 = 255
# minimum: NIR - red = 0 - 255 = -255

# DVI 4 bit: range (0-15)
# maximum: NIR - red = 15 - 0 = 15
# minimum: NIR - red = 0 - 15 = -15

#NDVI 8 bit : range (0-255)
# maximum: (NIR - red) / (NIR + red) = (255 - 0) / (255 + 0) = 1
# minimum: (NIR - red) / (NIR + red) = (0 - 255) / (0 + 255) = -1

#NDVI 4 bit : range (0-15)
# maximum: (NIR - red) / (NIR + red) = (15 - 0) / (15 + 0) = 1
# minimum: (NIR - red) / (NIR + red) = (0 - 15) / (0 + 15) = -1

ndvi1992 = (mato1992[[1]] - mato1992[[2]] /  mato1992[[1]] + mato1992[[2]])
# ndvi1992 = dvi1992 / (mato19992[[1] + mato1992[[2]]
plot(ndvi1992)

ndvi2006 = (mato2006[[1]] - mato2006[[2]] /  mato2006[[1]] + mato2006[[2]])
# ndvi2006 = dvi2006 / (mato2006[[1] + mato2006[[2]]
plot(ndvi2006)

#Functions fro imageRy
dvi1992auto = im.dvi(mato1992, 1, 2)
> dev.off()
> plot(dvi1992auto)

dvi2006auto = im.dvi(mato2006, 1, 2)
> dev.off()
> plot(dvi2006auto)

ndvi1992auto = im.ndvi(mato1992, 1, 2)
plot(ndvi1992auto)

ndvi2006auto = im.ndvi(mato2006, 1, 2)
plot(ndvi2006auto)
