# Questo sarà il titolo del mio progetto di esame

l'area di studio bla bla The role of carrion in maintaining biodiversity and ecological processes in terrestrial ecosystems

Ho scelto la Mauritania perchè..
<img width="1499" height="1000" alt="mauritania" src="https://github.com/user-attachments/assets/3b12afc4-bde8-4f00-bf25-6507502940e9" />


## pacchetti utilizzati

per questo esame blabla pacchetti: 

``` questo è simbolo di blacktick r
library(terra) #pacchetto per ..

```

## importazione dei dati
i dati sono stati scaricati da Earth Observatory [[
](https://science.nasa.gov/earth/earth-observatory/eyeing-the-richat-structure/)]

oppure posso scrivere cosi: (https://science.nasa.gov/earth/earth-observatory/eyeing-the-richat-structure/) 

il codice utilizzato è il seeguente: prima di tutto selezioniamo la working directory

```
setwd("~/Desktop/")
# c://blablabla/lknlnln

getxd()

list.files()
```

per importare i dati è stata utilizzata la funzione `rast()` del pacchetto `terra`: vedi che se metti il backtick davanti alla parola verranno visualizzati come pezzi di codice. 

```r
richat <-rast("richatstructure_oli_20260306.jpg")
richat<-flip(richat)
plot(richat)
```
trasciniamo qua dentro l'immagine ottenuta con R, direttamente dal dekstop
<img width="1440" height="960" alt="richatstructure_oli_20260306" src="https://github.com/user-attachments/assets/43486e90-5565-4dfe-95af-72f0a18859a2" />

## Analisi esplorativa

prima di tutto blablabla plottaggio di singole bande:

ci metto il pezzo di codice che userò per plottare le singole basne





