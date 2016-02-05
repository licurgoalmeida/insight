# Creates list of binaries based on factors from the DataFrame
# Where:
# V = column from the data frame with the different factors
create_binary_list <- function(V,rootName)
{
  L = list() # creating empty list
  allLevels <- levels(factor(unlist(V)))
  colnames = allLevels
  for (ii in 1:length(allLevels)) {
    L[[ii]] = as.numeric(V == allLevels[ii])
    colnames[ii] = paste(rootName,allLevels[ii],sep = "")
  }
  names(L) = colnames
  L
}