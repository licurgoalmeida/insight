# Creates list categories based on columns from binary list
# Where:
# L = List with the different categories
# rootName = Root name of the columns
create_categorical_list <- function(L,rootName)
{
  cnames = names(L)
  auxname = paste("^",rootName,sep = "")
  aux = grep(auxname,cnames)
  l = rep(NA,length(L[[1]]))
  for (ii in 1:length(aux)){
    auxl = which(L[[aux[ii]]] == 1)
    l[auxl] = cnames[aux[ii]]
  }
  l = as.character(l)
  l
}