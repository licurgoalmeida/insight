CalcR2 = function(v1,v2){
  # Calculates the coefficient of determination (R2)
  #
  # Args:
  #   v1: vector with  observations
  #   v2: vector with predictions
  # Returns:
  #   r2: coefficient of determination
  
  v = as.matrix((v1 - v2),ncol = 1)
  x = as.matrix((v1 - mean(v1)),ncol = 1)
  stot = t(x) %*% x
  sres = t(v) %*% v
  r2 = 1 - (sres/stot)
  return(as.numeric(r2))
}