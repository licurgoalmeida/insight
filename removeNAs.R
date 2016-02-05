# Remove features with too many NAs

removeNAs <- function(D,thres){
  rmnas = rep(0,times = length(names(D)))
  Drows = nrow(tdata)
  for (ii in 1:length(names(D))){
    rmnas[ii] = sum(is.na(D[,ii])) / Drows
  }
  return(which(rmnas > thres))
}