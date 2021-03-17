library(ggplot2)
library(dplyr)
library(tidyverse)
library(lubridate)

record_id <- "40758" # 40861 is other
sr <- "10 min"

act_combined <- read.csv("/Users/megmcmahon/Box/CogNeuroLab/Aging Decision Making R01/Data/actigraphy/actiware_exports/Combined Export File.csv", 
                         header = TRUE, na.string = ' ', stringsAsFactors = FALSE)
rest <- act_combined %>%
  filter(subject_id == record_id) %>%
  filter(interval_type == "REST") %>%
  select(start_date, start_time, end_date, end_time)

rest$start <- ymd_hms(as.POSIXct(paste(rest$start_date, rest$start_time), format="%m/%d/%Y %I:%M:%S %p"))
rest$end <- ymd_hms(as.POSIXct(paste(rest$end_date, rest$end_time), format="%m/%d/%Y %I:%M:%S %p"))

act <- read.csv(paste0("/Users/megmcmahon/Box/CogNeuroLab/Aging Decision Making R01/Data/Actigraphy/processed_2020-06-17/", record_id, ".csv"), 
                header = TRUE, na.string = ' ', stringsAsFactors = FALSE)
colnames(act) <- c('time', 'activity')
act$time <- ymd_hms(act$time)


actsum <- act %>%
  group_by(Date=floor_date(time, sr)) %>%
  summarize(activity=mean(activity)) %>%
  as.data.frame()

ggplot() + 
  geom_rect(data=tail(rest, 7), inherit.aes=FALSE, 
            aes(xmin=start, xmax=end, 
                ymin=min(0), ymax=max(actsum$activity)), 
            fill="light blue")+ #, alpha=0.3) +
  geom_line(data = filter(actsum, Date > ymd_hms(tail(act$time, 1), tz="UTC") - days(7)), 
            aes(x = as_datetime(Date), y = activity), size = 0.6) +
  scale_x_datetime(breaks = "day", date_labels = "%a") +
  theme_classic() +
  xlab("Time") + ylab("Activity") + 
  ggsave(paste0("~/Desktop/", record_id, "_actplot_", sr, ".png"), dpi = 300, height = 4, width = 10, units = "in")
