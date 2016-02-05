setwd("~/Dropbox/Insight/Project/ATAT-app/")
# create list of patients
lpatients = list()

lpatients$name = c('Jane','Steve','David') # create names
lpatients$age = c(25,58,32) # create age
lpatients$sex = c(1,2,2) # create sex
# create chronical problem
lpatients$chron = vector('list',length(lpatients$age) + 1)
lpatients$chron[[1]] = NULL
lpatients$chron[[2]] = c(5)
lpatients$chron[[3]] = NULL

lpatients$chron[[length(lpatients$age) + 1]] = c(1) # extra value to ensure NULL itens

# create arrival
lpatients$arrival = vector('list',length(lpatients$age) + 1)
lpatients$arrival[[1]] = NULL
lpatients$arrival[[2]] = c(1)
lpatients$arrival[[3]] = c(2)

lpatients$arrival[[length(lpatients$age) + 1]] = c(1) # extra value to ensure NULL itens
# create reason for visit
lpatients$rfv = vector('list',length(lpatients$age) + 1)
lpatients$rfv[[1]] = c('rfv1_1015','rfv1_1045')
lpatients$rfv[[2]] = c('rfv1_5837')
lpatients$rfv[[3]] = c('rfv1_1505')

lpatients$rfv[[length(lpatients$age) + 1]] = c('rfv1_8997') # extra value to ensure NULL itens

lpatients$temp = c(97,90,98) # create temperature
lpatients$pulse = c(60,30,65) # create pulse
lpatients$pulseox = c(98,70,97) # create pulse ox
lpatients$resp = c(16,14,17) # create respiration
lpatients$bpsys = c(117,80,117) # create blood pressure sys
lpatients$bpdia = c(76,50,75) # create blood pressure dia
save(lpatients,file = 'Data/lpatients.Rdata')