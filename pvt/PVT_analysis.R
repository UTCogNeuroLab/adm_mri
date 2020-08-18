#Calculate RT Using PC-PVT 2.0 Data
#Megan McMahon
#12/11/2019

#See PC-PVT 2.0 User's Guide p. 21 for variable descriptions

relative_reaction_time = function(d){
  rt = c()
  for (i in 1:dim(d[,1])[1]){
    if (d$fs[i] == 1){
      # if false alarm, rt set to 1
      rt[i] = 1
    } else if (d$nr[i] == 1){
      # if no response, rt set to 65000
      rt[i] = 65000
    } else {
      # if response, calculate relative reaction time
      rt[i] = round((d$rt[i] - d$st[i])*1000)
    }
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
  return(fs)
}

response_lapses = function(d){
  rl = sum(d$nr == 1)
  return(rl)
}

pvt_stats = function(pvt_files, print = TRUE){
  library(readr)
  
  pvt = c()
  pvt_all = c()
  i = 1
  for (file in pvt_files){
    record_id = substr(strsplit(file, "PVT")[[1]][2], 2, 6)
    print(record_id)
    
    d = read_delim(file, delim = ",", trim_ws = TRUE)
    
    if (dim(d) == c(0, 0)){
      print("PVT file empty")
    } else {
      rt = relative_reaction_time(d)
      rt_mean = mean(rt)
      rt_sd = sd(rt)
      fs = false_starts(d)
      rl = response_lapses(d)
      pvt = c(record_id, rt_mean, rt_sd, fs, rl)
      pvt_all = rbind(pvt_all, pvt)
      i = i+1
    }
  }
  colnames(pvt_all) = c("record_id", "rt_mean", "rt_sd", "fs", "rl")
  head(pvt_all)
  pvt_all <- data.frame(pvt_all, row.names = NULL)
  return(pvt_all)
}

#set directory to pvt data files
pvt_dir <- "~/Box/CogNeuroLab/Aging Decision Making R01/data/PVT"
pvt_files <- list.files(pvt_dir, pattern = "data.raw", recursive = TRUE, full.names = TRUE)
head(pvt_files)

#remove ineligible participants
pvt_files[!is.na(stringr::str_match(pvt_files, "_DQ"))]
pvt_files <- pvt_files[is.na(stringr::str_match(pvt_files, "_DQ"))]

stringr::str_match(pvt_files, "40728") #103
stringr::str_match(pvt_files, "40796") #125

pvt_files
#get pvt rt stats
pvt_all <- pvt_stats(pvt_files)

write_csv(pvt_all, paste0("~/Box/CogNeuroLab/Aging Decision Making R01/data/pvt/pvt_stats_", Sys.Date(), ".csv"))

          