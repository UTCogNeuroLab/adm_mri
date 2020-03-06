library(readr)
library(tidyverse)


d <- read_csv('/Users/PSYC-mcm5324/Box/CogNeuroLab/Aging Decision Making R01/Data/data_03_2020.csv')
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

pal = c('e377c2', '17becf')

d %>%
  filter(trails_b_z_score > -3) %>%
  ggplot() + 
  geom_point(aes(x = CC_AD, y = trails_b_z_score, group = Group, color = Group)) + 
  stat_smooth(aes(x = CC_AD, y = trails_b_z_score, group = Group, color = Group), method = 'lm') + 
  theme_classic() + xlab('CC AD') + ylab('TMT-B Z-score') +
  scale_color_brewer(palette="Set1") + 
  ggsave("~/Desktop/ccad_tmt.png", dpi=300, height=4, width=5, units="in")

d %>%
  filter(trails_b_z_score > -3) %>%
  ggplot() + 
  geom_point(aes(x = IV, y = CC_AD, group = Group, color = Group)) + 
  stat_smooth(aes(x = IV, y = CC_AD, group = Group, color = Group), method = 'lm') + 
  theme_classic() + xlab('IV') + ylab('CC AD') +
  scale_color_brewer(palette="Set1") + ggtitle('Intradaily Variability') + 
  ggsave("~/Desktop/IV_ccad.png", dpi=300, height=4, width=5, units="in")

d %>%
  filter(trails_b_z_score > -3) %>%
  filter(IS > 0.1) %>%
  ggplot() + 
  geom_point(aes(x = IS, y = CC_AD, group = Group, color = Group)) + 
  stat_smooth(aes(x = IS, y = CC_AD, group = Group, color = Group), method = 'lm') + 
  theme_classic() + xlab('IS') + ylab('CC AD') + ggtitle('Interdaily Stability') + 
  scale_color_brewer(palette="Set1") + 
  ggsave("~/Desktop/IS_ccad.png", dpi=300, height=4, width=5, units="in")

d %>%
  filter(trails_b_z_score > -3) %>%
  ggplot() + 
  geom_point(aes(x = IS, y = trails_b_z_score, group = Group, color = Group)) + 
  stat_smooth(aes(x = IS, y = trails_b_z_score, group = Group, color = Group), method = 'lm') + 
  theme_classic() + xlab('IS') + ylab('TMT-B Z-score') + ggtitle('Interdaily Stability') + 
  scale_color_brewer(palette="Set1") + 
  ggsave("~/Desktop/IS_TMT.png", dpi=300, height=4, width=5, units="in")

summary(lm(trails_b_z_score ~ sleep_time, data = d[d$Group == 'Older Adults',]))
summary(lm(trails_b_z_score ~ CC_AD, data = d[d$Group == 'Older Adults',]))


summary(lm(CC_FA ~ IS, data = d[d$Group == 'Older Adults',]))
summary(lm(CC_MD ~ IS, data = d[d$Group == 'Older Adults',]))
summary(lm(CC_AD ~ IS, data = d[d$Group == 'Older Adults',]))
summary(lm(CC_RD ~ IS, data = d[d$Group == 'Older Adults',]))

summary(lm(CC_FA ~ IV, data = d[d$Group == 'Older Adults',]))
summary(lm(CC_MD ~ IV, data = d[d$Group == 'Older Adults',]))
summary(lm(CC_AD ~ IV, data = d[d$Group == 'Older Adults',])) #
summary(lm(CC_RD ~ IV, data = d[d$Group == 'Older Adults',]))

summary(lm(CC_FA ~ RA, data = d[d$Group == 'Older Adults',]))
summary(lm(CC_MD ~ RA, data = d[d$Group == 'Older Adults',]))
summary(lm(CC_AD ~ RA, data = d[d$Group == 'Older Adults',]))
summary(lm(CC_RD ~ RA, data = d[d$Group == 'Older Adults',]))

#No significant sex differences in CC microstructure in older adults
d$sex <- factor(d$sex)
t.test(CC_FA ~ sex, data = d[d$Group == 'Older Adults',])
t.test(CC_MD ~ sex, data = d[d$Group == 'Older Adults',])
t.test(CC_AD ~ sex, data = d[d$Group == 'Older Adults',])
t.test(CC_RD ~ sex, data = d[d$Group == 'Older Adults',])

#Genu
summary(lm(genu_FA ~ Group*actupmesor, data = d)) #
summary(lm(genu_FA ~ Group*fact, data = d))
summary(lm(genu_FA ~ Group*RA, data = d))
summary(lm(genu_FA ~ Group*IS, data = d))
summary(lm(genu_FA ~ Group*IV, data = d))

d %>%
  ggplot() + 
  geom_point(aes(x = actupmesor, y = genu_FA, group = Group, color = Group)) + 
  stat_smooth(aes(x = actupmesor, y = genu_FA, group = Group, color = Group), method = 'lm') + 
  theme_classic() + xlab('Up-Mesor') + ylab('genu FA') + ggtitle('') + 
  scale_color_brewer(palette="Set1") 

d %>%
  filter(Group == "Young Adults") %>%
  ggplot() + 
  geom_point(aes(x = actupmesor, y = genu_FA, group = Group, color = Group)) + 
  stat_smooth(aes(x = actupmesor, y = genu_FA, group = Group, color = Group), method = 'lm') + 
  theme_classic() + xlab('Up-Mesor') + ylab('genu FA') + ggtitle('') + 
  scale_color_brewer(palette="Set1") 

library("PerformanceAnalytics")

# CC microstructure and cognition
my_data <- dplyr::select(d, age, years_educ, matches("CC_"), matches("z_score|zscore"))
str(my_data)
chart.Correlation(my_data, histogram=TRUE, pch=19)

d %>%
  filter(Group == 'Older Adults') %>%
  dplyr::select(age, years_educ, matches("CC_"), matches("z_score|zscore")) -> my_data
chart.Correlation(my_data, histogram=TRUE, pch=19)

d %>%
  filter(Group == 'Young Adults') %>%
  dplyr::select(age, years_educ, matches("CC_"), vc_zscore, trails_b_z_score, ds_zscore) -> my_data
str(my_data)
chart.Correlation(my_data, histogram=TRUE, pch=19)

## CR and cognition
d %>%
  filter(Group == 'Older Adults') %>%
  dplyr::select(age, years_educ, IS:RA, actamp:fact, matches("z_score|zscore")) -> my_data
chart.Correlation(my_data, histogram=TRUE, pch=19)

