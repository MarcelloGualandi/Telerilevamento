>  #### Marcello Gualandi

# Analisi dell'avanzamento della Great Green Wall in Burkina Faso (2007 - 2025)

---

# 📌 Introduzione 

La **Great Green Wall** **GGW** è un progetto lanciato dall’Unione Africana nel 2007 per contrastare la desertificazione, la perdita di biodiversità e la crescente vulnerabilità climatica del Sahel. Il progetto mira a realizzare un mosaico di paesaggi restaurati lungo circa 8000 km, dal Senegal al Gibuti, attraverso interventi di riforestaizione, agricoltura rigenerativa e gestione sostenibile del territorio.
La fascia del Sahel rappresenta una delle regioni più esposte agli effetti del cambiamento climatico: avanzamento della desertificazione, degrado del suolo, riduzione della produttività primaria e pressioni antropiche sempre più intense hanno reso questo territorio sempre meno abitabile. 
In questo contesto la **GGW** agisce come una strategia integrata di adattamento e mitigazione con ambizioni obiettivi fissati per il 2030: 

- 100 milioni di ettari restaurati
- 250 milioni di tonnellate di  CO₂ sequestrate
- 10 milioni di posti di lavoro verdi nelle comunità rurali

Nonostante la portata del progetto, la valutazione dell'effiacia degli interventi rimane una delle sfide principale. La mancanza di metodologie standardizzate e di monitoraggi sistematici ha portata ad una comprensione limitata dei progressi reali.
Il **telerilevamento** offre una soluzione concreta a queste criticità poichè consente un monitoraggio continuo, oggettivo ed economicamente sostenibile, capace di tracciare con precisione i progressi della Great Green Wall.

# 🌍 Area di Studio
Per l'analisi è stata selezionata la **regione di Sampelga** in **Burkina Faso** caratterizzata da una piovosità media annua di cira 400 mm con piogge che si concentrano nei mesi tra giugno e settembre.
La vegetazione è dominata da una savana arbustiva con copertura erbacea discontinua che emergono esclusivamente durante la stagione delle piogge.

<img width="3507" height="2480" alt="layout" src="https://github.com/user-attachments/assets/f05b6dbe-bc54-4949-8b7f-eb5e7dba8cb5" />

> **Fig 1:** Area di Sampelga in Burkina Faso. Si evidenzia anche l'intera fascia africana del Sahel 

# 🎯 Obiettivi 
Questo progetto ha l'obiettivo di analizzare l'avanzamento e l'efficacia  della Great Green Wall attraverso immagini satellitari e l'uso di indici di vegatazione. 

