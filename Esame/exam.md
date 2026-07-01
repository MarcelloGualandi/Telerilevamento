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



