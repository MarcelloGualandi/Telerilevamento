# My functions!
definiamo gli argoment della funzione

somma <- function(x,y){
  z=x+y
  return(z)
  }


> somma(1,100)
[1] 101

# Exercise: make the function called difference

difference <- function(x,y){
  z=x-y
  return(z)
  }

> difference(300,150)
[1] 150

# par
mf <- function(nx,ny){
  par(mfrow=c(nx,ny))
}


mf2 <- function(nx,ny){
  par(mfrow=c(nx=1,ny=2))
}        ## faccio la stessa cosa ma ho un default nella funzione

da R

 "Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg"
[1] "Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg"
> sent<-im.import("sentinel.dolomites")
> mf(1,2)
Error in mf(1, 2) : could not find function "mf"
> library(terra)
terra 1.8.80
> plot(sent[[1]])
> plot(sent[[2]])
> mf2 <- function(nx,ny){
+     par(mfrow=c(nx=1,ny=2))
+ }  
> mf2()
> plot(sent[[1]])
> plot(sent[[2]])
> 

# if else

positivo <- function(x) {
 if(x>0) {
 "questo numero è positivo" 
 }
 }

## da R
> positivo(6)
[1] "questo numero è positivo"

## da Duccio profiles

# par(mfrow...) 
mf <- function(nx,ny){
  par(mfrow=c(nx, ny))
}

# par(mfrow...) with default
mf <- function(nx=1,ny=2){
  par(mfrow=c(nx, ny))
  }

# if else
numeri <- function(x){
  if(x>0){
    print("Questo numero è positivo, ciuco!")
    }
  else {
    print("Questo numero è negativo, se non sai queste cose, torna a scuola")  
    }
  }

# if else
numeri <- function(x){
  if(x>0){
    print("Questo numero è positivo, ciuco!")
    }
  else if(x<0) {
    print("Questo numero è negativo, se non sai queste cose, torna a scuola")  
    }
  else {
    print("Zero non è né negativo né positivo") 
    }
  }

# for   funzione ideale se dobbiamo svolgere la stessa operazione tante volte
es con questa funziona io voglio rimontare tutti i numeri che vanno da un minimo ad un massimo

loop <- function() {
  for(i in 1:50) {
    print(i)
    }
}


loop2 <- function() {
  for(i in 1:50) {
    op <- i * 7
    print(op)
    }
}

esportiamo il risultato 

setwd("~/Dekstop")
