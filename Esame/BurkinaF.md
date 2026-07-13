>  #### Marcello Gualandi

# Analisi  dell'avanzamento della Great Green Wall in Burkina Faso (2007 - 2025)

---

# 📌 Introduzione 

La **Great Green Wall** **GGW** è un progetto lanciato dall’Unione Africana nel 2007 per contrastare la desertificazione, la perdita di biodiversità e la crescente vulnerabilità climatica del Sahel. Il progetto mira a realizzare un mosaico di paesaggi rstaurati lungo circa 8000 km, dal Senegal al Gibuti, attraverso interventi di riforestaizione, agricoltura rigenerativa e gestione sostenibile del territorio.
La fascia del Sahel rappresenta una delle regioni più esposte agli effetti del cambiamento climatico: avanzamento della desertificazione, degrado del suolo, riduzione della produttività primaria e pressioni antropiche sempre più intense hanno reso questo terrritorio sempre meno abitabile. 
In questo contesto la **GGW** agisce come una strategia integrata di adattamento e mitigazione con ambizioni obiettivi fissati per il 2030: 

- 100 milioni di ettari restaurati
- 250 milioni di tonnellate di  CO₂ sequestrate
- 10 milioni di posti di lavoro verdi nelle comunità rurali

Nonostante la portata del progetto, la valutazione dell'effiacia degli interventi rimane una delle sfide principale. La mancanza di metodologie standardizzate e di monitoraggi sistematici ha portata ad una comprensione limitata dei progressi reali.
Il **telerilevamento** offre una soluzione concreta a queste criticità poichè consente un monitoraggio continuo, oggettivo ed economicamente sostenibile, capace di tracciare con precisione i progressi della Great Green Wall.

# 🌍 Area di Studio
Per l'analisi è stata selezionata la **regione di Sampelga** in **Burkina Faso** caratterizzata da una piovosità media annua di cira 400 mm con piogge che si concentrano nei mesi tra giugno e settembre.
La vegetazione è dominata da una savana arbustiva con copertura erbacea discontinua che emergono esclusivamente durante la stagione delle piogge.

# 🎯 Obiettivi 
Questo progetto ha l'obiettivo di analizzare l'avanzamento e l'efficacia  della Great Green Wall attraverso immagini satellitari e l'uso di indici di vegatazione. 

# 📄 Materiali e metodi
Le immagini satellitari sono state ricavate attraverso [Google Earth Engine](https://earthengine.google.com/) selezionando le date di riferimento utili all'analisi. 
Per l'analisi del 2025 è stato utilizzato **Sentinel-2** che fornisce dati multispettralii con risoluzione spaziale di 10-20 m.
Per l'analisi del 2007 invece è stato utilizzato **Landsat 5 TM**, in quanto Sentinel-2 non era ancora operativo. Landsat garantisce comunque una risoluzione di 30 m e una copertura temporale continua. 
Le date di acquisizione sono state selezionate in modo da rappresentare on maniera coerente la stagione vegetativa dei siti di sutdio.
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
| SWIR2 | SR_B7 | B12 | 2080–2350 | Biomassa secca, incendi |

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
<img width="1193" height="494" alt="true_color" src="https://github.com/user-attachments/assets/68eddf89-94fa-48b6-99f0-266c57c9277d" />

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
<img width="1193" height="466" alt="4bands_2007" src="https://github.com/user-attachments/assets/cfc7f3bc-7262-414b-8507-9a8f74044dfd" />


````r
im.multiframe(2,2)
plot(bk2025[[1]], main = "B4 - Red", col = magma(100)) 
plot(bk2025[[2]], main = "B3 - Green", col = magma(100)) 
plot(bk2025[[3]], main = "B2 - Blue", col = magma(100)) 
plot(bk2025[[4]], main = "B8 - NIR", col = magma(100))
````
<img width="1193" height="438" alt="4bands_2025" src="https://github.com/user-attachments/assets/94efc763-bcf8-441b-8dcf-7553a9e9a4f2" />



> La visualizzazione separata delle bande spettrali (Blue, Green, Red, NIR) permette di analizzare la risposta del territorio alle diverse lunghezze d’onda: il suolo riflette maggiormente nel blu e nel rosso, mentre la vegetazione sana mostra valori elevati nel NIR. Questa analisi è fondamentale per interpretare correttamente gli indici di vegetazione.

````r
#visualizziamo lo Swir
im.multiframe(1,2)
plot(bk2007[[5]], main="B12 - SWIR2 (SR_B7)", col = magma(100))
plot(bk2025[[5]], main = "B12 - SWIR2", col = magma(100))
````
<img width="1159" height="387" alt="swir" src="https://github.com/user-attachments/assets/132e5dc2-bc98-4a4d-8596-d99e3ca3f332" />


> Lo SWIR mostra chiaramente che nel 2025 il suolo è meno arido e più vegetato rispetto al 2007. valori alti di swir come nel 2007 mostrano suolo più secco rispetto a valori bassi che riflettono una maggiore umidità.

### Composizione RGB con NIR al post del red
````r
im.multiframe(1,2)
plotRGB(bk2007, r="B8", g="B4", b="B3", stretch="hist",
        main="Burkina Faso, GGW 2007")
plotRGB(bk2025, r="B8", g="B4", b="B3", stretch="hist",
        main="Burkina Faso, GGW 2025")
````
<img width="1440" height="796" alt="NIR_inRed" src="https://github.com/user-attachments/assets/066bb069-db4b-4264-b90e-3c20717f729d" />


> sostituire il NIR nella banda del RED permette di evidenziare visivamente la vegetazione e il suo cambiamento tra 2007 e 2025. si evidenziano le zone di vegetazione (rosso).

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
<img width="1440" height="768" alt="DVI" src="https://github.com/user-attachments/assets/f167e54f-0b52-45a3-8714-29d0f6023a0c" />


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
<img width="614" height="387" alt="diff_DVI" src="https://github.com/user-attachments/assets/fb66fffb-197a-4e33-86da-a120fd637e6f" />


> Questa rappresentazione permette di individuare in modo immediato le zone che hanno beneficiato maggiormente degli interventi di ripristino.

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
<img width="1440" height="712" alt="NDVI" src="https://github.com/user-attachments/assets/b4b4fd89-df50-4ee2-bb3a-cfc61237b7fb" />


> **Valori alti:** vegetazione sana e densa
> **Valori bassi:** suolo nudo e vegetazione scarsa

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
  palette = c("magma", "viridis")  # 2007 = viola/rosso, 2025 = verde/giallo
)
````
<img width="1440" height="572" alt="Rplot" src="https://github.com/user-attachments/assets/07ac59f4-7f40-45c2-ae7d-414322e1d902" />


