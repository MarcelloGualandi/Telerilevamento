setwd("~/Desktop/")
library(terra)  
library(imageRy)  
library(viridis)
library(ggridges)
library(ggplot2)  
library(patchwork) 
library(tidyr)
list.files()
bk2007 <- rast ("Sampelga_2007.tif")
bk2025 <- rast ("Sampelga_2025.tif")
plot(bk2007)
plot(bk2025)

names(bk2007)
# [1] "SR_B1" "SR_B2" "SR_B3" "SR_B4" "SR_B7"
names(bk2007) <- c("B2","B3","B4","B8","B12") ## per rinominare bande
im.multiframe(1,2) ## true color
plotRGB(bk2007, r="B4", g="B3", b="B2", stretch="hist",
        main = "Sampelga, GGW 2007")
plotRGB(bk2025, r="B4", g="B3", b="B2", stretch="hist",
        main = "Sampelga, GGW 2025")

# range per vedere in che scala si trovano le bande
range(bk2007)
range(bk2025)
# Visualizzazione separata delle quattro bande (RGB e NIR) per entrambe le immagini    
im.multiframe(2,2)
plot(bk2007[[3]], main="B4 - Red (SR_B3)", col = magma(100))
plot(bk2007[[2]], main="B3 - Green (SR_B2)", col = magma(100))
plot(bk2007[[1]], main="B2 - Blue (SR_B1)", col = magma(100))
plot(bk2007[[4]], main="B8 - NIR (SR_B4)", col = magma(100))


# RGB e NIR 2025
im.multiframe(2,2)
plot(bk2025[[1]], main = "B4 - Red", col = magma(100)) 
plot(bk2025[[2]], main = "B3 - Green", col = magma(100)) 
plot(bk2025[[3]], main = "B2 - Blue", col = magma(100)) 
plot(bk2025[[4]], main = "B8 - NIR", col = magma(100)) 

#visualizziamo lo Swir
im.multiframe(1,2)
plot(bk2007[[5]], main="B12 - SWIR2 (SR_B7)", col = magma(100)) # divido per 10
plot(bk2025[[5]], main = "B12 - SWIR2", col = magma(100))

## Sostituendo il NIR al posto della banda del red, si evidenziano le zone di vegetazione (blu) e tutto ciò che non è vegetazione (giallo).
im.multiframe(1,2)
plotRGB(bk2007, r="B8", g="B4", b="B3", stretch="hist",
        main="Sampelga, GGW 2007")
plotRGB(bk2025, r="B8", g="B4", b="B3", stretch="hist",
        main="Sampelga, GGW 2025")

## ## calcolo DVI,  Per semplificare si userà la funzione im.dvi(), che è una funzione del pacchetto imageRy 
bk2007_norm <- bk2007 / 10 # normalizziamo i valori per il 2007
dvi_2007 <- im.dvi(bk2007_norm, 4, 1)
dvi_2025 <- im.dvi(bk2025, 4, 1)
# Visualizzazione della DVI
im.multiframe(1, 2)
plot(dvi_2007, col = viridis(100), main = "DVI 2007")
plot(dvi_2025, col = viridis(100), main = "DVI 2025")

# Calcolo e visualizzazione differenza DVI  
## i due raster NON hanno la stessa estensione, dimensione o risoluzione QUINDI dobbiamo portare il 2007 alla stessa risoluzione del 2025

bk2007_norm_res <- terra::resample(bk2007_norm, bk2025, method="bilinear")
dvi_2007_res <- bk2007_norm_res[["B4"]] - bk2007_norm_res[["B3"]]
dvi_2025_res <- bk2025[["B4"]] - bk2025[["B3"]]
dvi_diff <- dvi_2025_res - dvi_2007_res
im.multiframe(1,1)
plot(dvi_diff, col = magma(100), main = "Differenza DVI (2025 - 2007)")



# Analisi NDVI
## # Per semplificare si userà la funzione im.ndvi(), che è una funzione del pacchetto imageRy 
ndvi_2007 <- im.ndvi(bk2007, 4, 1)   
ndvi_2025 <- im.ndvi(bk2025, 4, 1) 
# Creazione di un pannello multiframe visualizzazione NDVI
im.multiframe(1, 2)
plot(ndvi_2007, col = viridis(100), main = "NDVI 2007")
plot(ndvi_2025, col = viridis(100), main = "NDVI 2025")