# 📄 Materiali e metodi
Le immagini satellitari sono state ricavate attraverso [Google Earth Engine](https://earthengine.google.com/).
Per l'analisi del 2025 è stato utilizzato **Sentinel-2** che fornisce dati multispettralii con risoluzione spaziale di 10-20 m.
Per l'analisi del 2007 invece è stato utilizzato **Landsat 5 TM**, in quanto Sentinel-2 non era ancora operativo. Landsat garantisce comunque una risoluzione di 30 m e una copertura temporale continua. 
Le date di acquisizione sono state selezionate in modo da rappresentare in maniera coerente la stagione vegetativa dei siti di studio (giugno - settembre).
> [!NOTE]
> Il codice JavaScript utilizzato è quello fornito durante il corso ed è disponibile nel file Code.js

## Caricamento pacchetti
````r
library(terra)     # Per lavorare con raster e immagini satellitari
library(imageRy)   # Funzioni di visualizzazione rapide
library(viridis)   # Palette di colori
library(ggridges)  # Per creare Ridgeline plot
library(ggplot2)   # Pacchetto per la creazione di grafici
library(patchwork) # Per unire più grafici separati
library(tidyr)
````
## Importazione immagini raster
````r
bk2007 <- rast ("Sampelga_2007.tif") # importazione primo file raster
plot(bk2007) plot(ggw2007) # visualizzazione
````
<p align="center">
<img width="1118" height="537" alt="bk2007" src="https://github.com/user-attachments/assets/c2b38b6b-2e0f-4b50-8fa2-763eda8b9831" />


</p>

> Immagine GGW2007 nelle 5 bande Landsat

````r
bk2025 <- rast ("Sampelga_2025.tif")  # importazione secondo file raster
plot(bk2025)  # visualizzazione
````
<p align="center">
<img width="1118" height="509" alt="bk2025" src="https://github.com/user-attachments/assets/80bd289e-58bd-42b2-9741-3f92c2e789bd" />

</p>

> Immagine GGW2025 nelle 5 bande Sentinel-2

<!-- Le diverse bande mostrano differenze nella risposta spettrale, ogni banda evidenza pattern diversi della stessa area, perchè ciascusa risposnde a componenti differenti della superficie. 
- B2 (blue) valori bassi, utile per discriminare acqua/ombra e suoli molto chiari 
- B3 (green) valori leggermente più alti, sensibile alla vegetazione iniziale
- B4 (red) evidenzia bene suoli nudi e aree degradate
- B8 (NIR) mostra le zone con maggiore biomassa (valori + alti)
- B12 (SWIR2) sensibile a umidità del suolo e stress idrico -->

# Visualizzazione con colori reali (RGB)
### Corrispondenza bande Landsat 5 TM ↔ Sentinel‑2

 Banda | Landsat 5 TM | Sentinel‑2 | Lunghezza d’onda (nm) | Funzione |
|------|--------------|------------|------------------------|----------|
| Blue | SR_B1 | B2 | 450–520 | Suoli chiari, acqua |
| Green | SR_B2 | B3 | 540–580 | Vegetazione moderata |
| Red | SR_B3 | B4 | 630–690 | Assorbimento clorofilla |
| NIR | SR_B4 | B8 | 760–900 | Vegetazione sana |
| SWIR1 | SR_B5 | B11 | 1550–1750 | Umidità del suolo |
| SWIR2 | SR_B7 | B12 | 2080–2350 | Umidità del suolo, Biomassa secca, incendi |

````r
# Dobbiamo prima rinominare le bande
names(bk2007)
# [1] "SR_B1" "SR_B2" "SR_B3" "SR_B4" "SR_B7"
names(bk2007) <- c("B2","B3","B4","B8","B12") ## per rinominare bande
im.multiframe(1,2) ## true color
plotRGB(bk2007, r="B4", g="B3", b="B2", stretch="hist", main = "Burkina Faso, GGW 2007")
plotRGB(bk2025, r="B4", g="B3", b="B2", stretch="hist", main = "Burkina Faso, GGW 2025")
 ````
<!-- ho usato la funzione "hist" per ottenere una immagine più luminosa e naturale con maggiori dettagli meglio per un suolo prevalentemente nudo come quello del sahel. l'hist prende l'istogramma dei valori li ridistribuisce in modo da occupare tutta la gamma aumentando così il contrasto nelle zone dove i valori sono più frequenti. il "lin" invece prende i valori mi e max della banda e li mappa linearmente tra 0 e 255 (RGB),si ottiene una immagine scura se i valori sono bassi (SR 0-0.3) e se il contrasto è basso con colori poco vividi. --> 

<p align="center">
<img width="1193" height="494" alt="true_color" src="https://github.com/user-attachments/assets/2ffd5659-4a69-486a-8b89-a9d10955a062" />

</p>

> Le immagini true color mostrano l’evoluzione del paesaggio tra il 2007 e il 2025 utilizzando le bande del visibile (Red, Green, Blue). La visualizzazione RGB consente di interpretare il cambiamento in modo naturale, come sarebbe percepito dall’occhio umano.

### Visualizzazione delle quattro bande separate per entrambe le immagini (RGB + NIR) 
 ````r
im.multiframe(2,2)
plot(bk2007[[3]], main="B4 - Red (SR_B3)", col = magma(100))
plot(bk2007[[2]], main="B3 - Green (SR_B2)", col = magma(100))
plot(bk2007[[1]], main="B2 - Blue (SR_B1)", col = magma(100))
plot(bk2007[[4]], main="B8 - NIR (SR_B4)", col = magma(100))
 ````
<img width="1193" height="466" alt="4bands_2007" src="https://github.com/user-attachments/assets/50966e96-38e7-43c5-8c8b-c32283c78bbd" />



````r
im.multiframe(2,2)
plot(bk2025[[1]], main = "B4 - Red", col = magma(100)) 
plot(bk2025[[2]], main = "B3 - Green", col = magma(100)) 
plot(bk2025[[3]], main = "B2 - Blue", col = magma(100)) 
plot(bk2025[[4]], main = "B8 - NIR", col = magma(100))
````
<img width="1193" height="438" alt="4bands_2025" src="https://github.com/user-attachments/assets/1a40a9b4-55fd-4c5b-8958-987166d7dc19" />


> La visualizzazione separata delle bande spettrali (Blue, Green, Red, NIR) permette di analizzare la risposta del territorio alle diverse lunghezze d’onda: il suolo riflette maggiormente nel blu e nel rosso, mentre la vegetazione sana mostra valori elevati nel NIR. Questa analisi è fondamentale per interpretare correttamente gli indici di vegetazione. Le bande singole mostrano chiaramente che nel 2025 la vegetazione assorbe di più nel rosso e riflette di più nel NIR, segno di aumento della biomassa e miglioramento ecologico.

````r
#visualizziamo lo Swir
im.multiframe(1,2)
plot(bk2007[[5]], main="B12 - SWIR2 (SR_B7)", col = magma(100))
plot(bk2025[[5]], main = "B12 - SWIR2", col = magma(100))
````
<p align="center">
<img width="1600" height="1200" alt="swir" src="https://github.com/user-attachments/assets/181e61c2-2b10-4316-b1ff-0706e370501d" />
 
</p>
> Il confronto della banda SWIR2 tra il 2007 e il 2025 evidenzia una riduzione della riflettanza, indicativa di un aumento dell’umidità superficiale e della copertura vegetale. Nel 2007 la risposta SWIR2 è elevata e frammentata, tipica di suoli nudi e degradati; nel 2025 diventa più omogenea e con valori più bassi, coerente con la rigenerazione ecologica promossa dalla Great Green Wall.

### Composizione RGB con NIR al posto del red
````r
im.multiframe(1,2)
plotRGB(bk2007, r="B8", g="B4", b="B3", stretch="hist",
        main="Burkina Faso, GGW 2007")
plotRGB(bk2025, r="B8", g="B4", b="B3", stretch="hist",
        main="Burkina Faso, GGW 2025")
````
<img width="1440" height="796" alt="NIR_inRed" src="https://github.com/user-attachments/assets/066bb069-db4b-4264-b90e-3c20717f729d" />


> Il composito falso‑colore (NIR–Red–Green) evidenzia la vegetazione mettendo la banda NIR nel canale rosso. Nel 2007 la risposta NIR è debole e frammentata, mentre nel 2025 le aree rosse risultano più estese e continue, indicando un aumento della biomassa vegetale e una riduzione del suolo nudo, coerente con gli interventi della Great Green Wall. Nel composito NIR–Red–Green del 2007, le aree molto scure rappresentano superfici con riflettanza estremamente bassa in tutte le bande, tipiche di suoli nudi, compattati o degradati, privi di vegetazione. La scomparsa di queste zone nel 2025 indica un chiaro miglioramento della copertura vegetale e della qualità del suolo.

### Analisi DVI 
Il DVI (Difference Vegetation Index) è uno dei più semplici indici spettrali utilizzati per valutare la presenza e la vitalità della vegetazione.
Si calcola sottraendo la riflettanza nel rosso (Red) da quella nel vicino infrarosso (NIR).

***DVI*** = **NIR** - *Red*

Le piante sane riflettono molto nel NIR e poco nel rosso, quindi valori alti di DVI indicano vegetazione vigorosa.
È un indice non normalizzato, ma fornisce indicazioni dirette sulla biomassa verde e può essere utile per analisi comparative quando le condizioni di acquisizione sono simili. 

````r
## calcolo DVI,  Per semplificare si userà la funzione im.dvi(), che è una funzione del pacchetto imageRy 
dvi_2007 <- im.dvi(ggw2007, 4, 1)   
dvi_2025 <- im.dvi(ggw2025, 4, 1)
# Visualizzazione della DVI
im.multiframe(1, 2)
plot(dvi_2007, col = viridis(100), main = "DVI 2007")
plot(dvi_2025, col = viridis(100), main = "DVI 2025")
````
<p align="center">
<img width="672" height="420" alt="DVI" src="https://github.com/user-attachments/assets/d4d94859-27b7-467f-a863-71b48b3266e0" />

<p>

>La visualizzazione delle scale per entrambe le mappe DVI permette un confronto corretto tra 2007 e 2025. Nel 2007 prevalgono valori bassi e una forte variabilità, indicativi di suolo nudo e degrado; nel 2025 i valori sono più omogenei e mediamente più elevati, segnalando un aumento della copertura vegetale e una maggiore stabilità ecologica dell’area di Sampelga.
````r
# Calcolo e visualizzazione differenza DVI  
## i due raster NON hanno la stessa estensione, dimensione o risoluzione QUINDI dobbiamo portare il 2007 alla stessa risoluzione del 2025
bk2007_res <- terra::resample(bk2007, bk2025, method="bilinear")
dvi_2007_res <- bk2007_res[["B4"]] - bk2007_res[["B3"]]
dvi_2025_res <- bk2025[["B4"]] - bk2025[["B3"]]
dvi_diff <- dvi_2025_res - dvi_2007_res
im.multiframe(1,1)
plot(dvi_diff, col=magma(100), main="Differenza DVI (2025 - 2007)")
````
<img width="614" height="387" alt="diff_DVI" src="https://github.com/user-attachments/assets/18cc2c63-3e11-4f0b-963a-5f34efde72d8" />

> Questa rappresentazione permette di individuare in modo immediato le zone che hanno beneficiato maggiormente degli interventi di ripristino. I valori positivi prevalgono sull’intera area, indicando un aumento della riflettanza NIR e una riduzione della riflettanza nel rosso, coerenti con una maggiore copertura vegetale nel 2025. 

#  Analisi NDVI (Normalized Difference Vegetation Index)
Il NDVI è uno degli indici di vegetazione più diffusi in telerilevamento grazie alla sua capacità di normalizzare le differenze tra immagini acquisite in tempi o condizioni diverse.
Si calcola come:
NDVI = (NIR − Red) / (NIR + Red)  

I valori ottenuti variano tra -1 e +1: valori vicini a +1 indicano vegetazione densa e sana, mentre valori prossimi a 0 o negativi indicano suolo nudo, rocce o acqua.
L'NDVI è particolarmente utile per monitorare variazioni nella copertura vegetale nel tempo e valutare stress idrici, cambiamenti climatici o impatti antropici, come nel caso di pascoli intensivi.

$` NDVI = \frac{(NIR - Red)}{(NIR + Red)} `$  
````r
# Analisi NDVI
## # Per semplificare si userà la funzione im.ndvi(), che è una funzione del pacchetto imageRy 
ndvi_2007 <- im.ndvi(bk2007, 4, 1)   
ndvi_2025 <- im.ndvi(bk2025, 4, 1) 
# Creazione di un pannello multiframe isualizzazione NDVI
im.multiframe(1, 2)
plot(ndvi_2007, col = viridis(100), main = "NDVI 2007")
plot(ndvi_2025, col = viridis(100), main = "NDVI 2025")
````
<p align="center">
<img width="672" height="420" alt="NDVI" src="https://github.com/user-attachments/assets/13a939f9-f6cf-4f8e-a80e-c6f13a8ee525" />

<p>

> **Valori alti:** vegetazione sana e densa
> **Valori bassi:** suolo nudo e vegetazione scarsa
> Il confronto tra NDVI 2007 e NDVI 2025 evidenzia un incremento netto del vigore vegetativo. Nel 2007 prevalgono valori NDVI bassi (−0.05–0.30), indicativi di suolo nudo e vegetazione scarsa. Nel 2025 la distribuzione si estende fino a 0.8, con un aumento significativo delle aree a elevato NDVI, segnalando una maggiore densità e attività fotosintetica della vegetazione.

## Ridgeline plot 
>[!TIP]
> Il ridgeplot consente di confrontare visivamente la distribuzione dell’indice NDVI tra il 2015 e il 2025, evidenziando eventuali variazioni nella densità e nello stato della vegetazione nel tempo. 
````r
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
  palette = c("magma")
)
````
<img width="1440" height="572" alt="Rplot" src="https://github.com/user-attachments/assets/07ac59f4-7f40-45c2-ae7d-414322e1d902" />


