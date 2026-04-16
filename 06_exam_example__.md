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

per importare i dati è stata utilizzata la funzione `rast()` del pacchetto `terra`:

``` r
richat <- rast("richatstructure_oli_20260306.jpg")
richat <- flip(richat)
plot(richat)
```

trasciniamo qua dentro l'immagine ottenuta con R, direttamente dal dekstop
<img width="1440" height="960" alt="richatstructure_oli_20260306" src="https://github.com/user-attachments/assets/43486e90-5565-4dfe-95af-72f0a18859a2" />

## Analisi esplorativa

Prima di tuto blablabla plottaggio di singole bande:

``` r
im.multiframe(2,1)
plot(richat[[1]])
plot(richat[[2]])
```

<img width="480" height="480" alt="bande" src="https://github.com/user-attachments/assets/0bc2a4e7-3730-4775-9a26-e61c2573ec45" />

Siccome sono pigro, ho usato un ciclo for:

``` r
par(mfrow=c(2,2))

colori <- c("red", "green", "blue")

for(i in 1:nlyr(richat)) {
  hist(richat[[i]],
       main=paste("Istogramma banda", i),
       xlab="Valori digitali",
       col=colori[i],
       border="white")
}
```
<img width="1200" height="800" alt="istogrammi_bande_colorati" src="https://github.com/user-attachments/assets/a9131ee4-2735-4a98-9210-53b272ca0cef" />




