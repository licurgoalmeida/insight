# train model
library(caret)
setwd("~/Dropbox/Insight/Project")
# Load data
load("data/immedr3.hall.age1.emat.preproc.RData") # Pre-processed data
ftable = resPreProc$smat
names(ftable) = resPreProc$labels
triage = as.numeric(resPreProc$triage)
# Create training and testing data
intrain = createDataPartition(y = triage,p = 0.2,list = FALSE)
trainy = triage[intrain] # Training outcome
testy = triage[-intrain] # Testing outcome
training = ftable[intrain,] # Training data
testing  = ftable[-intrain,] # Testing data

# training$tempf = (training$tempf - mean(ftable$tempf))^2
# training$pulse = (training$pulse - mean(ftable$pulse))^2
# training$popct = (training$popct - mean(ftable$popct))^2
# training$respr = (training$respr - mean(ftable$respr))^2
# training$bpsys = (training$bpsys - mean(ftable$bpsys))^2
# training$bpsys = (training$bpsys - mean(ftable$bpsys))^2

ctrl = trainControl(method = "oob",repeats = 1) # Define training method
fitrf = train(y = trainy, # Select training feature
                x = training, # Select database
                method = "rf", # Select training method
                preProc = c("center", "scale"),
                trControl = ctrl,
                tuneLength = 8) # Define pre-process parameters

mtry = fitrf$bestTune$mtry

intrain = createDataPartition(y = triage,p = 0.8,list = FALSE)
trainy = triage[intrain] # Training outcome
testy = triage[-intrain] # Testing outcome
training = ftable[intrain,] # Training data
testing  = ftable[-intrain,] # Testing data

tgrid = expand.grid(mtry = mtry)

ctrl = trainControl(method = "oob",repeats = 1) # Define training method
fitrf = train(y = trainy, # Select training feature
                x = training, # Select database
                method = "rf", # Select training method
                preProc = c("center", "scale"),
                tuneGrid = tgrid,
                trControl = ctrl) # Define pre-process parameters

ctrl = trainControl(method = "repeatedcv",repeats = 1) # Define training method
fitlas = train(y = trainy, # Select training feature
              x = training, # Select database
              method = "lasso", # Select training method
              preProc = c("center", "scale"),
              trControl = ctrl,
              tuneLength = 1) # Define pre-process parameters

ctrl = trainControl(method = "repeatedcv",repeats = 1) # Define training method
fitlm = train(y = trainy, # Select training feature
              x = training, # Select database
              method = "lm", # Select training method
              preProc = c("center", "scale"),
              trControl = ctrl,
              tuneLength = 1) # Define pre-process parameters

ctrl = trainControl(method = "repeatedcv",repeats = 1) # Define training method
fitsvml = train(y = trainy, # Select training feature
              x = training, # Select database
              method = "svmLinear", # Select training method
              preProc = c("center", "scale"),
              trControl = ctrl,
              tuneLength = 1) # Define pre-process parameters

ctrl = trainControl(method = "repeatedcv",repeats = 20) # Define training method
tgrid = expand.grid(nhid=c(550),actfun = c("purelin"))
fitelm = train(y = trainy, # Select training feature
                x = training, # Select database
                method = "elm", # Select training method
                preProc = c("center", "scale"),
                tuneGrid = tgrid,
                trControl = ctrl) # Define pre-process parameters

ctrl = trainControl(method = "repeatedcv",repeats = 1) # Define training method
fitpls = train(y = trainy, # Select training feature
               x = training, # Select database
               method = "pls", # Select training method
               preProc = c("center", "scale"),
               trControl = ctrl,
               tuneLength = 40) # Define pre-process parameters