> Il ridgeline NDVI evidenzia un netto spostamento della distribuzione dei valori tra il 2007 e il 2025. Nel 2007 i valori sono concentrati nella fascia bassa (0.1–0.2), indicativi di vegetazione scarsa e suolo nudo. Nel 2025 la distribuzione si amplia e si sposta verso valori più elevati (0.3–0.6), mostrando un aumento significativo del vigore vegetativo e della biomassa. Le due curve non si sovrappongono quasi mai e ciò significa cambiamento ecologico forte.

 ````r
# Concatenamento degli NDVI 
ndvi_2007_res <- terra::resample(ndvi_2007, ndvi_2025, method = "bilinear") # stessa estensione
# Pairs plot
pairs(ndvi,
      main = "Matrice scatterplot NDVI 2007–2025")

 ````
<img width="1440" height="712" alt="Pair" src="https://github.com/user-attachments/assets/78db0e25-5ba0-4dc7-a0c7-a18471d5f4c3" />

 ````r
# Scatter plot NDVI 2007 vs NDVI 2025
plot(ndvi[[1]], ndvi[[2]], xlab="NDVI 2007", ylab="NDVI 2025", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
abline(0, 1, col="red")  

````
<p align="center">
<img width="875" height="648" alt="Scatterplot" src="https://github.com/user-attachments/assets/16240362-7b4c-4b50-a329-bc1c6cad6de4" />


</p>

> La matrice e lo scatterplot NDVI 2007–2025 evidenziano un aumento significativo dell’attività vegetazionale. La correlazione moderata indica che parte dell’area mantiene una risposta simile nei due anni, mentre la distribuzione dei punti sopra la linea 1:1 mostra che la maggioranza dei pixel ha incrementato i valori NDVI nel 2025.

## Classificazione per classi di vegetazione
 ````r
## Classificazione per classi di vegetazione
## Scelta del range di valori adatto alla classificazione
# Si fa riferimento agli istogrammi della distribuzione  dell'NDVI:
hist(ndvi_2007, main = "NDVI 2007", col = "darkgreen")
hist(ndvi_2025, main = "NDVI 2025", col = "darkblue")
 ````
<details>
<summary>Istogrammi (cliccare qui)</summary>  
<img width="614" height="387" alt="Hist_2007" src="https://github.com/user-attachments/assets/04194658-91c6-477a-b3e3-7127f49f6614" />
<img width="614" height="387" alt="Hist_2025" src="https://github.com/user-attachments/assets/d5b144b1-8d9b-4bcb-a209-6e58de75455c" />

  
> Gli istogrammi servono per scegliere soglie significative
> Gli istogrammi NDVI mostrano due distribuzioni nettamente diverse: nel 2007 i valori sono concentrati nella fascia bassa (0.05–0.25), mentre nel 2025 si estendono fino a 0.8. Questo permette di definire classi di vegetazione basate su soglie naturali della distribuzione: NDVI < 0.2 (suolo nudo), 0.2–0.4 (vegetazione media), > 0.4 (vegetazione sana).
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

 ````
### Classi NDVI utilizzate

| Classe | Intervallo NDVI        | Descrizione              |
|--------|--------------------------|---------------------------|
| 1      | NDVI < 0.20             | Suolo nudo               |
| 2      | 0.20 ≤ NDVI < 0.40      | Vegetazione media        |
| 3      | NDVI ≥ 0.40             | Vegetazione sana         |

 ````r
ndvi_2007_cl <- classify(ndvi_2007, class_matrix) 
ndvi_2025_cl <- classify(ndvi_2025, class_matrix)  
im.multiframe(1, 2)
plot(ndvi_2007_cl, col = c("orange", "yellow", "darkgreen"), main = "NDVI class. 2007")
plot(ndvi_2025_cl, col = c("orange", "yellow", "darkgreen"), main = "NDVI class. 2025")
 ````
<p align="center">
<img width="657" height="420" alt="NDVI_class3" src="https://github.com/user-attachments/assets/1e4cb107-feb7-4df7-a85c-30e5360d1f41" />

</p>

> La classificazione NDVI evidenzia un cambiamento netto tra il 2007 e il 2025. Nel 2007 prevale la classe “suolo nudo”, con scarsa presenza di vegetazione. Nel 2025 aumentano le classi “vegetazione media” e “vegetazione sana”, indicando un miglioramento della copertura vegetale e del vigore fotosintetico. 


## Calcolo frequenze e percentuali
<details>
<summary>Code R (cliccare qui)</summary>  
 
 ````r
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
# Tabella
tab <- data.frame(
  classi = c("Suolo nudo", "Vegetazione media", "Vegetazione sana"),
  a2007 = round(perc_2007, 2),
  a2025 = round(perc_2025, 2)
)
print(tab)
````

Si riportano i risultati in una tabella:
### Confronto classi NDVI (2007 vs 2025)

| Classe             | 2007  | 2025  |
|--------------------|-------|-------|
| Suolo nudo         | 93.31 | 11.58 |
| Vegetazione media  |  6.69 | 29.15 |
| Vegetazione sana   |  0.00 | 59.27 |

````r
## Visualizzazione 
 ````r
# 1) CREAZIONE DEL DATA FRAME
# ============================
df <- data.frame(
  classi = c("Suolo nudo", "Vegetazione media", "Vegetazione sana"),
  a2007 = c(100, 0, 0),
  a2025 = c(50, 47, 3),
  check.names = FALSE
)
# ============================
# 3) GRAFICO LEGGIBILE
# ============================
p1 <- ggplot(df, aes(x = classi, y = a2007, fill = classi)) +    
  geom_bar(stat = "identity") +
  geom_text(aes(label = a2007),
            vjust = -0.5, size = 4) +
  scale_fill_viridis_d(option = "C") +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2007", y = "%", x = NULL) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_blank(),   # niente nomi sotto l’asse X
    axis.ticks.x = element_blank(),
    legend.position = "right"        # legenda a lato
  )
