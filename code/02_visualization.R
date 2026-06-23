# R code for visualizing multispectral data

library(terra) 
library(imageRy)
# install.packages("devtools")
# intsall.packages("viridis")
library(devtools)
# install_github("ducciorocchini/imageRy")
library(viridis)
library(ggplot2)
# install.packages("patchwork")
library(patchwork)
library(GGally)

im.list()

# Sentinel-2 bands
# https://gisgeography.com/sentinel-2-bands-combinations/

b2 <- im.import("sentinel.dolomites.b2.tif")

# Changing colors
cl <- colorRampPalette(c("lightsalmon", "yellow", "mediumpurple1"))(100) ## significa che sto creando una palette con 100 sfumature di colore che vanno dal light salmon al mediumpurple
plot(b2, col=cl)  ## per creare il raster con quei colori

# Small number of nuances
cl <- colorRampPalette(c("lightsalmon", "yellow", "mediumpurple1"))(3) ## per diminuire il numero di sfumature
plot(b2, col=cl)

# Using viridis to change colors, guarda viridis su web per i colori
plot(b2, col=inferno(100)) ## è una palette di colori di viridis
plot(b2, col=mako(100))

# Exercise: assign a greycolor palete to the image
cl <- colorRampPalette(c("dark gray", "gray", "light gray"))(100)
plot(b2, col=cl)

# par
par(mfrow=c(1,2)) ## significa “dividi la finestra grafica in 1 riga e 2 colonne”. In altre parole: prepara due pannelli affiancati, così puoi fare due plot uno accanto all’altro.
plot(b2, col=inferno(100))
plot(b2, col=cl)

dev.off() ## per chiudere la finestra grafica corrente

# im.multiframe, funziona meglio per immaggini imager, mentre per immagini raster è meglio par
im.multiframe(1,2)
plot(b2, col=inferno(100))
plot(b2, col=cl)

# Importing band 3

b3 <- im.import("sentinel.dolomites.b3.tif")

# Exercise: change the ramp palette according to the viridis package
plot(b3, col=plasma(100))

# Importng band 4
b4 <- im.import("sentinel.dolomites.b4.tif")

# Importng band 8
b8 <- im.import("sentinel.dolomites.b8.tif")

im.multiframe(2,2)
## vedi colorRampPalette per i colori
# Exercise: multiframe with the four bands, legends: in line with the wavelength
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(b2, col=clb)

clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
plot(b3, col=clg)

clr <- colorRampPalette(c("#8B1A1A", "red", "pink"))(100)
plot(b4, col=clr)

cln <- colorRampPalette(c("goldenrod3", "goldenrod2", "goldenrod"))(100)
plot(b8, col=cln)

plot(b2, col=inferno(100))
plot(b3, col=inferno(100))
plot(b4, col=inferno(100))
plot(b8, col=inferno(100))

sentinel <- c(b2, b3, b4, b8)
plot(sentinel)
plot(sentinel, col=inferno(100))

plot(sentinel$sentinel.dolomites.b8)

# layer1=b2, layer2=b3, layer3=b4, layer4=b8
plot(sentinel[[4]])
plot(sentinel[[2]])


# stack
# sist rife

b2 <- im.import("sentinel.dolomites.b2.tif")
b3 <- im.import("sentinel.dolomites.b3.tif")
b4 <- im.import("sentinel.dolomites.b4.tif")
b8 <- im.import("sentinel.dolomites.b8.tif")

p1 <- im.ggplot(b8)
p2 <- im.ggplot(b4)

p1 + p2   ## significa “metti insieme due grafici ggplot uno accanto all’altro”.

# Multiframe: ## multiframe significa solamente mostra più immagini nella stessa griglia
# 1. par(mfrow=c(1,2))
# 2. im.multiframe(1,2)
# 3. stack
# 4. ggplot2 patchwork

# RGB plotting
sentinel <- c(b2, b3, b4, b8)  ## Questa riga crea semplicemente un VETTORE che contiene quattro oggetti (b2, b3, b4, b8

# 1=b2 blue
# 2=b3 green
# 3=b4 red
# 4=b8 nir
## I numeri 1, 2, 3, 4 NON sono colori.
Sono solo la posizione delle bande dentro l’oggetto multibanda.
stai creando un’immagine con 4 canali, in questo ordine:
stai dicendo:

r = 3 → usa la banda 3 (b4 = rosso) come canale rosso

g = 2 → usa la banda 2 (b3 = verde) come canale verde

b = 1 → usa la banda 1 (b2 = blu) come canale blu

👉 Questo è il natural color (4-3-2).

# 3 filters and 4 bands
im.plotRGB(sentinel, r=3, g=2, b=1) # natural colors 
im.plotRGB(sentinel, r=4, g=3, b=2) # false colors

im.multiframe(1,2)
# 3 filters and 4 bands
im.plotRGB(sentinel, r=3, g=2, b=1) # natural colors 
im.plotRGB(sentinel, r=4, g=3, b=2) # false colors

plot(sentinel[[4]])
im.plotRGB(sentinel, r=4, g=3, b=2) # false colors

# NIR on green
im.plotRGB(sentinel, r=3, g=4, b=2) # false colors

# Exercise: NIR on top of the blue component of the RGB scheme
im.plotRGB(sentinel, r=3, g=2, b=4) # false colors
## Vuol dire:
r = 3 → canale rosso = banda 4 (RED)
g = 2 → canale verde = banda 3 (GREEN)
b = 4 → canale blu = banda 8 (NIR)
👉 Hai messo il NIR (banda 8) nel canale blu dell’immagine RGB.
Questo produce un false color particolare, dove:
le zone con molta vegetazione (alto NIR) diventano blu brillante
le zone con poca vegetazione diventano scure
il resto assume colori strani perché il NIR non è visibile all’occhio umano

# Plot the four manners of RGB in a single multiframe
im.multiframe(2,2)
im.plotRGB(sentinel, r=3, g=2, b=1) # natural colors 
im.plotRGB(sentinel, r=4, g=3, b=2) # false colors
im.plotRGB(sentinel, r=3, g=4, b=2) # false colors
im.plotRGB(sentinel, r=3, g=2, b=4) # false colors

# Positioning of visible bands
im.multiframe(1,2)
im.plotRGB(sentinel, r=4, g=3, b=2) # false colors
im.plotRGB(sentinel, r=4, g=2, b=3) # false colors

pairs(sentinel)
ggpairs(sentinel) ##ggpairs() crea una grande griglia di grafici, dove:
ogni riga e colonna rappresentano una variabile
ogni cella mostra un grafico che confronta due variabili
la diagonale mostra la distribuzione (istogrammi)
le celle fuori diagonale mostrano scatterplot + correlazioni
È come dire:
“Fammi vedere come tutte le bande sono correlate tra loro”.

# simplifying the function
im.plotRGB(sentinel, 4, 2, 3) # false colors

# plotRGB() from terra
plotRGB(sentinel, 4, 2, 3) 
plotRGB(sentinel, 4, 2, 3, stretch="lin") 
plotRGB(sentinel, 4, 2, 3, stretch="hist") 
