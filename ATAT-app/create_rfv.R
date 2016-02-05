# Create rfv  list
setwd("~/Dropbox/Insight/Project/ATAT-app/")
rfv$V2 = paste(rfv$V2,rfv$V3,rfv$V4,"")
rfv = rfv[,c("V1","V2")]
rfv$V1 = as.character(rfv$V1)
for (ii in 1:nrow(rfv)){
  rfv$V1[ii] = substr(rfv$V1[ii],2,10)
}
names(rfv) = c('codes','reason')
rfv$reason = gsub('  ',' ',rfv$reason)
rfv$reason = gsub('\'','',rfv$reason)
aux = which(rfv$reason == "  ")
rfv = rfv[-aux,]
write.csv(x = rfv,file = 'Data/rfv.csv')
lrfv = as.list(rfv$codes)
names(lrfv) = rfv$reason