p2 <- ggplot(df, aes(x = classi, y = a2025, fill = classi)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = a2025),
            vjust = -0.5, size = 4) +
  scale_fill_viridis_d(option = "C") +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2025", y = "%", x = NULL) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.position = "right"
  )
p1 + p2

````

</details>

<img width="1440" height="488" alt="visual_3" src="https://github.com/user-attachments/assets/cdbfe048-6678-470c-a0bd-185a559decde" />


> L’analisi delle classi NDVI mostra un cambiamento netto tra il 2007 e il 2025. Nel 2007 il paesaggio è dominato dal suolo nudo (93%), con una vegetazione scarsa e nessuna area a elevato vigore fotosintetico. Nel 2025 la situazione si ribalta: la vegetazione sana rappresenta il 59% dell’area, la vegetazione media il 29% e il suolo nudo scende all’11%

 <details>
<summary> 5 classi (cliccare qui)</summary>  
  
Utilizziamo ora classi diverse per mettere in maggiore risalto quelli che potrebbero essere i cambiamenti avvenuti nel secolo. Le diverse soglie sono state scelte dopo ricerca bibliografica. 

 ````r
class_matrix_sahel <- matrix(c(
     -Inf, 0.05, 0,   # Ombra, roccia, acqua, suolo molto scuro
     0.05, 0.20, 1,  # Suolo nudo / vegetazione erbacea molto rada
     0.20, 0.35, 2,  # Vegetazione erbacea/arbustiva discontinua
     0.35, 0.50, 3,  # Vegetazione arbustiva/arborea moderata (GGW in crescita)
      0.50, Inf, 4    # Vegetazione arborea/arbustiva densa (nuclei di successo GGW)
), 
ncol = 3, byrow = TRUE)
 
