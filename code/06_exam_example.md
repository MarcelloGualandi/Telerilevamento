# Exam project title: Title 

## Data gathering 

Data were gathered from the [Earth Observatory site](https://earthobservatory.nasa.gov/).

Packages used: 

``` r
library(terra)
library(imageRy)
library(viridis) # in order to plot images with different viridis color ramp palettes
```

Setting the working directory and importing the data:

``` r
setwd("~/Desktop/")
fires = rast("fires.jpg")
plot(fires)
fires=flip(fires)
plot(fires)
```

The image is the following: ## basta trascinare l'immagine

<img width="480" height="480" alt="fires" src="https://github.com/user-attachments/assets/927945d0-e84a-4176-b828-15f357cb85a1" />

## Data analysis

Based on the data gathered from the site we can calculate an index, using the first two bands:

``` r
fireindex = fires[[1]] - fires[[2]]
plot(fireindex)
```
In order to export the index, we can use the png() function like:

```r
png("fireindex.png")
plot(fireindex)
dev.off()
```

The index looks like:

<img width="577" height="356" alt="Rplot11" src="https://github.com/user-attachments/assets/2d148766-9a01-4a50-8c8b-fa735bfc1dce" />

## Index visualisation by viridis 

In order to visualize the index with another viridis palette we made use of the following code:

``` r
plot(fireindex, col=inferno(100))
```

The output will look like:

 <img width="574" height="257" alt="Rplot12" src="https://github.com/user-attachments/assets/f7fba9bd-1f2a-42c0-a766-2dfe2e1f4689" />

## Correlation of bands

Since the RGB is composed by visible bands, a high correlation is expected:

``` r
pairs(dust)
```
