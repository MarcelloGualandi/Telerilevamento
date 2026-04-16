library(terra)
library(imageRy)

setwd("~/Desktop/")
# c://blablabla/lknlnln

getwd()

list.files()
png("figura.png")
richat <-rast("richatstructure_oli_20260306.jpg")

png("figura.png")
richat<-flip(richat)
plot(richat)

png("bande.png")
im.multiframe(2,1)
plot(richat([[1]])
plot(richat([[2]])
