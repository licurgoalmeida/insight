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

# Remove features with too many NAs
# Where:
# D = dataframe
# thres = max % of NA in a column
removeNAs <- function(D,thres){
  rmnas = rep(0,times = length(names(D)))
  Drows = nrow(tdata)
  for (ii in 1:length(names(D))){
    rmnas[ii] = sum(is.na(D[,ii])) / Drows
  }
  return(which(rmnas > thres))
}

# Remove hospitals with few features
# Where:
# D = dataframe
removeHospitals <- function(D){
  hospcount = c(1:max(D$hospcode))
  entrycount = rep(0,times = ncol(D))
  for (ii in 1:max(hospcount)){
    aux = which(D$hospcode == hospcount[ii])
    entrycount[aux] = length(aux)
  }
  return(entrycount)
}

# Remove entries with few feature count

removeLowCount <- function(t,feat,rootname){
  elem = vector()
  for (ii in 1:length(feat)){
    elem = c(elem,as.vector(t[,feat[ii]]))
  }
  elem = elem[complete.cases(elem)]
  elem = unique(elem)
  df = as.data.frame(matrix(0,ncol = length(elem),nrow = nrow(t)))
  colnames = paste(rootname,"_",elem,sep = "")
  names(df) = colnames
  for (ii in 1:length(feat)){
    for (jj in 1:nrow(t)){
      if (!is.na(t[jj,feat[ii]])){
        df[jj,which(elem == t[jj,feat[ii]])] = 1
      }
    }
  }
  return(df)
}