constructTable = function(t,g){
  source("countUnique.R")
  source("create_binary_list.R")
  source("create_categorical_list.R")
  feats = c("age","arrtime","pulse","respr","tempf")
  ftable = t[,feats]
  lnames = names(ftable)
  t = t[,-which(names(t) %in% feats)]
  count = countUnique(t)
  countnames = names(t)
  for (ii in 1:length(count)){
    if (count[ii] < 3){
      ftable = cbind(ftable,t[,ii])
      lnames = c(lnames,countnames[ii])
    }else{
      df = as.data.frame(create_binary_list(t[,ii],paste(countnames[ii],"_",sep = "")))
      ftable = cbind(ftable,df)
      lnames = c(lnames,names(df))
    }
  }
#   df = as.data.frame(create_binary_list(g$advcomp1,"advcomp_"))
#   ftable = cbind(ftable,df)
#   lnames = c(lnames,names(df))
#   df = as.data.frame(create_binary_list(g$cause1r,"cause_"))
#   ftable = cbind(ftable,df)
#   lnames = c(lnames,names(df))
#   df = as.data.frame(create_binary_list(g$injr1,"injr_"))
#   ftable = cbind(ftable,df)
#   lnames = c(lnames,names(df))
#   df = as.data.frame(create_binary_list(g$rfv1,"rfv_"))
#   ftable = cbind(ftable,df)
#   lnames = c(lnames,names(df))
  names(ftable) = lnames
  return(ftable)
}