## Ridgeline plot
# Per cominciare si crea un vettore per visualizzare le due immagini contemporaneamente
# 1) Ricampionamento NDVI 2007 sulla griglia del 2025
ndvi_2007_res <- terra::resample(ndvi_2007, ndvi_2025, method = "bilinear")

# 2) Creazione del vettore con nomi chiari
GGW_ridg <- c(ndvi_2007_res, ndvi_2025)
names(GGW_ridg) <- c("NDVI_2007", "NDVI_2025")

# 3) Ridgeline 
im.ridgeline(
  GGW_ridg,
  scale = 2,
  palette = "magma")

## Scatter plot
ndvi_2007_res <- terra::resample(ndvi_2007, ndvi_2025, method = "bilinear") # stessa estensione
ndvi <- c(ndvi_2007_res, ndvi_2025)
# Pairs plot
pairs(ndvi,
      main = "Matrice scatterplot NDVI 2007–2025")
# Scatter plot NDVI 2007 vs NDVI 2025
plot(ndvi[[1]], ndvi[[2]], xlab="NDVI 2007", ylab="NDVI 2025", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
abline(0, 1, col="red")  


## Classificazione per classi di vegetazione
## Scelta del range di valori adatto alla classificazione
# Si fa riferimento agli istogrammi della distribuzione  dell'NDVI:
hist(ndvi_2007, main = "NDVI 2007", col = "darkgreen")  
hist(ndvi_2025, main = "NDVI 2025", col = "darkblue")

## 3 classi
class_matrix <- matrix(c(-Inf, 0.2, 1, 
                         0.2, 0.4, 2, 
                         0.4, Inf, 3), 
                       ncol = 3, byrow = TRUE)
class_matrix
#  [,1] [,2] [,3]
# [1,] -Inf  0.2    1       # Se NDVI < 0.2 allora si associa una classe di tipo 1 (Suolo nudo)
# [2,]  0.2  0.4    2       # Se 0.2 ≤ NDVI < 0.4 allora si associa una classe di tipo 2 (Vegetazione media)
# [3,]  0.4  Inf    3       # Se NDVI ≥ 0.4 allora si associa una classe di tipo 3 (Vegetazione sana)

ndvi_2007_cl <- classify(ndvi_2007, class_matrix) 
ndvi_2025_cl <- classify(ndvi_2025, class_matrix)  
im.multiframe(1, 2)
plot(ndvi_2007_cl, col = c("orange", "yellow", "darkgreen"), main = "NDVI class. 2007")
plot(ndvi_2025_cl, col = c("orange", "yellow", "darkgreen"), main = "NDVI class. 2025")

# Calcolo percentuali
# Frequenze
freq_2007 <- freq(ndvi_2007_cl)
freq_2025 <- freq(ndvi_2025_cl)

# Percentuali
# trasformiamo in percentuali garantendo tre classi

tot2007 <- sum(freq_2007$count)
tot2025 <- sum(freq_2025$count)

perc_2007 <- c(
  ifelse(1 %in% freq_2007$value, freq_2007$count[freq_2007$value==1] / tot2007, 0),
  ifelse(2 %in% freq_2007$value, freq_2007$count[freq_2007$value==2] / tot2007, 0),
  ifelse(3 %in% freq_2007$value, freq_2007$count[freq_2007$value==3] / tot2007, 0)
)

perc_2025 <- c(
  ifelse(1 %in% freq_2025$value, freq_2025$count[freq_2025$value==1] / tot2025, 0),
  ifelse(2 %in% freq_2025$value, freq_2025$count[freq_2025$value==2] / tot2025, 0),
  ifelse(3 %in% freq_2025$value, freq_2025$count[freq_2025$value==3] / tot2025, 0)
)

# Visualizzazione
tab <- data.frame(
  classi = c("Suolo nudo", "Vegetazione media", "Vegetazione sana"),
  a2007 = round(perc_2007 * 100, 2),
  a2025 = round(perc_2025 * 100, 2)
)
print(tab)
p1 <- ggplot(tab, aes(x = classi, y = a2007, fill = classi)) +    
  geom_bar(stat = "identity") +
  scale_fill_viridis_d() +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2007", y = "%", x = NULL) +
  theme_minimal()

p2 <- ggplot(tab, aes(x = classi, y = a2025, fill = classi)) +
  geom_bar(stat = "identity") +
  scale_fill_viridis_d() +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2025", y = "%", x = NULL) +
  theme_minimal()

p1 + p2      # Grazie al pacchetto patchwork si possono unire i grafici in questo modo


## utilizziamo altre soglie per definire più classi. 5 classi

class_matrix_sahel <- matrix(c(
  -Inf, 0.05, 0,   # Ombra, roccia, acqua, suolo molto scuro
  0.05, 0.20, 1,  # Suolo nudo / vegetazione erbacea molto rada
  0.20, 0.35, 2,  # Vegetazione erbacea/arbustiva discontinua
  0.35, 0.50, 3,  # Vegetazione arbustiva/arborea moderata (GGW in crescita)
  0.50, Inf, 4    # Vegetazione arborea/arbustiva densa (nuclei di successo GGW)
), 
ncol = 3, byrow = TRUE)

class_matrix_sahel
#     [,1] [,2] [,3]
# [1,] -Inf 0.05    0
# [2,] 0.05 0.20    1
# [3,] 0.20 0.35   2
# [4,] 0.35 0.50    3
# [5,] 0.50  Inf    4

ndvi_2007_cl <- classify(ndvi_2007, class_matrix_sahel)
ndvi_2025_cl <- classify(ndvi_2025, class_matrix_sahel)
pal_sahel_cb <- c(
  "#000000",  # Classe 0 - ombra / roccia / acqua
  "#E41A1C",  # Classe 1 - suolo nudo
  "#377EB8",  # Classe 2 - erbacee / arbusti bassi
  "#4DAF4A",  # Classe 3 - arbusti attivi
  "#984EA3"   # Classe 4 - vegetazione densa
)

im.multiframe(1, 2)
plot(ndvi_2007_cl, col = pal_sahel_cb, main = "NDVI class. 2007")
plot(ndvi_2025_cl, col = pal_sahel_cb, main = "NDVI class. 2025")

# Calcolo percentuali
# Frequenze
freq_2007 <- freq(ndvi_2007_cl)
freq_2025 <- freq(ndvi_2025_cl)

# Percentuali
# trasformiamo in percentuali garantendo tre classi

tot2007 <- sum(freq_2007$count)
tot2025 <- sum(freq_2025$count)

perc_2007 <- c(
  ifelse(1 %in% freq_2007$value, freq_2007$count[freq_2007$value==1] / tot2007, 0),
  ifelse(2 %in% freq_2007$value, freq_2007$count[freq_2007$value==2] / tot2007, 0),
  ifelse(3 %in% freq_2007$value, freq_2007$count[freq_2007$value==3] / tot2007, 0)
)

perc_2025 <- c(
  ifelse(1 %in% freq_2025$value, freq_2025$count[freq_2025$value==1] / tot2025, 0),
  ifelse(2 %in% freq_2025$value, freq_2025$count[freq_2025$value==2] / tot2025, 0),
  ifelse(3 %in% freq_2025$value, freq_2025$count[freq_2025$value==3] / tot2025, 0)
)
tab <- data.frame(
  Classe = c("0 - Ombra/suolo scuro",
             "1 - Suolo nudo",
             "2 - Erbacee/arbusti bassi",
             "3 - Arbusti attivi",
             "4 - Vegetazione densa"),
  Perc_2007 = round(perc_2007, 2),
  Perc_2025 = round(perc_2025, 2)
)

print(tab)


# Visualizzazione
tab <- data.frame(
  classi = c("Suolo nudo", "Vegetazione media", "Vegetazione sana"),
  a2007 = round(perc_2007 * 100, 2),
  a2025 = round(perc_2025 * 100, 2)
)
print(tab)
p1 <- ggplot(tab, aes(x = classi, y = a2007, fill = classi)) +    
  geom_bar(stat = "identity") +
  scale_fill_viridis_d() +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2007", y = "%", x = NULL) +
  theme_minimal()

p2 <- ggplot(tab, aes(x = classi, y = a2025, fill = classi)) +
  geom_bar(stat = "identity") +
  scale_fill_viridis_d() +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2025", y = "%", x = NULL) +
  theme_minimal()

p1 + p2      # Grazie al pacchetto patchwork si possono unire i grafici in questo modo

## Ora facciamolo con le 5 classi

## 5 classi
class_matrix_sahel <- matrix(c(
  -Inf, 0.05, 0,   # Classe 0 – Ombra / suolo scuro / acqua
  0.05, 0.20, 1,  # Classe 1 – Suolo nudo / erbacee molto rade
  0.20, 0.35, 2,  # Classe 2 – Erbacee / arbusti bassi discontinui
  0.35, 0.50, 3,  # Classe 3 – Arbusti attivi / vegetazione moderata
  0.50, Inf,  4   # Classe 4 – Vegetazione densa
), ncol = 3, byrow = TRUE)
class_matrix_sahel

ndvi_2007_cl <- classify(ndvi_2007, class_matrix_sahel)
ndvi_2025_cl <- classify(ndvi_2025, class_matrix_sahel)

im.multiframe (1,2)
plot(ndvi_2007_cl, col = viridis(5), main = "NDVI class. 2007")
plot(ndvi_2025_cl, col = viridis(5), main = "NDVI class. 2025")

# calcolo frequenze e percentuali
freq_2007 <- freq(ndvi_2007_cl)
freq_2025 <- freq(ndvi_2025_cl)

tot2007 <- sum(freq_2007$count)
tot2025 <- sum(freq_2025$count)

# 4. # Funzione per estrarre percentuali garantendo tutte le classi
# ---------------------------------------------------------

get_perc <- function(freq, tot) {
  sapply(0:4, function(k) {
    if (k %in% freq$value) freq$count[freq$value == k] / tot else 0
  })
}

perc_2007 <- get_perc(freq_2007, tot2007)
perc_2025 <- get_perc(freq_2025, tot2025)

# 5. Tabella finale (coerente con i grafici)
# ---------------------------------------------------------

tab <- data.frame(
  classi = c("0 - Ombra/suolo scuro",
             "1 - Suolo nudo",
             "2 - Erbacee/arbusti bassi",
             "3 - Arbusti attivi",
             "4 - Vegetazione densa"),
  Perc_2007 = round(perc_2007 * 100, 2),
  Perc_2025 = round(perc_2025 * 100, 2),
  check.names = FALSE
)

print(tab)

# 6. Grafici comparativi NDVI classi
# ---------------------------------------------------------

p1 <- ggplot(tab, aes(x = classi, y = Perc_2007, fill = classi)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = Perc_2007), vjust = -0.5, size = 4) +
  scale_fill_viridis_d(option = "C") +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2007", y = "%", x = NULL) +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "right")

