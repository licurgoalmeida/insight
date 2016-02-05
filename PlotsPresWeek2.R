predsvm = predict(fitsvm,testing)
predlm = predict(fitlm,testing)
boxplot(predsvm ~ testing$immedr,horizontal = TRUE,xlab = "predicted score",ylab = "observed score",
        ylim = c(1,6),main = "svm")
abline(0,1,lty = 2,col = "red")
boxplot(predlm ~ testing$immedr,horizontal = TRUE,xlab = "predicted score",ylab = "observed score",
        ylim = c(1,6),main = "linear model")
abline(0,1,lty = 2,col = "red")

aux = which(ftable$arrems == 1)
barplot(table(ftable$immedr[aux])/table(ftable$immedr),xlab = "triage score",
        ylab = "proportion of visitors",main = "Arrival by ambulance")

aux = which(ftable$injury == 1)
barplot(table(ftable$immedr[aux])/table(ftable$immedr),xlab = "triage score",
        ylab = "proportion of visitors",main = "Reporting injury")

boxplot(ftable$age ~ ftable$immedr,notch = T,xlab = "triage score",ylab = "age (years)",varwidth = T,
        main = "Visitors' age")