class_matrix_sahel
     # [,1] [,2] [,3]
# [1,] -Inf 0.05    0
# [2,] 0.05 0.20    1
# [3,] 0.20 0.35    2
# [4,] 0.35 0.50    3
# [5,] 0.50  Inf    4

````
### Classi NDVI 

| Classe | Intervallo NDVI        | Descrizione                                               |
|--------|--------------------------|-----------------------------------------------------------|
| 0      | NDVI < 0.05             | Ombra / roccia / acqua / suolo molto scuro               |
| 1      | 0.05 ≤ NDVI < 0.20      | Suolo nudo / vegetazione erbacea molto rada              |
| 2      | 0.20 ≤ NDVI < 0.35      | Vegetazione erbacea / arbustiva discontinua              |
| 3      | 0.35 ≤ NDVI < 0.50      | Vegetazione arbustiva/arborea moderata (GGW in crescita) |
| 4      | NDVI ≥ 0.50             | Vegetazione arborea/arbustiva densa (nuclei GGW)         |

````r
 
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
plot(ndvi_2007_cl, col = pal_sahel_cb, main = "NDVI class. 2007 (Sahel)")
plot(ndvi_2025_cl, col = pal_sahel_cb, main = "NDVI class. 2025 (Sahel)")
 ````
<img width="1440" height="628" alt="5_class" src="https://github.com/user-attachments/assets/19e04cbb-bd30-49b3-b1d4-199a032512b6" />



