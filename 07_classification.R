## lezione 21 aprile

#code for classifying data

library(terra)
library(imageRy)
library(ggplot2)
library(patchwork)

#listing files
im.list

#import
?im.classify

#classify
sunc<-im.classify(sun)
sunc<-im.classify(sun, seed=3)
sunc<-im.classify(sun, seed=42)

#import Grand Canyon data
can<-im.import("dolansprings_oli_2013088_canyon_lrg.jpg")

# classify Grand Canyon data
cancc<-im.classify(can, seed=42, num_clusters=4)

#classyfing  data out R



# set wd
setwd("~/Downloads")
# C://utenteovveroio/Downloads/
getwd()

# listing files
im.list()

# import
sun <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

# classify
sunc <- im.classify(sun)
sunc <- im.classify(sun, seed=3)
sunc <- im.classify(sun, seed=42)

# import Grand Canyon data
can <- im.import("dolansprings_oli_2013088_canyon_lrg.jpg")

# classify grand canyon data
cancc <- im.classify(can, seed=42, num_clusters=4)

# classifying data out of R
list.files()

# import data
getwd()
dji <- rast("dji.jpg")
dji <- flip(dji)
plot(dji)

# classify data
djic <- im.classify(dji, num_clusters=2)

# Mato grosso examples 
im.list()
[22] ©                   
[23] "matogrosso_l5_1992219_lrg.jpg" 
m2006<-im.import("matogrosso_ast_2006209_lrg.jpg")                   
m1992<-im.import("matogrosso_l5_1992219_lrg.jpg")

im.multiframe(2,1)
plot(m1992)
plot(m2006)

# classification
m1992c<-im.classify(m1992, seed=42, num_clusters=2)

# Assign labels
levels(m1992c) <- data.frame(
  value = c(1, 2),
  label = c("forest", "human")
  )

#calculatyin frequencies
f1992<-freq(m1992c)
sono le frequenze dei pixel, sono difficili da leggere quindi calcoliamo le %

prop1992<-f1992$count / ncell(m1992c)

ottengo la proporzione di foresta sopra e sotto di human

ora calcoliamo le percentuali
perc1992<-prop1992*100

ottengo che la foresta occupa l'83% e l'umano il 17

f2006<-freq(m2006c)
sono le frequenze dei pixel, sono difficili da leggere quindi calcoliamo le %

prop2006<-f2006$count / ncell(m2006c)

ottengo la proporzione di foresta sopra e sotto di human

ora calcoliamo le percentuali
perc2006<-prop2006*100

# Table
tabout<-data.frame(
  class=c("Forest","Human"),
          perc1992=c(83, 17),
          perc2006=c(45, 55)
          )

ggplot(tabout, aes(x=class,y=perc1992, color=class)) + # structure
  geom_bar(stat="identity", fill="white") # barplot. posso usare questi commenti per spiegare cosa ho fatto

##all'interno dobbiamo mettere che cosa vogliamo rendere un grafico e come realizzarlo. dentro le estetiche aes, ci sono tre parametri: x, y e colore. 
dobbiamo dire a ggplot che tipo di grafico vogliamo fare. noi ora vogliamo creare un istogramma. 

facciamo la stessa cosa per il 2006
## exercise: plot the bars of 2006

ggplot(tabout, aes(x=class,y=perc2006, color=class)) + # structure
  geom_bar(stat="identity", fill="white")

c'è un pacchetto che si chiama patchwork che dialoga con ggplot. non fa altro che associare pezzi di ggplot a degli oggetti.
poi posso sommare i diversi oggetti e confrontarli.

ora associamo i nostri 2 grafici a 2 oggetti, p1 e p2 per esempio

# Using patchworl
p1<-ggplot(tabout, aes(x=class,y=perc1992, color=class)) + # structure
  geom_bar(stat="identity", fill="white")
p2<-ggplot(tabout, aes(x=class,y=perc2006, color=class)) + # structure
  geom_bar(stat="identity", fill="white")

p1 + p2

## mettiamo le 2 y uguale, perchè se vediamo i 2 grafici che ho appena creato le y sono diverse. queste cose le fanno i politici per fregarvi
p1<-ggplot(tabout, aes(x=class,y=perc1992, color=class)) + # structure
  geom_bar(stat="identity", fill="white") + # bar plot
ylim(c(0,100)) # limits

p2<-ggplot(tabout, aes(x=class,y=perc2006, color=class)) + # structure
  geom_bar(stat="identity", fill="white")  + # bar plot
ylim(c(0,100)) # limits

> p1 + p2

Rimuoviamo la legende, in questo caso in solo uno dei due grafici ma lo puoi fare anche nell'altro
p1<-ggplot(tabout, aes(x=class,y=perc1992, color=class)) + # structure
  geom_bar(stat="identity", fill="white") + # bar plot
ylim(c(0,100)) # limits
theme(legend.position="none")   # removing legend

p2<-ggplot(tabout, aes(x=class,y=perc2006, color=class)) + # structure
  geom_bar(stat="identity", fill="white")  + # bar plot
ylim(c(0,100)) # limits



p1<-ggplot(tabout, aes(x=class,y=perc1992, color=class)) + # structure
  geom_bar(stat="identity", fill="white") + # bar plot
ylim(c(0,100)) # limits
theme(legend.position="none")   # removing legend
theme_minimal() ## per cambiare lo sfondo

p2<-ggplot(tabout, aes(x=class,y=perc2006, color=class)) + # structure
  geom_bar(stat="identity", fill="white")  + # bar plot
ylim(c(0,100)) # limitsggplot(tabout, aes(x=class, y=perc1992, color=class)) + 
      geom_bar(stat="identity", fill="white") 

p1<-ggplot(tabout, aes(x=class,y=perc1992, color=class)) + # structure
  geom_bar(stat="identity", fill="white") + # bar plot
ylim(c(0,100)) # limits
theme(legend.position="none")   # removing legend
theme_dark()  #cambia lo sfondo

p2<-ggplot(tabout, aes(x=class,y=perc2006, color=class)) + # structure
  geom_bar(stat="identity", fill="white")  + # bar plot
ylim(c(0,100)) # limitsggplot(tabout, aes(x=class, y=perc1992, color=class)) + 
      geom_bar(stat="identity", fill="white") 
