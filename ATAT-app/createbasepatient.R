setwd("~/Dropbox/Insight/Project/ATAT-app/")
aux = which(ftable$hospcode_072 == 1)
basehospital = ftable[aux,]
auxbasepatient = apply(basehospital,2,median)
basepatient =  basehospital[1,]
basepatient[1,] = auxbasepatient
basepatient$vdayr_2 = 1
basepatient$paypriv = 1
save(basepatient,file = 'Data/basepatient.Rdata')
save(fitlm,file = 'Data/fitlmgood.Rdata')