# Create ftable
setwd("~/Dropbox/Insight/Project")
# Load data
load("data/immedr3.hall.age1.emat.preproc.RData") # Pre-processed data
rdata = read.csv("data/removed_data.csv") # removed data
ftable = resPreProc$smat
names(ftable) = resPreProc$labels
triage = as.numeric(resPreProc$triage)
#ftable = cbind(as.numeric(resPreProc$triage),ftable)
tnames = names(ftable)
tnames[1] = "triage"
names(ftable) =  tnames
weights = resPreProc$weight

aux = rep(0,length(resPreProc$hospcode))
for (ii in 1:length(aux)){
  a1 = (alldata$hospcode == as.numeric(resPreProc$hospcode[ii]) & (alldata$patcode == resPreProc$patcode[ii]))
  aux[ii] = which(a1)
}
# Load data
tdata = read.csv("data/triage_data.csv") # triage data
rdata = read.csv("data/removed_data.csv") # removed data
alldata = cbind(tdata,rdata)
alldata = alldata[aux,]