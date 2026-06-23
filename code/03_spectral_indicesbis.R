library(terra)
library(imageRy)
library(viridis)

# listing files
im.liim.list()

# importing data
mato1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992 <- flip(mato1992) ## per capovolgere immagine

# l1=NIR l2=red l3=green ## significa una cosa molto semplice:Stai costruendo un’immagine RGB usando i layer 1, 2 e 3 dell’oggetto mato1992 come canali R‑G‑B.
Quindi l’oggetto mato1992 contiene 3 bande, in quest’ordine:
NIR
Red
Green
stai dicendo:
r = 1 → canale rosso = NIR
g = 2 → canale verde = Red
b = 3 → canale blu = Green

im.plotRGB(mato1992, 1, 2, 3)

# Exercise: put NIR on top pof the green component of the RGB scheme
im.plotRGB(mato1992, 2, 1, 3)

# NIR ontop of the blue
im.plotRGB(mato1992, 3, 2, 1)

# Exercise: import the image from 2006
mato2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 <- flip(mato2006)
im.plotRGB(mato2006, 1, 2, 3)

# Exercise: make a multiframe with the two images, one beside the other
im.multiframe(1,2)
im.plotRGB(mato1992, 1, 2, 3)
im.plotRGB(mato2006, 1, 2, 3)

plotRGB(mato1992, 1,2,3, stretch="hist")
plotRGB(mato2006, 1,2,3, stretch="hist")
## In parole semplici:
R prende i valori dei pixel, li ridistribuisce in modo più uniforme e aumenta il contrasto dell’immagine.
stretch="hist" = histogram stretching (o histogram equalization).
Serve per:
aumentare il contrasto
rendere più visibili i dettagli
schiarire zone troppo scure
scurire zone troppo chiare
migliorare la leggibilità dell’immagine

Senza stretch, molte immagini satellitari appaiono:
grigie
piatte
poco contrastate

Con stretch="hist" diventano molto più nitide.


im.plotRGB(mato1992, 2, 1, 3)
im.plotRGB(mato2006, 2, 1, 3)

im.plotRGB(mato1992, 2, 3, 1)
im.plotRGB(mato2006, 2, 3, 1)

# DVI # parliamo un attimo di riflettanza, che è la combinazione tra quello che viene assorbito e quello che viene riflesso, vedi formula
Se noi abbiamo un oggetto che riflette tuttao la riflettanza è massima, uguale a 1; al contrario se assorbe tutto è uguale a 0. 
quindi hanno un range tra 0 e 1 ma se vediamo le immagini su cui abbiamo lavorato vediamo dei valori con numeri interi (100,150,200 ecc)
che cos'è un bit? è una singola informazione all'interno di un computer. 0 o 1. all'interno di un bit abbiamo una informazione 0 o 1. 
con 2 bit abbiamo 4 combinazioni possibili (informazioni), con 3 bit abbiamo 8 possibili valori.
vedi la regola su slide: 
quindi gran parte delle immagini sono riscalate a 8 bit (2^8)= 256 possibili valori.
questa forma di risoluzione si chiama risoluzione radiometrica. 
dalle immgini a 8 bit è possibile ricavare indici spettrali. utili per esempio per valutare la salute delle piante.

# l1=NIR l2=red l3=green
dvi1992 <- mato1992[[1]] - mato1992[[2]]

# 8 bit
# NIR - red = 255 - 0 = 255 max DVI
# NIR - red = 0 - 255 = -255 min DVI

# range = -255, 255

# Exercise: calculate min and max of DVI for an image composed by data at 4 bit
4 bit = 2^4 = 16
# NIR - red = 15 - 0 = 15 max DVI
# NIR - red = 0 - 15 = -15 min DVI

# NDVI - Differenze Vegetation Index
# immaginiamo di avere un albero sano, nellalbero sano la luce viene riflessa nell'infrarosso vicino
Tree: NIR=255 (8 bit), red=0 (8 bit), DVI=NIR-red=255-0=255. questo è l'indice DVI per una pianta sana.
#Stressed tree; vediamo cosa succede in una pianta malata
Stressed tree:  NIR=100 (8bit), red=30 (perchè la fotosintesi non funziona bene e una parte viene riflessa) DVI=NIR-red=100-30=70

(NIR- red)/(NIR + red)

# 8 bit
# NIR - red = (255 - 0) / (255 + 0) = 1 max NDVI
# NIR - red = (0 - 255) / (0 + 255) = -1 min NDVI

# 4 bit
# NIR - red = (15 - 0) / (15 + 0) = 1 max NDVI
# NIR - red = (0 - 15) / (0 + 15) = -1 min NDVI

# dvi2006
dvi2006 <- mato2006[[1]] - mato2006[[2]]

# ndvi

ndvi1992 <- dvi1992 / (mato1992[[1]] + mato1992[[2]])
ndvi2006 <- dvi2006 / (mato2006[[1]] + mato2006[[2]])

im.multiframe(1,2)
plot(ndvi1992, col=inferno(100))
plot(ndvi2006, col=inferno(100))

# DVI by imageRy
dvi1992 = im.dvi(mato1992, 1, 2)
dvi2006 = im.dvi(mato2006, 1, 2)
plot(dvi1992, col=inferno(100))
plot(dvi2006, col=inferno(100))

# NDVI via imageRy
ndvi1992 = im.ndvi(mato1992, 1, 2)
ndvi2006 = im.ndvi(mato2006, 1, 2)
plot(ndvi1992, col=mako(100))
plot(ndvi2006, col=mako(100))

# Exercise: plot DVIs and NDVIs for the two dates in two rows and columns
im.multiframe(2, 2)
plot(dvi1992, col=inferno(100))
plot(dvi2006, col=inferno(100))
plot(ndvi1992, col=magma(100))
plot(ndvi2006, col=magma(100))
