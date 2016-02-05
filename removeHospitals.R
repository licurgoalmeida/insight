# Remove hospitals with few features

removeHospitals <- function(t){
  hospcount = c(1:max(t$hospcode))
  entrycount = rep(0,times = ncol(t))
  for (ii in 1:max(hospcount)){
    aux = which(t$hospcode == hospcount[ii])
    entrycount[aux] = length(aux)
  }
  return(entrycount)
}