setwd("~/Dropbox/Insight/Project")
library(caret)
source("auxfuncs.R")
source("constructTable.R")
source("countUnique.R")
source("CalcR2.R")
source("CalcRmse.R")

# Load data
tdata = read.csv("data/triage_data.csv") # triage data
gdata = read.csv("data/group_data.csv") # grouped data
rdata = read.csv("data/removed_data.csv") # removed data

names = names(tdata)
remnames = names(rdata)
grnames = names(gdata)


# Remove columns with excess of NAs
nacols = removeNAs(tdata,0.1) # using 10% threshold
rdata = cbind(rdata,tdata[,nacols])
tdata = tdata[,-nacols]

# Remove ERs with no triage
aux = which(rdata$immedr == 7)
rdata = rdata[-aux,]
tdata = tdata[-aux,]
gdata = gdata[-aux,]

# Remove entries with DOA
aux = which(rdata$doa == 1)
rdata = rdata[-aux,]
tdata = tdata[-aux,]
gdata = gdata[-aux,]

# Remove hospitals with few entries
count = removeHospitals(tdata)
auxcount = which(count <= 30)
tdata = tdata[-auxcount,]
gdata = gdata[-auxcount,]
rdata = rdata[-auxcount,]

# Remove 

# Keep only complete cases
ccases = which(complete.cases(tdata))
tdata = tdata[ccases,]
gdata = gdata[ccases,]
rdata = rdata[ccases,]

count = countUnique(tdata)

# Construct working table
ftable = constructTable(tdata,gdata)
aux = nearZeroVar(ftable, freqCut = 99.5/0.5, uniqueCut = 5,saveMetrics = FALSE)
ftable = ftable[,-aux]
ftable = cbind(rdata$immedr,ftable)
name = names(ftable)
name[1] = "immedr"
names(ftable) = name
# Saving data
write.csv(ftable, file = "data/triage_clean.csv")

# Create training and testing data
trainfeat = "immedr"
intrain = createDataPartition(y = ftable[ ,trainfeat],p = 0.5,list = FALSE)
training = ftable[intrain,] # Training data
testing  = ftable[-intrain,] # Testing data
weight = rdata$patwt[intrain]

# training model
ctrl = trainControl(method = "repeatedcv",repeats = 2) # Define training method
tgrid = expand.grid(ncomp = c(8))
fitpls = train(immedr ~ ., # Select training feature
               data = training, # Select database
               method = "pls", # Select training method
               preProcess = c("center","scale"),
               trControl = ctrl,
               tuneGrid = tgrid) # Define pre-process parameters
imppls = varImp(fitpls)
plot(imppls,top = 10)

ctrl = trainControl(method = "repeatedcv",repeats = 1) # Define training method
tgrid = expand.grid(C = C,sigma = sigma)
fitsvm = train(immedr ~ ., # Select training feature
               data = training, # Select database
               method = "svmRadial", # Select training method
               preProcess = c("center","scale"),
               trControl = ctrl,
               tuneGrid = tgrid) # Define pre-process parameters
               #tuneLength = 6)

fitlm = train(immedr ~ ., # Select training feature
               data = training, # Select database
               method = "lm", # Select training method
               #weights = weight,
               preProcess = c("center","scale"),
               trControl = ctrl,
               tuneLength = 1) # Define pre-process parameters

# Feature importance
impSVM = varImp(fitsvm)
plot(impSVM,top = 10)

implm = varImp(fitlm)
plot(implm,top = 10)

# Score distribution
barplot(table(ftable$immedr),ylab = "entries",xlab = "score")
# Test model
test = predict(fitsvm,testing) # Predict testing data
rmse = CalcRmse(testing$immedr,test) # Calculate RMSE
r2 = CalcR2(testing$immedr,test) # Calculate R2