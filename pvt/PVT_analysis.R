#Calculate RT Using PC-PVT 2.0 Data
#Megan McMahon
#12/11/2019

#See User's Guide p. 21
#times are in seconds

library(readr)

pvt_dir <- "~/Box/CogNeuroLab/Aging Decision Making R01/Data/PVT"
pvt_files <- list.files(pvt_dir, pattern = "data.raw", recursive = TRUE, full.names = TRUE)
head(pvt_files)

#fix this function!
relative_reaction_time = function(d){
  if (d$fs == 1){
    rt = 1
  } else if (d$nr == 1){
    rt = 65000
  } else {
    rt = round((d$rt - d$st)*1000)
  }
  return(rt)
}

elapsed_time = function(d){
  et = (round(d$rt * 10))/10
  return(et)
}

actual_isi = function(d){
  isi = round((d$st - d$it)*1000)
  return(isi)
}

#marking the false alarms and response lapses	
false_starts = function(d){
  fs = sum(d$fs == 1)
}

response_lapses = function(d){
  rl = sum(d$nr == 1)
}

##Eliminate answers that are less than 100ms and greater than 500
trim=all[all$RT>100 & all$RT<500,]

pvt = c()
i = 1
for (file in pvt_files[1]){
  d = read_delim(file, delim = ",", trim_ws = TRUE)
  record_id = substr(strsplit(file, "PVT/")[[1]][2], 2, 6)
  rt = relative_reaction_time(d)
  rt_mean = mean(rt)
  rt_sd = sd(rt)
  fs = false_starts(d)
  rl = response_lapses(d)
  pvt[i] = c(record_id, rt_mean, rt_sd, fs, rl)
  i = i+1
}


