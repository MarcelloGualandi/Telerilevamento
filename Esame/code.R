
setwd("~/Desktop/")
library(terra)  
library(imageRy)  
library(viridis)
library(ggridges)
library(ggplot2)  
library(patchwork) 
library(tidyr)
list.files()
bk2007 <- rast ("BURKINA_2007.tif")
bk2025 <- rast ("BURKINA_2025.tif")
plot(bk2007)
plot(bk2025)

names(bk2007)
# [1] "SR_B1" "SR_B2" "SR_B3" "SR_B4" "SR_B7"
names(bk2007) <- c("B2","B3","B4","B8","B12") ## per rinominare bande
im.multiframe(1,2) ## true color
plotRGB(bk2007, r="B4", g="B3", b="B2", stretch="lin",
        main = "Burkina Faso, GGW 2007")
plotRGB(bk2025, r="B4", g="B3", b="B2", stretch="lin",
        main = "Burkina Faso, GGW 2025")
# Visualizzazione separata delle quattro bande (RGB e NIR) per entrambe le immagini    
im.multiframe(2,2)
plot(bk2007[[3]], main="B4 - Red (SR_B3)", col = magma(100))
plot(bk2007[[2]], main="B3 - Green (SR_B2)", col = magma(100))
plot(bk2007[[1]], main="B2 - Blue (SR_B1)", col = magma(100))
plot(bk2007[[4]], main="B8 - NIR (SR_B4)", col = magma(100))


im.multiframe(2,2)
plot(bk2025[[1]], main = "B4 - Red", col = magma(100)) 
plot(bk2025[[2]], main = "B3 - Green", col = magma(100)) 
plot(bk2025[[3]], main = "B2 - Blue", col = magma(100)) 
plot(bk2025[[4]], main = "B8 - NIR", col = magma(100)) 

## Sostituendo il NIR al posto della banda del red, si evidenziano le zone di vegetazione (blu) e tutto ciò che non è vegetazione (giallo).
im.multiframe(1,2)
plotRGB(bk2007, r="B8", g="B4", b="B3", stretch="lin",
        main="Burkina Faso, GGW 2007")
plotRGB(bk2025, r="B8", g="B4", b="B3", stretch="lin",
        main="Burkina Faso, GGW 2025")

## calcolo DVI,  Per semplificare si userà la funzione im.dvi(), che è una funzione del pacchetto imageRy 
dvi_2007 <- im.dvi(bk2007, 4, 1)   
dvi_2025 <- im.dvi(bk2025, 4, 1)  

# Visualizzazione della DVI
im.multiframe(1, 2)
plot(dvi_2007, col = viridis(100), main = "DVI 2007")
plot(dvi_2025, col = viridis(100), main = "DVI 2025")

# Calcolo e visualizzazione differenza DVI  
## i due raster NON hanno la stessa estensione, dimensione o risoluzione QUINDI dobbiamo portare il 2007 alla stessa risoluzione del 2025
bk2007_res <- terra::resample(bk2007, bk2025, method="bilinear")
dvi_2007_res <- bk2007_res[["B4"]] - bk2007_res[["B3"]]
dvi_2025_res <- bk2025[["B4"]] - bk2025[["B3"]]
dvi_diff <- dvi_2025_res - dvi_2007_res
im.multiframe(1,1)
plot(dvi_diff, col=magma(100), main="Differenza DVI (2025 - 2007)")

# Analisi NDVI
## # Per semplificare si userà la funzione im.ndvi(), che è una funzione del pacchetto imageRy 
ndvi_2007 <- im.ndvi(bk2007, 4, 1)   
ndvi_2025 <- im.ndvi(bk2025, 4, 1) 
# Creazione di un pannello multiframe isualizzazione NDVI
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

# 3) Ridgeline con palette differenziata
im.ridgeline(
  GGW_ridg,
  scale = 2,
  palette = c("magma", "viridis")  # 2007 = viola/rosso, 2025 = verde/giallo
)

## Classificazione per classi di vegetazione
## Scelta del range di valori adatto alla classificazione
# Si fa riferimento agli istogrammi della distribuzione  dell'NDVI:
hist(ndvi_2007, main = "NDVI 2007", col = "darkgreen")  
hist(ndvi_2025, main = "NDVI 2025", col = "darkblue")

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

## miglior visual
# ============================
# ============================
# 1) CREAZIONE DEL DATA FRAME
# ============================

df <- data.frame(
  Classe = c("Suolo nudo", "Vegetazione media", "Vegetazione sana"),
  `2007` = c(1.00, 0.00, 0.00),
  `2025` = c(0.50, 0.47, 0.03),
  check.names = FALSE
)

# ============================
# 2) CONVERSIONE IN FORMATO LONG
# ============================

df_long <- df %>%
  pivot_longer(
    cols = c("2007", "2025"),
    names_to = "Anno",
    values_to = "Percentuale"
  )

# ============================
# 3) GRAFICO LEGGIBILE
# ============================

ggplot(df_long, aes(x = Classe, y = Percentuale, fill = Anno)) +
  geom_col(position = "dodge", width = 0.7) +
  geom_text(aes(label = Percentuale),
            position = position_dodge(width = 0.7),
            vjust = -0.5, size = 4) +
  scale_fill_manual(values = c("2007" = "#440154", "2025" = "#2FB47C")) +
  labs(
    title = "Confronto classi NDVI 2007 vs 2025",
    y = "Percentuale",
    x = "Classe NDVI"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "top",
    axis.text.x = element_text(angle = 20, hjust = 1)
  )

## Analisi multitemporale
# L'analisi multitemporale ha permesso di confrontare i dati telerilevati del 2007 e del 2025, focalizzandosi in particolare sulla banda del NIR e sull'indice NDVI, al fine di evidenziare variazioni significative nello stato della vegetazione nell’arco di quasi vent'anni.
# rinominiamo le bande e portiamo il NIR del 2007 alla griglia del 2025
nir_2007 <- bk2007[["B4"]]   # Landsat NIR 
nir_2007_res <- terra::resample(nir_2007, bk2025[[4]], method="bilinear")

nir_diff <- bk2025[[4]] - nir_2007_res

## stessa cosa per il NDVI
ndvi_2007_res <- terra::resample(ndvi_2007, ndvi_2025, method="bilinear")
ndvi_diff <- ndvi_2025 - ndvi_2007_res

im.multiframe(1, 2)
plot(nir_diff, col = viridis(100), main = "NIR (2025 - 2007)")
plot(ndvi_diff, col = viridis(100), main = "NDVI (2025 - 2007)")
