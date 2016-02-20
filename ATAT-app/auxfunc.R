# auxfunc is a collection of auxiliary functions used in the ATAT app.
# Licurgo de Almeida (licurgoalmeida@gmail.com)
# 01/25/2016

prednsort = function(outdf,fitlm,basepatient,name,age,sex,chronic,arrival,rfv,temp,pulse,popct,respr,bpsys,bpdias){
  # prednsort receives parameters from the patients and:
  # - predic their triage score;
  # - order patients according to this triage score so that lower scores go first.
  # This function receives a large list of parameters, where:
  # - outdf: data frame with the waiting list;
  # - fitlm: linear model object;
  # - basepatient: vector with the baseline patient used in the linear model. This patient carries
  #                hospital information from hospcode 072;
  # - name: patient's name;
  # - age: patient's age (in years);
  # - sex: patient gender (male|female);
  # - chronic: list of chronic diseases (see app);
  # - arrival: did the patient arrived by ambulance (true|false);
  # - rfv: reason for visit;
  # - temp: patient's temperature (in F);
  # - pulse: patient's pulse (per minute);
  # - popct: patient's pulse oximetry;
  # - resp: patient's respiration frequency (per minute);
  # - bpsys|bpdias: patient's blood pressure (sys and dias).
  samplepatient = basepatient
  # Setup age: the variable age is used as one feature, but also also broken in categories, called ager
  samplepatient['age'] = age
  if (age < 25 & age >= 15){
    samplepatient['ager_2'] = 1
  }else if(age < 45 & age >= 25){
    samplepatient['ager_3'] = 1
  }else if(age < 75 & age >= 65){
    samplepatient['ager_5'] = 1
  }else if(age >= 75){
    samplepatient['ager_6'] = 1
  }
  
  samplepatient['sex'] = as.numeric(sex) # Setup sex
  
  # Setup chronic disease
  if (length(which(as.numeric(chronic) == 1)) == 1){
    samplepatient['cebvd'] = 1 # Cerebrovascular disease
  }
  if (length(which(as.numeric(chronic) == 2)) == 1){
    samplepatient['chf'] = 1 # Congestive heart failure
  }
  if (length(which(as.numeric(chronic) == 3)) == 1){
    samplepatient['eddial'] = 1 # Condition requiring dialysis
  }
  if (length(which(as.numeric(chronic) == 4)) == 1){
    samplepatient['edhiv'] = 1 # HIV
  }
  if (length(which(as.numeric(chronic) == 5)) == 1){
    samplepatient['diabetes'] = 1 # Diabetes
  }
  
  # Setup arrival
  if (length(which(as.numeric(arrival) == 1)) == 1){
    samplepatient['arrems'] = 1 # Patient arrived by ambulance
  }
  if (length(which(as.numeric(arrival) == 2)) == 1){
    samplepatient['injury'] = 1 # Patient reports injury
  }
  
  # Setup reason for visit
  for (ii in 1:length(rfv)){
    auxrfv = substring(rfv[ii],1,8)
    samplepatient[auxrfv] = 1 # Add reasons for visit to the patient.
  }
  
  samplepatient['tempf'] = as.numeric(temp) * 10 # Setup temperature
  samplepatient['pulse'] = as.numeric(pulse) # Setup pulse
  samplepatient['popct'] = as.numeric(popct) # Setup popct
  samplepatient['respr'] = as.numeric(respr) # Setup respr
  samplepatient['bpsys'] = as.numeric(bpsys) # Setup bpsys
  samplepatient['bpdias'] = as.numeric(bpdias) # Setup bpdias
  
  y = predict(fitlm,samplepatient) # Run predictor
  if (y > 3.5){ # If score higher than 3.5, classify patient as candidate for fast track. This
                # number is arbitrary
    fasttrack = 'YES'
  }else{
    fasttrack = 'NO'
  }
  if (name == ''){
    return(outdf) # If patient has no name, return the original dataframe
  }else{ # Add patients to waiting list and reorder this list based on the triage score
    auxn = names(outdf)
    newrow = c(name,as.character(signif(y, digits = 3)),fasttrack)
    outdf = rbind(outdf,newrow)
    names(outdf) = auxn
    for (ii in 1:length(auxn)){
      outdf[,auxn[ii]] = as.character(outdf[,auxn[ii]])
    }
    outdf = outdf[order(outdf$predict),]
    return(outdf)
  }
  
}
loadsql = function(dtable,pass){
  # loadsql loads patient table from SQL database and creates a dataframe
  # This function receives two parameters:
  # - dtable: name of the table to download;
  # - pass: DB password
  drv = dbDriver("MySQL")
  con = dbConnect(drv, user="root",password = pass, dbname="triage",host="127.0.0.1")
  dbListTables(con)
  t = dbReadTable(con, dtable)
  dbDisconnect(con)
  return(t)
}
echodata = function(d){
  # achodata is an auxiliary function to help debugging the code
  return(d)
}

populate = function(outdf){
  # populate creates a list of patients to be used in demos
  gname = c('Patient 1','Patient 2','Patient 3','Patient 4') 
  gscore = c(2.9,2.7,4.01,3.2)
  gfasttrack = c('NO','NO','YES','NO')
  auxn = names(outdf)
  for (ii in 1:length(gname)){
    newrow = c(gname[ii],as.character(gscore[ii]),gfasttrack[ii])
    outdf = rbind(outdf,newrow)
    names(outdf) = auxn
    for (jj in 1:length(auxn)){
      outdf[,auxn[jj]] = as.character(outdf[,auxn[jj]])
    }
  }
  outdf = outdf[order(outdf$predict),]
  return(outdf)
}

removepatient = function(outdf){
  # removepatient removes patients from ER queue
  if (nrow(outdf) > 0){
    aux = which(outdf$predict == min(outdf$predict))
    outdf = outdf[-aux[1],]
  }
  return(outdf)
}

removefasttrack = function(outdf){
  # removefasttrack removes patients where fasttrack == TRUE
  if (nrow(outdf) > 0){
    ft = which(outdf$fasttrack == "YES")
      if (length(ft) > 0){
        maxft = max(outdf$fasttrack[ft])
        aux = which(outdf$fasttrack == maxft)
        outdf = outdf[-aux[1],]
      }
  }
  return(outdf)
}

createnewdf = function(outdf){
  # createnewdf create a new df based on the original outdf to be used by renderFormattable
  newdf = data.frame(
    id = row.names(outdf),
    name = outdf$name,
    fasttrack = outdf$fasttrack,
    stringsAsFactors = FALSE)
  return(newdf)
}