> E' stata scelta una gamma di colori "friendly" per persone affette da daltonismo.

Ora facciamolo per le 5 classi
````r
freq_2007 <- freq(ndvi_2007_cl)
freq_2025 <- freq(ndvi_2025_cl)

tot2007 <- sum(freq_2007$count)
tot2025 <- sum(freq_2025$count)

# Funzione per estrarre percentuali garantendo tutte le classi
get_perc <- function(freq, tot) {
  sapply(0:4, function(k) {
    if (k %in% freq$value) freq$count[freq$value == k] / tot else 0
  })
}

perc_2007 <- get_perc(freq_2007, tot2007)
perc_2025 <- get_perc(freq_2025, tot2025)

tab <- data.frame(
  Classe = c("0 - Ombra/suolo scuro",
             "1 - Suolo nudo",
             "2 - Erbacee/arbusti bassi",
             "3 - Arbusti attivi",
             "4 - Vegetazione densa"),
  Perc_2007 = round(perc_2007, 2),
  Perc_2025 = round(perc_2025, 2)
)
````
Si riportano i risultati in una tabella:
### Confronto classi NDVI (2007 vs 2025)
| Classe                      | 2007  | 2025  |
|-----------------------------|-------|-------|
| 0 – Ombra / suolo scuro     | 0.00  | 0.01  |
| 1 – Suolo nudo              | 0.93  | 0.11  |
| 2 – Erbacee / arbusti bassi | 0.07  | 0.21  |
| 3 – Arbusti attivi          | 0.00  | 0.24  |
| 4 – Vegetazione densa       | 0.00  | 0.43  |


