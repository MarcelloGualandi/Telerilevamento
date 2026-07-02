>  #### Marcello Gualandi

# Analisi  dell'avanzamento della Great Green Wall in Senegal (2007 - 2025)

---

# 📌 Introduzione 

La **Great Green Wall** **GGW** è un progetto lanciato dall’Unione Africana nel 2007 per creare un mosaico di paesaggi produttivi verdi lungo una fascia di ~8.000 km dal Senegal a Gibuti.
Gli obiettivi fissati per il 2030 includono:

- 100 milioni di ettari restaurati

- 250 milioni di tonnellate di CO₂ sequestrate

- 10 milioni di posti di lavoro verdi  

La fascia del Sahel è una delle regioni più vulnerabili al cambiamento climatico, con desertificazione crescente e pressioni antropiche.

# 🌍 Area di Studio
Per l'analisi è stata selezionata la **regione di Louga** in **Senegal**, una della aree pilota dell'intero progetto Africano. 

# 🎯 Obiettivi 
Questo progetto ha l'obiettivo di analizzare l'avanzamento e l'efficacia della Great Green Wall attraverso immagini satellitari telerilevate.

# 📄 Materiali e metodi
Le immagini satellitari sono state ricavate attraverso [Google Earth Engine](https://earthengine.google.com/) selezionando le date di riferimento utili all'analisi. 
Per l'immagine satellitare del 2025 è stato utilizzato Sentinel2 mentre per quella del 2007 Landsat in quanto Sentinel-2 non era ancora nato.
> [!NOTE]
> Il codice JavaScript utilizzato è quello fornito durante il corso ed è disponibile nel file Codice.js

## Impostazione della working directory
````r
setwd("~/Desktop/")
````
## Caricamento pacchetti
````r
library(terra)     # Per lavorare con raster e immagini satellitari
library(imageRy)   # Funzioni di visualizzazione rapide
library(viridis)   # Palette di colori
library(ggridges)  # Per creare Ridgeline plot
library(ggplot2)   # Pacchetto per la creazione di grafici
library(patchwork) # Per unire più grafici separati
````
## Importazione immagini raster
````r
ggw2007 <- rast ("GGW_2007.tif") # importazione primo file raster
plot(ggw2007) # visualizzazione 
````
<p align="center">
<img width="565" height="386" alt="plot_ggw2007" src="https://github.com/user-attachments/assets/0b0746b4-0da0-4f30-aab0-da39d7c3735e" />
</p>

> Immagine GGW2007 nelle 5 bande Landsat

````r
ggw2025 <- rast ("GGW_2025.tif") # importazione secondo file raster
plot(ggw2025) # visualizzazione
````
<p align="center">
  <img width="565" height="386" alt="plot_ggw2025t" src="https://github.com/user-attachments/assets/c642d1cd-cb1e-48ca-b48e-4b0dea5c6a62" />
</p>

> Immagine GGW2025 nelle 5 bande Sentinel-2

# Visualizzazione con colori reali (RGB)
### Corrispondenza bande Landsat 5 TM ↔ Sentinel‑2

| Banda | Landsat 5 TM | Sentinel‑2 | Lunghezza d’onda (nm) | Funzione |
|------|--------------|------------|------------------------|----------|
| Blue | SR_B1 | B2 | 450–520 | Suoli chiari, acqua |
| Green | SR_B2 | B3 | 540–580 | Vegetazione moderata |
| Red | SR_B3 | B4 | 630–690 | Assorbimento clorofilla |
| NIR | SR_B4 | B8 | 760–900 | Vegetazione sana |
| SWIR1 | SR_B5 | B11 | 1550–1750 | Umidità del suolo |
| SWIR2 | SR_B7 | B12 | 2080–2350 | Biomassa secca, incendi |

 ````r
# Dobbiamo prima rinominare le bande
names(ggw2007)
## [1] "SR_B1" "SR_B2" "SR_B3" "SR_B4" "SR_B7" 
names(ggw2007) <- c("B2","B3","B4","B8","B12")
im.multiframe(1,2)
plotRGB(ggw2007, r="B4", g="B3", b="B2", stretch="lin", main = "Senegal, GGW 2007")
plotRGB(ggw2025, r="B4", g="B3", b="B2", stretch="lin", main = "Senegal, GGW 2025")
 ````

<p align="center">
<img width="604" height="386" alt="trueggw" src="https://github.com/user-attachments/assets/2652b2f0-18ec-4f06-9356-8b7281b1fb4b" />
</p>


> Le immagini true color mostrano l’evoluzione del paesaggio tra il 2007 e il 2025 utilizzando le bande del visibile (Red, Green, Blue). La visualizzazione RGB consente di interpretare il cambiamento in modo naturale, come sarebbe percepito dall’occhio umano.

### Visualizzazione delle quattro bande separate per entrambe le immagini (RGB + NIR) 
 ````r
im.multiframe(2,2)
plot(ggw2007[[3]], main="B4 - Red (SR_B3)", col = magma(100))
plot(ggw2007[[2]], main="B3 - Green (SR_B2)", col = magma(100))
plot(ggw2007[[1]], main="B2 - Blue (SR_B1)", col = magma(100))
plot(ggw2007[[4]], main="B8 - NIR (SR_B4)", col = magma(100))
 ````
<img width="604" height="386" alt="4bands_2007" src="https://github.com/user-attachments/assets/f3526ce5-74f0-425d-9e66-9cfb7cea9370" />

````r
im.multiframe(2,2)
plot(ggw2025[[1]], main = "B4 - Red", col = magma(100)) 
plot(ggw2025[[2]], main = "B3 - Green", col = magma(100)) 
plot(ggw2025[[3]], main = "B2 - Blue", col = magma(100)) 
plot(ggw2025[[4]], main = "B8 - NIR", col = magma(100)) 
````
<img width="604" height="386" alt="4bands_2025" src="https://github.com/user-attachments/assets/c92b4eba-90aa-45c1-8f1d-dcfacfbbeb6d" />

> La visualizzazione separata delle bande spettrali (Blue, Green, Red, NIR) permette di analizzare la risposta del territorio alle diverse lunghezze d’onda: il suolo riflette maggiormente nel blu e nel rosso, mentre la vegetazione sana mostra valori elevati nel NIR. Questa analisi è fondamentale per interpretare correttamente gli indici di vegetazione.

### Composizione RGB con NIR al post del red
````r
im.multiframe(1,2)
plotRGB(ggw2007, r="B8", g="B4", b="B3", stretch="lin",
                 main="GGW 2007")
plotRGB(ggw2025, r="B8", g="B4", b="B3", stretch="lin",
                 main="GGW 2025")
````
<img width="491" height="386" alt="NIR_inRed" src="https://github.com/user-attachments/assets/aeed8132-6f40-4d37-b99f-376c7a839c12" />


> sostituire il NIR nella banda del RED permette di evidenziare visivamente la vegetazione e il suo cambiamento tra 2007 e 2025. si evidenziano le zone di vegetazione (rosso) e gialle le zone aride.

### Analisi DVI 
Il DVI (Difference Vegetation Index) è uno dei più semplici indici spettrali utilizzati per valutare la presenza e la vitalità della vegetazione.
Si calcola sottraendo la riflettanza nel rosso (Red) da quella nel vicino infrarosso (NIR).

***DVI*** = ***NIR** - *Red*

Le piante sane riflettono molto nel NIR e poco nel rosso, quindi valori alti di DVI indicano vegetazione vigorosa.
È un indice non normalizzato, ma fornisce indicazioni dirette sulla biomassa verde e può essere utile per analisi comparative quando le condizioni di acquisizione sono simili. 
````r
dvi_2007 <- im.dvi(ggw2007, 4, 1)   
dvi_2025 <- im.dvi(ggw2025, 4, 1)
# Visualizzazione della DVI
im.multiframe(1, 2)
plot(dvi_2007, col = viridis(100), main = "DVI 2007")
plot(dvi_2025, col = viridis(100), main = "DVI 2025")
````
<img width="604" height="386" alt="DVI_2007:2025" src="https://github.com/user-attachments/assets/177105df-3c31-47fa-acc0-409f0d26ad60" />

````r
ggw2007_res <- terra::resample(ggw2007, ggw2025, method="bilinear") # dobbiamo 
dvi_2007_res <- ggw2007_res[["B4"]] - ggw2007_res[["B3"]]
dvi_2025_res <- ggw2025[["B4"]] - ggw2025[["B3"]]
dvi_diff <- dvi_2025_res - dvi_2007_res
im.multiframe (1,1)
plot(dvi_diff, col=magma(100), main="Differenza DVI (2025 - 2007)")
````
<img width="491" height="386" alt="diff_DVI" src="https://github.com/user-attachments/assets/76afd38b-7f2d-4225-9f68-d26e5d53d929" />

> Questa rappresentazione permette di individuare in modo immediato le zone che hanno beneficiato maggiormente degli interventi di ripristino.

#  Analisi NDVI (Normalized Difference Vegetation Index)
Il NDVI è uno degli indici di vegetazione più diffusi in telerilevamento grazie alla sua capacità di normalizzare le differenze tra immagini acquisite in tempi o condizioni diverse.
Si calcola come:
NDVI = (NIR − Red) / (NIR + Red)  

I valori ottenuti variano tra -1 e +1: valori vicini a +1 indicano vegetazione densa e sana, mentre valori prossimi a 0 o negativi indicano suolo nudo, rocce o acqua.
L'NDVI è particolarmente utile per monitorare variazioni nella copertura vegetale nel tempo e valutare stress idrici, cambiamenti climatici o impatti antropici, come nel caso di pascoli intensivi.

$` NDVI = \frac{(NIR - Red)}{(NIR + Red)} `$  
````r
## # Per semplificare si userà la funzione im.ndvi(), che è una funzione del pacchetto imageRy
ndvi_2007 <- im.ndvi(ggw2007, 4, 1)   
ndvi_2025 <- im.ndvi(ggw2025, 4, 1) 
# Creazione di un pannello multiframe isualizzazione NDVI
im.multiframe(1, 2)
plot(ndvi_2007, col = viridis(100), main = "NDVI 2007")
plot(ndvi_2025, col = viridis(100), main = "NDVI 2025")
````
<img width="604" height="386" alt="NDVI" src="https://github.com/user-attachments/assets/9956214e-d2f7-4777-936f-a38e4bb4a8dd" />

> **Valori alti:** vegetazione sana e densa
> **Valori bassi:** suolo nudo e vegetazione scarsa

## Ridgeline plot 
>[!TIP]
> Il ridgeplot consente di confrontare visivamente la distribuzione dell’indice NDVI tra il 2015 e il 2025, evidenziando eventuali variazioni nella densità e nello stato della vegetazione nel tempo.
````r
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

````
<img width="491" height="386" alt="RidgelinePlot" src="https://github.com/user-attachments/assets/6ac11fef-403a-431e-99a7-7682de00206a" />

> Il ridgeline confronta la distribuzione dei valori NDVI tra il 2007 e il 2025. Le curve sono etichettate e colorate in modo distinto: la curva del 2007 (magma) mostra valori più bassi e concentrati, mentre quella del 2025 (viridis) è spostata verso valori più elevati, indicando un aumento della copertura vegetale. Il grafico evidenzia chiaramente il miglioramento della vegetazione nel periodo considerato.

## Classificazione per classi di vegetazione
 ````r
## Scelta del range di valori adatto alla classificazione
# Si fa riferimento agli istogrammi della distribuzione  dell'NDVI:
hist(ndvi_2007, main = "NDVI 2007", col = "darkgreen")  
hist(ndvi_2025, main = "NDVI 2025", col = "darkblue")
 ````
<details>
<summary>Istogrammi (cliccare qui)</summary>  
<img width="491" height="386" alt="Hist_2007" src="https://github.com/user-attachments/assets/d7e4a3b4-4e02-4eed-8144-3debf0501da6" />
<img width="491" height="386" alt="Hist_2025" src="https://github.com/user-attachments/assets/578c1b63-05d2-4bec-83db-e9f950cd42bb" />

> Gli istogrammi servono per scegliere soglie significative
</details>

 ````r
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
 ````
<img width="604" height="386" alt="class_NDVI" src="https://github.com/user-attachments/assets/e29e8231-c2a5-4c8c-ba96-2d78a31306ca" />

> La classificazione NDVI mostra un paesaggio omogeneo nel 2007 (classe unica), mentre nel 2025 compaiono tre classi che evidenziano una maggiore variabilità della vegetazione: dalle aree degradate (classe 1) a quelle con copertura vegetale densa (classe 3). Il confronto indica un miglioramento generale della vegetazione, seppur con differenze spaziali marcate.

## Calcolo percentuali
 ````r
# Frequenze
freq_2007 <- freq(ndvi_2007_cl) # numero di pixel per classe.
freq_2025 <- freq(ndvi_2025_cl)
tot2007 <- sum(freq_2007$count) # numero totale di pixel per anno.
tot2025 <- sum(freq_2025$count)

# trasformiamo in percentuali garantendo tre classi
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
# Tabella
tab <- data.frame(
  classi = c("Suolo nudo", "Vegetazione media", "Vegetazione sana"),
  a2007 = round(perc_2007, 2),
  a2025 = round(perc_2025, 2)
)
print(tab) ##       classi a2007 a2025
 # 1        Suolo nudo     0  0.73
 # 2 Vegetazione media     1  0.27
 # 3  Vegetazione sana     0  0.00
 ````
Si riportano i risultati in una tabella:
### Confronto classi NDVI (2007 vs 2025)

| Classe | Descrizione         | 2007 | 2025 |
|-------|----------------------|------|------|
| 1     | Suolo nudo           | 0    | 0.73 |
| 2     | Vegetazione media    | 1    | 0.27 |
| 3     | Vegetazione sana     | 0    | 0.00 |

 (utilizza ora altre soglie per mettere in maggiore evidenza gli sforzi) 

## Visualizzazione ( da riguardare)

````r
f <- data.frame(
  Classe = c("Suolo nudo", "Vegetazione media", "Vegetazione sana"),
  `2007` = c(0, 1, 0),
  `2025` = c(0.73, 0.27, 0),
  check.names = FALSE   # mantiene i nomi delle colonne così come li scrivi
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
````
<img width="491" height="386" alt="cfr_classi" src="https://github.com/user-attachments/assets/47910bb9-b4f4-4799-b001-d2b6247902ab" />

> i grafici sembrano mostrare un peggioramento dello stato di degrado e desertificazione ma è da analizzare come il terreno sia stato modellato per l'agricoltura.

## 📉 Analisi multitemporale
L'analisi multitemporale ha permesso di confrontare i dati telerilevati del 2007 e del 2025, focalizzandosi in particolare sulla banda del NIR e sull'indice NDVI, al fine di evidenziare variazioni significative nello stato della vegetazione nell’arco di quasi vent'anni.
````r
# rinominiamo le bande e portiamo il NIR del 2007 alla griglia del 2025
nir_2007 <- ggw2007[["B4"]]   # Landsat NIR 
nir_2007_res <- terra::resample(nir_2007, ggw2025[[4]], method="bilinear")
## stessa cosa per il NDVI
ndvi_2007_res <- terra::resample(ndvi_2007, ndvi_2025, method="bilinear")
ndvi_diff <- ndvi_2025 - ndvi_2007_res
im.multiframe(1, 2)
plot(nir_diff, col = viridis(100), main = "NIR (2025 - 2017)")
plot(ndvi_diff, col = viridis(100), main = "NDVI (2025 - 2017)")
````
<img width="604" height="386" alt="Multitemporal" src="https://github.com/user-attachments/assets/47677fff-db62-4b51-a3cb-2ac4c2b923bd" />

## 📌 Commenti e Conclusioni

## Bibliografia
