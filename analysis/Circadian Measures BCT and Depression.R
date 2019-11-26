library(readr)
library(tidyverse)
library(reshape2)


# Load Data ---------------------------------------------------------------


rpx <- read_csv("~/Box/CogNeuroLab/Aging Decision Making R01/Data/Actigraphy/Combined Export File.csv")

efficiency <- aggregate(efficiency ~ subject_id, rpx, mean, na.action = na.omit)
sleep_time <- aggregate(sleep_time ~ subject_id, rpx, mean, na.action = na.omit)
percent_wake <- aggregate(percent_wake ~ subject_id, rpx, mean, na.action = na.omit)
onset_latency <- aggregate(onset_latency ~ subject_id, rpx, mean, na.action = na.omit)
total_ac <- aggregate(total_ac ~ subject_id, rpx, mean, na.action = na.omit)

rpx2 <- merge(efficiency, sleep_time, by = 'subject_id')
rpx2 <- merge(rpx2, percent_wake, by = 'subject_id')
rpx2 <- merge(rpx2, onset_latency, by = 'subject_id')
rpx2 <- merge(rpx2, total_ac, by = 'subject_id')
head(rpx2)

cr <- read_csv('~/Box/CogNeuroLab/Aging Decision Making R01/Data/CR/circadian_rhythms_2019-09-07.csv')
cr$actquot <- cr$actamp/cr$actmesor

neuro <- read_csv("Box/CogNeuroLab/Aging Decision Making R01/Data/Neuropsych/AgingDecMemNeuropsyc_DATA_2019-06-12_0708.csv")

redcap <- read_csv("Box/CogNeuroLab/Aging Decision Making R01/Data/Redcap/AgingDecMem-SelfReportMeasures_DATA_2019-11-21_0959.csv")
redcap <- redcap[redcap$redcap_event_name == "online_eligibility_arm_1",]
redcap$record_id <- str_pad(redcap$record_id, 4, pad = "0")
redcap$record_id <- ifelse(redcap$age <= 31, paste0(3, redcap$record_id), paste0(4, redcap$record_id))

bct <- read_csv('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/rest/bct/bct_x.csv')

d <- merge(cr, redcap, by='record_id', all=TRUE)
d <- merge(d, neuro, by='record_id', all=TRUE)
d <- merge(d, bct, by='record_id', all=TRUE)
d <- merge(d, rpx2, by.x = 'record_id', by.y = 'subject_id', all=TRUE)
d <- d[(d$age.x >= 18) & (d$age.x <= 90) & !is.na(d$age.x), ]
d$group <- factor(ifelse(d$record_id < 40000, 0, 1))
d$group_name <- factor(ifelse(d$record_id < 40000, 0, 1), labels = c('Young Adults', 'Older Adults'))

write_csv(d, path = "~/Box/CogNeuroLab/Aging Decision Making R01/Data/combined_data_new.csv")



# Cognition -------------------------------------------------------

library(corrplot)

d_cor <- na.omit(select(d, IS:RA, actamp:fact, actquot, matches("zscore|z_score")))
M <- cor(d_cor)
res1 <- cor.mtest(d_cor, conf.level = 0.95)
corrplot(M, p.mat = res1$p, sig.level = 0.05, insig = "blank")

#trails b, cvlt fp
d_cor <- na.omit(select(d, matches("participation_x"), matches("zscore|z_score")))
M <- cor(d_cor)
res1 <- cor.mtest(d_cor, conf.level = 0.95)
corrplot(M, p.mat = res1$p, sig.level = 0.05, insig = "blank")

d_cor <- na.omit(select(d, IS:RA, actamp:fact, actquot, matches("participation_x")))
M <- cor(d_cor)
res1 <- cor.mtest(d_cor, conf.level = 0.95)
corrplot(M, p.mat = res1$p, sig.level = 0.05, insig = "blank")

summary(lm(ds_zscore ~ dmn_participation_x * group, data = d)) # NS
summary(lm(ds_zscore ~ dmn_participation_x, data = d)) # NS
summary(lm(ds_zscore ~ fpn_participation_x * group, data = d)) # NS
summary(lm(ds_zscore ~ fpn_participation_x, data = d)) # NS

summary(lm(trails_b_z_score ~ dmn_participation_x * group, data = d)) # NS
summary(lm(trails_b_z_score ~ dmn_participation_x + group, data = d)) # NS
summary(lm(trails_b_z_score ~ fpn_participation_x*group, data = d)) # p = 0.00951

d$`FPN Participation` <- factor(ifelse(d$fpn_participation_x < median(d$fpn_participation_x, na.rm = TRUE), 0, 1), labels = c("Low", "High"))
d$`DMN Participation` <- factor(ifelse(d$dmn_participation_x < median(d$dmn_participation_x, na.rm = TRUE), 0, 1), labels = c("Low", "High"))

d %>% 
  subset(!is.na(`FPN Participation`)) %>%
  ggplot() +
  aes(x = `FPN Participation`, color = group_name, group = group_name, y = trails_b_z_score) +
  stat_summary(fun.y = mean, na.rm = TRUE, geom = "point") +
  stat_summary(fun.y = mean, na.rm = TRUE, geom = "line") + 
  scale_color_manual(values = c("blue", "red")) +
  xlab('FPN Participation') + ylab('TMT-B')

summary(lm(trails_b_z_score ~ actmin, data = d)) 
summary(lm(trails_b_z_score ~ actquot, data = d)) 
summary(lm(trails_b_z_score ~ rsqact, data = d)) 
summary(lm(trails_b_z_score ~ fact, data = d)) 

# Depression -----------------------------------------------------

#YA, CESD - NS
d_cor <- na.omit(select(d, matches("participation_x"), matches("cesd")))
M <- cor(d_cor)
res1 <- cor.mtest(d_cor, conf.level = 0.95)
corrplot(M, p.mat = res1$p, sig.level = 0.05, insig = "blank")

#OA, GDS - NS
d_cor <- na.omit(select(d, matches("participation_x"), matches("self|gds")))
M <- cor(d_cor)
res1 <- cor.mtest(d_cor, conf.level = 0.95)
corrplot(M, p.mat = res1$p, sig.level = 0.05, insig = "blank")

#PSQI
d_cor <- na.omit(select(d, matches("participation_x"), matches("psqi|component")))
M <- cor(d_cor)
res1 <- cor.mtest(d_cor, conf.level = 0.95)
corrplot(M, p.mat = res1$p, sig.level = 0.05, insig = "blank")

#YA, CESD 7 (depressed), 8 (effortful), 13 (happy) ...
d_cor <- na.omit(select(d, IS:RA, actamp:fact, actquot, matches("cesd")))
M <- cor(d_cor)
res1 <- cor.mtest(d_cor, conf.level = 0.95)
corrplot(M, p.mat = res1$p, sig.level = 0.05, insig = "blank")

#OA, GDS fear-actmesor, energy-RA ...
d_cor <- na.omit(select(d, IS:RA, actamp:fact, actquot, matches("self|gds")))
M <- cor(d_cor)
res1 <- cor.mtest(d_cor, conf.level = 0.95)
corrplot(M, p.mat = res1$p, sig.level = 0.05, insig = "blank")
