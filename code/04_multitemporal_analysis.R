# Code for performing multitemporal analysis with satellite imagery

library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
# install.packages("ggrdiges")
library(ggridges)

im.list()

EN_01 <- im.import("EN_01.png")
EN_01 <- flip(EN_01)
plot(EN_01)

EN_13 <- im.import("EN_13.png")
EN_13 <- flip(EN_13)
plot(EN_13)

# Exercise: plot the two images one on top of the other
im.multiframe(2,1)
plot(EN_01)
plot(EN_13)

# Differencing ##  significa che stai calcolando una differenza banda‑per‑banda tra due immagini raster.
calcola:
la differenza pixel‑per‑pixel tra la banda 1 del 2001 e la banda 1 del 2013  
(o qualunque anno rappresentino EN_01 e EN_13)
Cosa rappresenta questa differenza?
Dipende da cosa contiene la banda 1:
se è NIR → stai calcolando la differenza di riflettanza NIR tra due anni
se è RED → differenza nel rosso
se è una banda termica → differenza di temperatura radiante
se è un indice → differenza dell’indice
In generale:
valori positivi → EN_01 ha valori più alti di EN_13
valori negativi → EN_13 ha valori più alti di EN_01
valori vicini a zero → poca variazione

ENdif <- EN_01[[1]] - EN_13[[1]] 
dev.off()
plot(ENdif)

# Greenland example

# Exercise: import all the greenland data and create a stack
g2000 <- im.import("greenland.2000.tif")
g2005 <- im.import("greenland.2005.tif")
g2010 <- im.import("greenland.2010.tif")
g2015 <- im.import("greenland.2015.tif")
sg <- c(g2000, g2005, g2010, g2015)  ##sg significa che stai creando un unico oggetto chiamato sg che contiene quattro vettori (o raster, o valori numerici) messi uno dopo l’altro
c() significa combine → combina oggetti in un unico vettore.

È utile quando vuoi:
mettere insieme valori di anni diversi
creare un vettore per fare un grafico
calcolare statistiche su più anni
confrontare serie temporali

gr <- im.import("greenland") ##imager interpreta "greenland" come un pattern, non come un singolo file, e quindi:
im.import() funziona così:
se gli dai un nome esatto di file → importa quel file
se gli dai una stringa senza estensione → cerca tutti i file che iniziano o contengono quel nome
se trova più file → li importa tutti e li concatena in un unico oggetto cimg con più frame

im.multiframe(1,2)
plot(gr[[1]], col=plasma(100))
plot(gr[[4]], col=plasma(100))


dif <- gr[[4]] - gr[[1]] ## differenza tra due frame dell’immagine
calcola la differenza pixel‑per‑pixel tra la quarta e la prima immagine
Dipende da cosa sono le immagini:
se sono immagini temporali → differenza tra due anni
se sono bande diverse → differenza spettrale
se sono versioni elaborate → differenza tra due elaborazioni
In generale:
valori positivi → il pixel è più chiaro nella 4ª immagine
valori negativi → il pixel è più scuro nella 4ª immagine
valori vicini a zero → poco cambiamento

dev.off()
plot(dif)

# RGB
im.plotRGB(gr, r=1, g=2, b=4)

# NDVI data
ndvi <- im.import("Sentinel2_NDVI_2020")

# istogrammi
hist(ndvi)

# ridgeline plotting   è una funzione del pacchetto imager che serve per creare una ridgeline plot (grafico a creste) a partire da un’immagine o da un raster.

È un modo molto intuitivo per visualizzare la distribuzione dei valori lungo una dimensione dell’immagine.
Prende un’immagine (nel tuo caso ndvi) e:
la spezza in righe (o colonne)
per ogni riga calcola la distribuzione dei valori
disegna una “cresta” per ogni riga
impila tutte le creste una sopra l’altra
colora le creste con la palette scelta
Perché si usa?
Perché permette di vedere:
come cambiano i valori NDVI lungo l’immagine
pattern spaziali nascosti
gradienti ambientali
distribuzioni multimodali
È molto utile per immagini ecologiche, NDVI, DVI, DEM, ecc.
Spiegazione dei parametri
1. ndvi
È l’immagine da cui estrarre le creste.
Deve essere un oggetto cimg (imager) o convertibile.
2. scale=1
Controlla quanto sono alte le creste.
valori >1 → creste più alte
valori <1 → creste più basse
È un fattore di amplificazione verticale.
3. palette="viridis"
Sceglie la palette di colori.
viridis è ottima perché:
è percettivamente uniforme
funziona bene in stampa
è leggibile anche per daltonici

im.ridgeline(ndvi, scale=1, palette="viridis")

names(ndvi) <- c("02_feb", "05_may", "08_aug", "11_nov") ##Stai dicendo a R:

“L’oggetto ndvi ha 4 layer.
Da ora in poi si chiamano:
02_feb, 05_may, 08_aug, 11_nov.”

# pairs   pairs() crea una matrice di scatterplot tra tutti i layer dell’oggetto
Ogni pannello mostra la relazione tra due mesi.
🎯 A cosa serve?
È utilissimo per:
vedere correlazioni tra mesi
capire se l’NDVI segue un pattern stagionale
individuare outlier
confrontare distribuzioni

pairs(ndvi)

plot(ndvi[[1]], ndvi[[2]])    ## rea uno scatterplot tra i valori del primo e del secondo layer del tuo oggetto ndvi.
È un comando molto utile per capire la relazione tra due immagini NDVI (ad esempio due mesi o due anni).
produce un grafico con:
asse X → valori NDVI del primo layer (02_feb)
asse Y → valori NDVI del secondo layer (05_may)
È uno scatterplot pixel‑per‑pixel.
Ogni punto del grafico è un pixel.
se i punti stanno su una diagonale → i due mesi sono correlati
se i punti sono sparsi → i due mesi sono molto diversi
se ci sono cluster → ci sono tipi di copertura distinti
se c’è una nuvola inclinata → c’è relazione lineare tra i due NDVI

# y = x
# y = a + bx
# y = 0 + 1x = x 
# a = 0
# b = 1

# insert the line x=y   Aggiunge la linea:
𝑦=𝑥 cioè la diagonale perfetta.

Serve come riferimento:
punti sulla linea → NDVI identico nei due layer
punti sopra la linea → NDVI più alto nel secondo layer
punti sotto la linea → NDVI più alto nel primo layer
È uno dei modi più rapidi per vedere cambiamenti di vegetazione.

abline(0, 1)

plot(ndvi[[1]], ndvi[[2]], xlim=c(-0.3,0.9), ylim=c(-0.3,0.9))
abline(0, 1)
