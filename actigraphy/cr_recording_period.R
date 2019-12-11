## Cosinor Method Circadian Measures Calcuation Varied by Recording Period (Days)
## Megan McMahon
## Fall 2019

library(lubridate)
library(tidyverse)
library(reshape2)
library(RColorBrewer)
library(stringr)

read_actig_file <- function(filename) {
  # read actigraphy file - csv format, 2 columns, datetime and activity
  d=read.csv(filename, header=TRUE, sep=',', na.string=' ', stringsAsFactors = FALSE)
  colnames(d) <- c('time', 'activity')
  d$record_id <- stringr::str_sub(basename(filename), 1, 5)
  d$total_recording_period <- ymd_hms(tail(d$time, 1), tz="UTC") - ymd_hms(head(d$time, 1), tz="UTC")
  return(d)
}

get_watch_end_times <- function(csvsave = FALSE){
  end_times = read.csv("~/Box/CogNeuroLab/Aging Decision Making R01/Data/Redcap/AgingDecMem-WatchInformation_DATA_2019-12-08_0806.csv", stringsAsFactors = FALSE)
  end_times = select(end_times, record_id, actigraph_off)
  
  end_times$record_id = str_pad(end_times$record_id, 3, pad = "0")
  end_times$actigraph_off = ymd_hm(end_times$actigraph_off)
  end_times <- end_times[!is.na(end_times$actigraph_off), ]
  
  if (csvsave == TRUE){
    write.csv(end_times, "~/Box/CogNeuroLab/Aging Decision Making R01/Data/Actigraphy/WatchOffs.csv")
  }
  
  return(end_times)
}

truncate <- function(d, ndays, end_times){
  # truncate to number of days desired for recording period
  # also removes values after recorded end time
  end = ymd_hms(end_times$actigraph_off[end_times$record_id == str_sub(d$record_id[1], -3, -1)], tz = "UTC")
  d <- d[d$time < end,]
  start = ymd_hms(tail(d$time, 1), tz="UTC") - days(ndays)
  d_truncated <- d[d$time >= start,]
  return(d_truncated)
}

plot_actigraphy <- function(d, SR, resolution){
  # d is actigraphy data from read_actig_file function
  # SR is sampling rate in 1/min (eg., for 30 second epochs, SR = 2)
  # resolution is for plot - number of hours to gather activity values across
  #d=read.csv(filename, header=TRUE, sep=',', na.string=' ', stringsAsFactors = FALSE)
  
  ggplot(data = d, aes(x = time, y = activity)) +
    geom_col() + 
    facet_wrap(. ~ day(time))
  p.act <- ggplot(d[seq(1, nrow(d), resolution*SR*60), ], aes(x = datetime, y = activity)) +
    geom_step() +
    theme_classic() +
    ggtitle(record_id[i])
  
  return(p.act)
}

circadian_measures <- function(d, ndays, end_times, print = FALSE) {
  # modified from Stephanie Sherman
  
  results <- data.frame(stringsAsFactors = FALSE)
  d <- truncate(d, ndays, end_times)
  d$cloktime=lubridate::hour(d$time) + lubridate::minute(d$time)/60
  
  if (sum(d$cloktime) != 0) {
    d$twopio24 = (2*3.14159)/24 
    d$xcos = cos(d$twopio24*d$cloktime) 
    d$xsin = sin(d$twopio24*d$cloktime)
    
    #d$activity=as.character(d$ZCM)
    #d$activity=as.numeric(d$PIM, 'NA')
    d$lactivity = log((d$activity +1),10)
    
    allwatch=d[,c('record_id','cloktime','lactivity','xcos','xsin','twopio24')]
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
      print(paste0("Unable to obtain cosinor model for subject ", d$record_id[1]))
      newline <- c(d$record_id[1], rep(NA, 12))
      return(newline)
    }
    
  }
}

# group_circadian_measures <- function(rhythm){
#   results <- rbind(results, rhythm)
#   colnames(results)=c('record_id','actamp','actbeta','actphi','actmin','actmesor','actupmesor','actdownmesor','actalph','actwidthratio','rsqact','fact','fnlrgact')
#   return(results)
# }

optimize_recording_period <- function(files, nsample, recording_period, print = TRUE) {
  
  all_results <- list()
  selected_files <- sample(files, nsample, replace = FALSE, prob = NULL)
  end_times <- get_watch_end_times(csvsave = FALSE)
  
  for (ndays in recording_period){
    results <- c()
    print(paste0(ndays, " days"))
    
    for (filename in selected_files){
      d <- read_actig_file(filename)
      
      if (d$total_recording_period[1] > ndays){
        rhythm <- circadian_measures(d, ndays, end_times)
        results <- rbind(results, rhythm)
      }
    }
    if (length(dim(results)) == 2) {
      colnames(results)=c('record_id','actamp','actbeta','actphi','actmin','actmesor','actupmesor','actdownmesor','actalph','actwidthratio','rsqact','fact','fnlrgact')
      all_results[[paste0(as.character(ndays), " days")]] <- results
    }
  }
  return(all_results)
}

plot_circadian_measures <- function(all_results) {
  
  all_results %>%
    melt(id.vars = "record_id") %>%
    ggplot(aes(x = L1, y = value, group = factor(record_id), color = factor(record_id))) + 
    geom_line() +
    geom_point() + 
    scale_color_brewer(palette = "Set1") +
    facet_wrap(. ~ variable, scales = "free") +
    theme(legend.title = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    xlab("Recording Period") + ylab(element_blank()) -> p
  
  return(p)
}

#this function in progress
plot_group_circadian_measures <- function(results1, results2, group1, group2) {
  tmp <- unlist(results1, F)
  tmp$Group <- group1
  
  # tmp2 <- unlist(results2, F)
  # tmp2$Group <- group2
  # 
  # tmp <- rbind(tmp1, tmp2)
  # factor(tmp$Group)
  
  mean_results <- c(by(tmp, names(tmp), mean))
  
  all_results %>%
    melt(id.vars = "record_id") %>%
    ggplot(aes(x = L1, y = value, group = record_id, color = record_id)) + 
    geom_line() +
    geom_point() + 
    facet_wrap(. ~ variable, scales = "free") -> p
  
  return(p)
}

# location of processed actigraphy files
work_dir <- '~/Box/CogNeuroLab/Aging Decision Making R01/Data/Actigraphy/processed'
files <- list.files(work_dir, pattern = '.csv', full.names = TRUE)

# separate out younger and older adults
ya_files <- files[startsWith(basename(files), "3")]
oa_files <- files[startsWith(basename(files), "4")]

# number of subjects to include
nsample = 10

# recording period of 3-10 days
recording_period = seq(3, 9, by = 1)

# calculate circadian measures based on different recording periods
ya_results <- optimize_recording_period(ya_files, nsample, recording_period)
oa_results <- optimize_recording_period(oa_files, nsample, recording_period)

# plot results
ya_plot <- plot_circadian_measures(ya_results)
ya_plot
ggsave('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/results/ya_recording_period_effect-2.png', ya_plot, width = 13, height = 7)

oa_plot <- plot_circadian_measures(oa_results)
oa_plot
ggsave('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/results/oa_recording_period_effect-2.png', oa_plot, width = 13, height = 7)

