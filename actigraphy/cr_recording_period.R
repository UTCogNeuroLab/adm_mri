## Cosinor Method Circadian Measures Calcuation Varied by Recording Period (Days)
## Megan McMahon
## Fall 2019

## CHANGE OUTPUT DIRECTORY!!!! ####################################

library(lubridate)
library(tidyverse)
library(reshape2)
library(RColorBrewer)
library(stringr)

read_actig_file <- function(filename) {
  # read actigraphy file - csv format, 2 columns, datetime and activity
  d=read.csv(filename, header=TRUE, sep=' ', na.string=' ', stringsAsFactors = FALSE)
  colnames(d) <- c('time', 'activity')
  d$record_id <- stringr::str_sub(basename(filename), 1, 5)
  d$total_recording_period <- ymd_hms(tail(d$time, 1), tz="UTC") - ymd_hms(head(d$time, 1), tz="UTC")
  return(d)
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

get_dates <- function(d){
  dates = unique(as.Date(d$time))
  return(dates)
}

plot_actigraphy <- function(d, date=NULL, print=TRUE){
  #date format is "2018-10-24"
  library(scales)
  
  if (is.null(date)){
    
    p.act <- ggplot(data = d, aes(x = as_datetime(time), y = activity)) + 
      geom_point(size = 0.7) + 
      scale_x_datetime(breaks = "day") +
      theme_minimal() + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      xlab("Time") + ylab("Activity") + theme(axis.text.x = element_blank())
    
  } else if (is.numeric(date)) {
    print(paste0("grabbing day ", date))
    
    dates = get_dates(d)
    date = dates[date]
    
    if (length(date) > 1){
      
      d2 <- d[(date(d$time) <= date[length(date)]), ]
      d2 <- d2[date(d2$time) >= date[1],]
      
      p.act <- ggplot(data = d2, aes(x = as_datetime(time), y = activity)) + 
        geom_point(size = 0.7) + 
        scale_x_datetime(breaks = "day") +
        theme_minimal() + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        xlab("Date") + ylab("Activity")
      
    } else {
      dates = unique(as.Date(d$time))
      date = dates[date]
      
      d2 <- d[date(d$time) == date,]
      
      p.act <- ggplot(data = d2, aes(x = as_datetime(time), y = activity)) + 
        geom_point(size = 0.7) + 
        scale_x_datetime(breaks = "2 hours", labels=date_format("%H:%M")) +
        theme_minimal() + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        xlab("Date") + ylab("Activity") 
    }
    
  } else if (is.Date(as.Date(date))) {
    
    print(paste0("it's a date! ", date))
    
    d2 <- d[date(d$time) == date,]
    
    p.act <- ggplot(data = d2, aes(x = as_datetime(time), y = activity)) + 
      geom_point(size = 0.7) + 
      scale_x_datetime(breaks = "2 hours", labels=date_format("%H:%M")) +
      theme_minimal() + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      xlab("Date") + ylab("Activity") 
    
  } 
  
  return(p.act)
}



# group_circadian_measures <- function(rhythm){
#   results <- rbind(results, rhythm)
#   colnames(results)=c('record_id','actamp','actbeta','actphi','actmin','actmesor','actupmesor','actdownmesor','actalph','actwidthratio','rsqact','fact','fnlrgact')
#   return(results)
# }

optimize_recording_period <- function(files, nsample, recording_period, proc_dir = out_dir, print = TRUE) {
  
  all_results <- list()
  selected_files <- sample(files, nsample, replace = FALSE, prob = NULL)
  end_times <- get_watch_end_times(csvsave = FALSE)
  
  for (ndays in recording_period){
    results <- c()
    print(paste0(ndays, " days"))
    
    for (filename in selected_files){
      d <- read_actig_file(filename)
      
      if (d$total_recording_period[1] > ndays){
        rhythm <- circadian_measures(d, ndays, end_times, proc_dir=proc_dir)
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
work_dir <- '~/Box/CogNeuroLab/Aging Decision Making R01/Data/Actigraphy/processed_2020-06-17'
out_dir <- paste0('~/Box/CogNeuroLab/Aging Decision Making R01/Data/Actigraphy/processed_R_', Sys.Date())
dir.create(out_dir, showWarnings = T)
files <- list.files(work_dir, pattern = '.csv', full.names = TRUE)

# separate out younger and older adults
ya_files <- files[startsWith(basename(files), "3")]
oa_files <- files[startsWith(basename(files), "4")]

# number of subjects to include
#nsample = 10
nsample = length(files)

# recording period of 3-10 days
#recording_period = seq(3, 9, by = 1)
recording_period = 7

# calculate circadian measures based on different recording periods
#ya_results <- optimize_recording_period(ya_files, nsample, recording_period)
#oa_results <- optimize_recording_period(oa_files, nsample, recording_period)
new_results <- optimize_recording_period(files, nsample, recording_period)
df <- data.frame(new_results$`7 days`)
write.csv(df, '~/Box/CogNeuroLab/Aging Decision Making R01/data/actigraphy/circadian_measures/7_days/cr_7days_new.csv')
#new_results <- optimize_recording_period("/Users/megmcmahon/Box/CogNeuroLab/Aging Decision Making R01/Data/Actigraphy/processed_2019-12-11/40878.csv", 1, 7)

# plot results
ya_plot <- plot_circadian_measures(ya_results)
ya_plot
ggsave(paste0('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/results/ya_recording_period_effect-', sys.Date(), '.png'), ya_plot, width = 13, height = 7)

oa_plot <- plot_circadian_measures(oa_results)
oa_plot
ggsave(paste0('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/results/oa_recording_period_effect-', sys.Date(), '.png'), oa_plot, width = 13, height = 7)


#non parametric actigraphy
library(lubridate)
library(nparACT)

#aging study
work_dir <- '~/Box/CogNeuroLab/Aging Decision Making R01/Data/Actigraphy/processed_2020-04-02/'

for (file in list.files(out_dir)[6:length(list.files(out_dir))]){
  print(file)
  act <- read_delim(paste0(work_dir, file), delim = ',',)
  act$time <- strftime(as_datetime(act$time, "%Y-%m-%d %H:%M:%S"))
  write.table(act, paste0(work_dir, file), sep = " ", row.names = F, col.names = F)
}

actall <- nparACT_base_loop(in_dir, SR = 1/30, fulldays = F)
actall$record_id <- substr(list.files(in_dir), 1, 5)
write.csv(actall, paste0(out_dir, "nparact_7days_.csv"), row.names = F)