> Il ridgeline confronta la distribuzione dei valori NDVI tra il 2007 e il 2025. Le curve sono etichettate e colorate in modo distinto: la curva del 2007 (magma) mostra valori più bassi e concentrati, mentre quella del 2025 (viridis) è spostata verso valori più elevati, indicando un aumento della copertura vegetale. Il grafico evidenzia chiaramente il miglioramento della vegetazione nel periodo considerato.

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
<p align="center">
<img width="1440" height="684" alt="3_class" src="https://github.com/user-attachments/assets/180ea26e-4b6e-4d15-82eb-1c8983398018" />


</p>

> La classificazione NDVI evidenzia un cambiamento netto tra il 2007 e il 2025. Nel 2007 l’intera area ricade nella classe 1 (NDVI < 0.2), indicativa di una copertura vegetale molto bassa e omogenea. Nel 2025 emergono invece tre classi distinte, con la comparsa di patch a NDVI elevato (classe 3) e una maggiore eterogeneità spaziale. Questo pattern è coerente con processi di rigenerazione vegetale associati alle iniziative della Great Green Wall.

Utilizziamo ora classi diverse pe mettere in maggiore risalto quelli che potrebbero essere i cambiamenti avvenuti nel secolo. le diverse soglie sono state scelte dopo ricerca bibliografica. 
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



> E' stata scelta una gamma di colori "friendly" per i daltonici
## Calcolo percentuali
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
print(tab) ##       classi a2007 a2025
 # 1        Suolo nudo     0  0.73
 # 2 Vegetazione media     1  0.27
 # 3  Vegetazione sana     0  0.00
 ````
Si riportano i risultati in una tabella:
### Confronto classi NDVI (2007 vs 2025)

| Classe              | 2007 | 2025 |
|---------------------|------|------|
| Suolo nudo          | 1    | 0.50 |
| Vegetazione media   | 0    | 0.47 |
| Vegetazione sana    | 0    | 0.03 |

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
<img width="1440" height="488" alt="visual_3" src="https://github.com/user-attachments/assets/cdbfe048-6678-470c-a0bd-185a559decde" />


> Confronto tra le classi NDVI nel 2007 e nel 2025. Nel 2007 l’area ricade interamente nella classe “Suolo nudo”, indicando una copertura vegetale molto scarsa. Nel 2025 si osserva invece una distribuzione più articolata, con una riduzione del suolo nudo (50%) e la comparsa delle classi “Vegetazione media” (47%) e “Vegetazione sana” (3%), evidenziando un miglioramento della copertura vegetale coerente con processi di rigenerazione.

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
| Classe                       | 2007 | 2025 |
|------------------------------|------|------|
| 0 – Ombra / suolo scuro      | 0.01 | 0.00 |
| 1 – Suolo nudo               | 0.99 | 0.50 |
| 2 – Erbacee / arbusti bassi  | 0.00 | 0.43 |
| 3 – Arbusti attivi           | 0.00 | 0.06 |
| 4 – Vegetazione densa        | 0.00 | 0.00 |

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


## 📌 Commenti e Conclusioni

## Bibliografia
