# Count the number of unique features in each column
countUnique = function(t){
  count = rep(0,times = ncol(t))
  for (ii in 1:ncol(t)){
    count[ii] = length(unique(t[,ii]))
  }
  return(count)
}