fsvol <- read_delim(paste0(data_dir, "mri/aseg.vol.table"), delim = "\t")
fsvol$cc_vol <- fsvol$CC_Anterior + fsvol$CC_Central + fsvol$CC_Mid_Anterior + fsvol$CC_Mid_Posterior + fsvol$CC_Posterior

ICVnorm <- function(d, x){
  
  f <- paste(x, "~ EstimatedTotalIntraCranialVol")
  b <- as.numeric((lm(f, d))$coefficients[2])
  d[x] = d[x] - b * (d$EstimatedTotalIntraCranialVol - mean(d$EstimatedTotalIntraCranialVol, na.rm = TRUE))
  
  return(d)
}

cols <- names(fsvol[,grepl("CC_", names(fsvol))])
for (col in cols){
  fsvol2 <- ICVnorm(fsvol, col)
}

fsvol2$record_id <- substring(fsvol2$`Measure:volume`, 5, 9)