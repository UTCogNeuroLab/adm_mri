# Extended Cosinor Model
# Based on Marler 2006
# Calculate amplitude, slope (beta), minimum, mesor, up-mesor, width (alpha), width-ratio, r2, F-statistic
# Stephanie Sherman

circadian_measures <- function(act_data) {
  # act_data should contain actigraphy data and have the following columns: time (date + time), activity, and record_id (subject ID
  
  require(lubridate)
  require(readr)
  
  results <- data.frame(stringsAsFactors = FALSE)
  act_data$cloktime=lubridate::hour(act_data$time) + lubridate::minute(act_data$time)/60
  
  if (sum(act_data$cloktime) != 0) {
    act_data$twopio24 = (2*3.14159)/24 
    act_data$xcos = cos(act_data$twopio24*act_data$cloktime) 
    act_data$xsin = sin(act_data$twopio24*act_data$cloktime)
    
    #act_data$activity=as.character(act_data$ZCM)
    #act_data$activity=as.numeric(act_data$PIM, 'NA')
    act_data$lactivity = log((act_data$activity +1),10)
    
    allwatch=act_data[,c('record_id','cloktime','lactivity','xcos','xsin','twopio24')]
    allwatch=na.omit(allwatch)
    
    model=lm(allwatch$lactivity ~ allwatch$xcos + allwatch$xsin)
    allwatch$linactxb=coef(model)['(Intercept)']
    allwatch$linactcos=coef(model)['allwatch$xcos']
    allwatch$linactsin=coef(model)['allwatch$xsin']
    #need column for residuals called linract
    allwatch$linract=model$residuals
    
    # filename = paste0(work_dir, '/residuals/', subject, '_residuals.csv')
    # write.csv(allwatch, file = filename, row.names = FALSE)
    
    actres1 <- allwatch
    
    actres1$linactamp = sqrt(actres1$linactcos^2 + actres1$linactsin^2)
    actres1$linactmin = actres1$linactxb-actres1$linactamp 
    
    for (p in 1:length(actres1$lactivity[1])){
      if (actres1$linactsin[1] > 0 & actres1$linactcos[1] > 0) {
        actres1$phase = atan(actres1$linactsin/actres1$linactcos)}
      else if (actres1$linactsin[1] > 0 & actres1$linactcos[1] < 0) {
        actres1$phase = 3.14159 - atan(actres1$linactsin/abs(actres1$linactcos))}
      else if (actres1$linactsin[1] < 0 & actres1$linactcos[1] < 0) {
        actres1$phase = 3.14159 + atan(abs(actres1$linactsin)/abs(actres1$linactcos))}
      else {(actres1$linactsin[1] < 0 & actres1$linactcos[1] > 0)
        actres1$phase = 2*3.14159 - atan(abs(actres1$linactsin)/(actres1$linactcos))} 
    }
    
    actres1$linactacro = actres1$phase*24/(2*3.14159) 
    
    #get sum of squares (uss variable)
    linractuss=(sum((actres1$linract)^2))-((sum(actres1$linract))^2/(length(actres1$linract))) 
    
    #num_nonmissingvalues
    nlinract=dim(actres1)[1]
    
    #nonlinear regression
    carhythm = function(actphi,actbeta,actalph,actmin,actamp,cloktime) {
      twopio24 = (2*3.14159)/24 
      rhythm = cos(twopio24*(cloktime - actphi ))
      lexpt=actbeta*(rhythm - actalph)
      expt = exp(lexpt)
      er = expt/(1 + expt)
      actmin + actamp*er
      
    }
    
    #if want it to print out iterations change trace=TRUE
    error = try(b <- nls(actres1$lactivity ~carhythm(actphi,actbeta,actalph,actmin,actamp,cloktime),
                         data=actres1, algorithm='port',
                         start=list(actphi = 12,actbeta = 2.00,actalph = 0.0,actmin =0,actamp=1),
                         lower=list(actphi = -3,actbeta = 0,actalph = -1,actmin =0,actamp=1),
                         upper=list(actphi = 27,actbeta = Inf,actalph = 1,actmin =Inf,actamp=5),
                         control=list(maxiter=200), #warnOnly=TRUE
                         trace=FALSE))
    print(error)
    
    if(class(error)!="try-error"){
      actres1$rnlact=resid(b)
      actres1$pnlact=fitted(b)	
      
      
      # take estimates from model and add to actres (in SAS all5) changes parameter names
      ## x beginning variables are the same as the e beginning variables
      actres1$xactphi=coef(b)['actphi']
      actres1$xactbeta=coef(b)['actbeta']
      actres1$xactalph=coef(b)['actalph']
      actres1$xactmin=coef(b)['actmin']
      actres1$xactamp=coef(b)['actamp']
      
      actres1$coact = actres1$linactxb + actres1$linactcos*actres1$xcos + actres1$linactsin*actres1$xsin
      
      ncssrnlact=(sum((actres1$rnlact)^2))-((sum(actres1$rnlact))^2/(length(actres1$rnlact)))
      cssact=(sum((actres1$lactivity)^2))-((sum(actres1$lactivity))^2/(length(actres1$lactivity)))
      nact=length(actres1$lactivity)
      nlinract=length(actres1$lactivity) 
      
      
      actacos=acos(actres1$xactalph[1])/actres1$twopio24[1]
      acthalftimel=-actacos + actres1$xactphi[1]
      acthalftimer=actacos + actres1$xactphi[1]
      actwidthratio = 2*actacos/24
      
      
      if(actres1$xactalph[1] < -0.99 |actres1$xactalph[1] > 0.99){
        actwidthratio = 0.5
        acthalftimel = (actres1$xactphi[1] - 6)
        acthalftimer = actres1$xactphi[1] + 6
      }
      
      actdervl = -sin((acthalftimel - actres1$xactphi[1])*actres1$twopio24[1])
      actdervr = -sin((acthalftimer - actres1$xactphi[1])*actres1$twopio24[1])	
      
      #sd is standard error I can get that from nls output 
      sdactphi=summary(b)$coefficients['actphi',2]
      sdactbeta=summary(b)$coefficients['actbeta',2]
      sdactalph=summary(b)$coefficients['actalph',2]
      sdactmin=summary(b)$coefficients['actmin',2]
      sdactamp=summary(b)$coefficients['actamp',2]
      
      #t is t value from model
      tactphi=summary(b)$coefficients['actphi',3]
      tactbeta=summary(b)$coefficients['actbeta',3]
      tactalph=summary(b)$coefficients['actalph',3]
      tactmin=summary(b)$coefficients['actmin',3]
      tactamp=summary(b)$coefficients['actamp',3]
      
      rsqact = (cssact - ncssrnlact)/cssact  
      fact = ((cssact - ncssrnlact)/4)/(ncssrnlact/(nlinract - 5))
      ndf = 4
      ddfact = nlinract - 5
      efact = ddfact/(ddfact - 2)
      varfact = ( 2/ndf )*( efact**2 )*( (ndf + ddfact -2)/(ddfact - 4) )  #wilks p. 187 */;
      tfact = (fact - efact)/sqrt(varfact)
      varact = cssact/(nlinract - 1)
      mselinact = linractuss/(nlinract - 3)
      msenlinact = (ncssrnlact/(nlinract - 5))
      fnlrgact = ((linractuss - ncssrnlact)/2)/(ncssrnlact/(nlinract - 5)) 
      flinact = ((cssact - linractuss)/2)/(linractuss/(nlinract - 3)) 
      
      actmesor = actres1$xactmin[1] + (actres1$xactamp[1]/2) 
      actupmesor = acthalftimel
      actdownmesor = acthalftimer 
      actamp=actres1$xactamp[1]
      actbeta=actres1$xactbeta[1]
      actphi=actres1$xactphi[1]
      actmin=actres1$xactmin[1]
      actalph=actres1$xactalph[1]
      session=actres1$session[1]
      record_id=actres1$record_id[1]
      rhythm=as.character(c(record_id, actamp,actbeta,actphi,actmin,actmesor,actupmesor,actdownmesor,actalph,actwidthratio,rsqact,fact,fnlrgact))
      newline <- data.frame(t(rhythm), stringsAsFactors = FALSE)
      #results <- rbind(results, newline)
      return(newline)
    }else{
      print(paste0("Unable to obtain cosinor model for subject ", act_data$record_id[1]))
      newline <- c(act_data$record_id[1], rep(NA, 12))
      return(newline)
    }
    
  }
}