````r
tab <- data.frame(
  classi = c("0 - Ombra/suolo scuro",
             "1 - Suolo nudo",
             "2 - Erbacee/arbusti bassi",
             "3 - Arbusti attivi",
             "4 - Vegetazione densa"),
  a2007 = round(perc_2007 * 100, 2),   # percentuali in %
  a2025 = round(perc_2025 * 100, 2),
  check.names = FALSE
)

p1 <- ggplot(tab, aes(x = classi, y = a2007, fill = classi)) +    
  geom_bar(stat = "identity") +
  scale_fill_viridis_d(option = "C") +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2007 (Sahel)", y = "%", x = NULL) +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

p2 <- ggplot(tab, aes(x = classi, y = a2025, fill = classi)) +
  geom_bar(stat = "identity") +
  scale_fill_viridis_d(option = "C") +
  ylim(0, 100) +
  labs(title = "Classi NDVI 2025 (Sahel)", y = "%", x = NULL) +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

p1 + p2
````
<img width="1118" height="649" alt="visual_5" src="https://github.com/user-attachments/assets/dd027f57-3267-45c0-840a-006b77d03dc5" />

> Il confronto tra le classi NDVI del 2007 e del 2025 evidenzia un cambiamento radicale nella struttura vegetazionale dell’area. Nel 2007 il paesaggio è dominato dal suolo nudo (93%), con una minima presenza di vegetazione erbacea (6.7%) e totale assenza di arbusti attivi. Nel 2025 la situazione si ribalta: gli arbusti attivi rappresentano il 59% dell’area, le erbacee il 29%, mentre il suolo nudo scende all’11%

