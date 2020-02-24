library(readr)
library(tidyverse)


d <- read_csv('/Users/PSYC-mcm5324/Box/CogNeuroLab/Aging Decision Making R01/Data/data_02_24_2020.csv')
str(d)

summary(lm(trails_b_z_score ~ CC_AD*Group, data = d)) #
summary(lm(trails_b_z_score ~ CC_FA, data = d))
summary(lm(trails_b_z_score ~ CC_RD, data = d))
summary(lm(trails_b_z_score ~ CC_MD, data = d))

summary(lm(trails_b_z_score ~ Group + age + years_educ, data = d))
summary(lm(trails_b_z_score ~ years_educ, data = d))
summary(lm(trails_b_z_score ~ Group, data = d))

summary(lm(CC_AD ~ age, data = d[d$Group == "Older Adults",]))
summary(lm(CC_AD ~ age, data = d[d$Group == "Young Adults",]))

summary(lm(CC_AD ~ IS*Group, data = d)) #
summary(lm(CC_AD ~ IV*Group, data = d))
summary(lm(CC_AD ~ IV, data = d[d$Group == "Older Adults",])) #
summary(lm(CC_AD ~ IV, data = d[d$Group == "Young Adults",]))

summary(lm(ds_zscore ~ CC_AD*Group, data = d)) #

summary(lm(trails_b_z_score ~ sleep_time*Group, data = d)) 
summary(lm(trails_b_z_score ~ sleep_time, data = d)) 

summary(lm(CC_AD ~ sleep_time*Group, data = d)) 
summary(lm(CC_AD ~ sleep_time, data = d)) 

summary(lm(CC_AD ~ total_ac.sleep*Group, data = d)) 
summary(lm(CC_AD ~ total_ac.sleep, data = d)) #
