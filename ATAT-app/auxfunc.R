prednsort = function(outdf,fitlm,basepatient,name,age,sex,chronic,arrival,rfv,temp,pulse,popct,respr,bpsys,bpdias){
  samplepatient = basepatient
  # Setup age
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
    samplepatient['cebvd'] = 1
  }
  if (length(which(as.numeric(chronic) == 2)) == 1){
    samplepatient['chf'] = 1
  }
  if (length(which(as.numeric(chronic) == 3)) == 1){
    samplepatient['eddial'] = 1
  }
  if (length(which(as.numeric(chronic) == 4)) == 1){
    samplepatient['edhiv'] = 1
  }
  if (length(which(as.numeric(chronic) == 5)) == 1){
    samplepatient['diabetes'] = 1
  }
  
  # Setup arrival
  if (length(which(as.numeric(arrival) == 1)) == 1){
    samplepatient['arrems'] = 1
  }
  if (length(which(as.numeric(arrival) == 2)) == 1){
    samplepatient['injury'] = 1
  }
  
  # Setup reason for visit
  for (ii in 1:length(rfv)){
    auxrfv = substring(rfv[ii],1,8)
    samplepatient[auxrfv] = 1
  }
  
  samplepatient['tempf'] = as.numeric(temp) * 10 # Setup temperature
  samplepatient['pulse'] = as.numeric(pulse) # Setup pulse
  samplepatient['popct'] = as.numeric(popct) # Setup popct
  samplepatient['respr'] = as.numeric(respr) # Setup respr
  samplepatient['bpsys'] = as.numeric(bpsys) # Setup bpsys
  samplepatient['bpdias'] = as.numeric(bpdias) # Setup bpdias
  
  y = predict(fitlm,samplepatient)
  if (y > 3.5){
    fasttrack = 'YES'
  }else{
    fasttrack = 'NO'
  }
  if (name == ''){
    return(outdf)
  }else{
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
loadsql = function(dtable){
  drv = dbDriver("MySQL")
  con = dbConnect(drv, user="root",password = "hello", dbname="triage",host="127.0.0.1")
  dbListTables(con)
  t = dbReadTable(con, dtable)
  dbDisconnect(con)
  return(t)
}
echodata = function(d){
  return(d)
}

populate = function(outdf){
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
  if (nrow(outdf) > 0){
    aux = which(outdf$predict == min(outdf$predict))
    outdf = outdf[-aux[1],]
  }
  return(outdf)
}

removefasttrack = function(outdf){
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
  newdf = data.frame(
    name = outdf$name,
    fasttrack = outdf$fasttrack,
    stringsAsFactors = FALSE,
    row.names = row.names(outdf))
  return(newdf)
}