</details>


## 📉 Analisi multitemporale
L'analisi multitemporale ha permesso di confrontare i dati telerilevati del 2007 e del 2025, focalizzandosi in particolare sulla banda del NIR e sull'indice NDVI, al fine di evidenziare variazioni significative nello stato della vegetazione nell’arco di quasi vent'anni.
````r
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
````
<img width="1440" height="600" alt="multitemporal" src="https://github.com/user-attachments/assets/8729ff74-0a36-4647-ab6b-796caca1254f" />

> La differenza multitemporale tra 2007 e 2025 evidenzia un incremento significativo della riflettanza nel NIR e dei valori NDVI. Le aree che nel 2007 mostravano una risposta spettrale debole (suolo nudo, vegetazione rada) presentano nel 2025 valori nettamente più elevati, indicativi di un aumento della biomassa, della copertura vegetale e del vigore fotosintetico. 

## Criticità 
Lo studio fornisce una visione generale dell’area e dei possibili effetti della Great Green Wall sul territorio saheliano, ma presenta alcune criticità che è necessario considerare per interpretare correttamente i risultati. La principale riguarda l’assenza di dati osservazionali di campo: non disponiamo di informazioni dirette sulla composizione floristica, sulla densità reale della vegetazione o sulle condizioni del suolo. Questo limita la possibilità di verificare che le classi NDVI corrispondano effettivamente alle tipologie vegetazionali presenti.
Inoltre, l’analisi si basa soltanto su indici spettrali come NIR e NDVI, che pur essendo strumenti efficaci per descrivere la dinamica vegetazionale, non riescono a cogliere l’intera complessità ecologica. L’NDVI, in particolare, può risentire dell’effetto del suolo nudo, saturare nelle aree più vegetate e non distinguere con precisione tra arbusti, colture temporanee o vegetazione effimera. L’integrazione di altri indici, come EVI, SAVI o NDMI, potrebbe rendere l’analisi più robusta e ridurre le incertezze.

Nel complesso, lo studio offre una lettura coerente dei cambiamenti osservati, ma le conclusioni devono essere interpretate con cautela e considerate come un’indicazione preliminare, che andrebbe confermata attraverso dati di campo e analisi complementari.

## Commenti e Conclusioni
Grazie all'utizzo di indici spettrali (DVI e NDVI) si è potuto dimostrare analiticamente come le pratiche di rinverdimento all'interno di un nucleo della fascia Saheliana della Great Green Wall diano risultati nel corso del tempo. L’obiettivo era quello di comprendere se, e in che misura, le dinamiche osservate potessero essere coerenti con gli interventi della Great Green Wall.
Le analisi condotte mostrano un cambiamento netto e consistente: le aree che nel 2007 risultavano dominate dal suolo nudo e da una vegetazione estremamente rada presentano nel 2025 segnali chiari di recupero, con un aumento significativo della riflettanza nel NIR, valori NDVI più elevati e una transizione verso classi vegetazionali più strutturate. La comparsa e l’espansione degli “arbusti attivi”, insieme alla riduzione del suolo nudo, rappresentano indicatori ecologici di grande rilevanza, che suggeriscono un miglioramento delle condizioni vegetazionali e una maggiore stabilità del suolo. 
In conclusione, il progetto evidenzia un chiaro miglioramento dello stato vegetazionale dell’area tra il 2007 e il 2025, suggerendo un processo di recupero ecologico in atto. Pur richiedendo ulteriori approfondimenti e integrazioni con dati di campo, i risultati ottenuti rappresentano un contributo significativo alla comprensione delle dinamiche ambientali del Sahel e mostrano il potenziale del telerilevamento come strumento di supporto alle politiche di gestione e conservazione del territorio.



## Bibliografia

Sacande, M., Martucci, A., & Vollrath, A. (2021). Monitoring Large-Scale Restoration Interventions from Land Preparation to Biomass Growth in the Sahel. Remote Sensing, 13(18), 3767. https://doi.org/10.3390/rs13183767

[UNCCD - Great Green Wall] (https://www.unccd.int/our-work/ggwi) 



