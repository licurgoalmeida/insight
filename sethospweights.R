# Set weights for hospitals
sethospweights = function(r,code){
  for(ii in 1:max(code)){
    aux = which(code == ii)
    r$edwt[aux] = r$edwt[aux[1]]
  }
  return(r)
}