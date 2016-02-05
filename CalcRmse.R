CalcRmse = function(v1,v2){
  # Calculates the Root Mean Square Error between two vectors.
  #
  # Args:
  #   v1: vector with  observations
  #   v2: vector with predictions
  # Returns:
  #   rmse: Root Mean Square Error between two vectors
  v = as.matrix((v2 - v1),ncol = 1)
  rmse = sqrt((t(v) %*% v) / length(v1))
  return(as.numeric(rmse))
}