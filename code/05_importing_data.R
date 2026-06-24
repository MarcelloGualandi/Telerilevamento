# Script to import data from a computer or GitHub

library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
library(patchwork)

setwd("~/Desktop/")
# c://blablabla/lknlnln

# get the directory
getwd()

# list oall the files inside the dir
list.files()

rgb <- rast("DJI_20260331174728_0001_D.JPG")
plot(rgb)

gre <- rast("DJI_20260331174728_0001_MS_G.TIF")

red <- rast("DJI_20260331174728_0001_MS_R.TIF")

nir <- rast("DJI_20260331174728_0001_MS_NIR.TIF")

stack <- c(gre, red, nir)
plot(stack)

plotRGB(stack, r=3, g=2, b=1, stretch="lin") ## plotRGB(stack, r=3, g=2, b=1, stretch="lin"):

crea un composito falso colore
usa NIR → Rosso, RED → Verde, GREEN → Blu
applica uno stretch lineare per migliorare il contrasto
evidenzia la vegetazione (in rosso)

plotRGB(stack, r=3, g=2, b=1, stretch="hist")

# without stretch declaration ## Mostra l’immagine così com’è, con i valori originali delle bande.
Non applica nessun miglioramento del contrasto.
Risultato:
immagine più scura
colori meno saturi
dettagli poco visibili
vegetazione rossa poco evidente
È una visualizzazione “raw”.

im.plotRGB(stack, r=3, g=2, b=1)
## Riepilogo super‑chiaro
im.plotRGB(stack, r=3, g=2, b=1):
crea un falso colore NIR–RED–GREEN
NON applica alcuno stretch
l’immagine appare più “grezza” e meno leggibile
stretch="lin" serve solo a migliorare la visualizzazione, non i dati.

plotRGB(stack, 2, 3, 1, stretch="lin")
plotRGB(stack, 2, 1, 3, stretch="lin")

# NDVI
ndvi <- im.ndvi(stack, 3, 2)  ## Stai dicendo alla funzione:
usa il layer 3 dello stack come NIR
usa il layer 2 dello stack come RED

plot(ndvi, col=magma(100))    ##È una palette scura, molto contrastata
#Va dal nero → viola → rosso → arancio → giallo
#Con 100 colori hai una transizione molto fluida
#Ottima per evidenziare differenze sottili nell’NDVI
#Interpretazione tipica:
#valori bassi → scuri (nero/viola)
#valori alti → chiari (giallo/arancio)

plot(ndvi, col=plasma(20))  ## È più viva e luminosa
#Va dal viola → rosa → arancio → giallo
#Con 20 colori hai una scala più “a gradini”
#Più facile da leggere a colpo d’occhio, meno precisa
#Interpretazione tipica:
#valori bassi → viola
#valori alti → giallo brillante

# save the data

writeRaster(ndvi, "ndvi.tif") 

##salva il tuo NDVI su disco come file GeoTIFF.
È uno degli step finali più importanti quando lavori con dati raster.
prende l’oggetto ndvi che hai calcolato
lo scrive in un file chiamato ndvi.tif
lo salva nella cartella di lavoro corrente
mantiene:
estensione spaziale
risoluzione
sistema di riferimento (se presente)
valori NDVI originali

👉 In pratica, stai creando un raster NDVI esportabile, che puoi aprire in QGIS, ArcGIS, ENVI, ecc.

# imagine that a researcher is using your data: reimporting files 
ndvi2 <- rast("ndvi.tif")
plot(ndvi2)

# save a plot
im.multiframe(2,2)
plotRGB(stack, r=3, g=2, b=1, stretch="lin")
plotRGB(stack, 2, 3, 1, stretch="lin")
plotRGB(stack, 2, 1, 3, stretch="lin")
plot(ndvi)

png("figura_per_tesi.png")
im.multiframe(2,2)
plotRGB(stack, r=3, g=2, b=1, stretch="lin")
plotRGB(stack, 2, 3, 1, stretch="lin")
plotRGB(stack, 2, 1, 3, stretch="lin")
plot(ndvi)
dev.off()

# patchwork
p1 <- im.ggplot(ndvi)
p2 <- im.ridgeline(stack, scale=1, palette="viridis") 

##Il ridgeline:
- prende ogni banda
- calcola la distribuzione dei valori per righe
- crea “creste” impilate
- usa la palette viridis
👉 Serve per vedere come cambiano i valori spettrali lungo l’immagine.

p1 + p2 

##p1 + p2 significa:
“Metti il grafico p1 sopra p2, uno accanto all’altro o uno sotto l’altro, secondo il layout predefinito.”
Risultato:
a sinistra → mappa NDVI
a destra → ridgeline delle bande

png("grafico_statistico.png")
p1 <- im.ggplot(ndvi)
p2 <- im.ridgeline(stack, scale=1, palette="viridis")
p1 + p2
dev.off()

pdf("grafico_statistico.pdf")
p1 <- im.ggplot(ndvi)
p2 <- im.ridgeline(stack, scale=1, palette="viridis")
p1 + p2
dev.off()

# import from Git
# link to the data
nirgit <- rast("https://raw.githubusercontent.com/ducciorocchini/Telerilevamento_2026/main/Drone/DJI_20260331174728_0001_MS_NIR.TIF")

#### Importing satellite data

getwd()

list.files()

sat <- rast("ISS074-E-417243.jpg")
sat <- flip(sat)
plot(sat)