p2 <- ggplot(tab, aes(x = classi, y = Perc_2025, fill = classi)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = Perc_2025), vjust = -0.5, size = 4) +
  scale_fill_viridis_d(option = "C") +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2025", y = "%", x = NULL) +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "right")

# Visualizzazione affiancata
p1 + p2


## Analisi multitemporale
# L'analisi multitemporale ha permesso di confrontare i dati telerilevati del 2007 e del 2025, focalizzandosi in particolare sulla banda del NIR e sull'indice NDVI, al fine di evidenziare variazioni significative nello stato della vegetazione nell’arco di quasi vent'anni.
# rinominiamo le bande e portiamo il NIR del 2007 alla griglia del 2025
nir_2007 <- bk2007[["B4"]] / 10   # riscalato
nir_2007_res <- terra::resample(nir_2007, bk2025[[4]], method="bilinear")
nir_diff <- bk2025[[4]] - nir_2007_res

## stessa cosa per il NDVI
ndvi_2007_res <- terra::resample(ndvi_2007, ndvi_2025, method="bilinear")
ndvi_diff <- ndvi_2025 - ndvi_2007_res

im.multiframe(1, 2)
plot(nir_diff, col = viridis(100), main = "NIR (2025 - 2007)")
plot(ndvi_diff, col = viridis(100), main = "NDVI (2025 - 2007)")




