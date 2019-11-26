library(tidyverse)
library(readr)
library(corrplot)
library(reshape2)
library(ggcorplot)

d <- readxl::read_xlsx('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/dwi/cr_fa_md.xlsx')
d <- select(d, -fa_mean_3_skel, -fa_mean_4_skel, -fa_mean_5_skel)
d$Group <- factor(ifelse(d$record_id < 40000, 0, 1), label = c("Young Adults", "Older Adults"))
ya_data <- d[d$Group == "Young Adults", ]
oa_data <- d[d$Group == "Older Adults", ]

d %>%
  select(Group, md_mean_3, md_mean_4, md_mean_5) %>%
  melt(id.vars = "Group") %>%
  ggplot() +
  geom_histogram(aes(x = value, fill = variable)) +
  scale_fill_discrete(name = "ROI", labels = c("Genu", "Body", "Splenium")) +
  facet_wrap(Group ~ variable, scales = "free_y") +
  xlab("Mean Diffusivity") + ylab("Count") 

d %>%
  select(Group, fa_mean_3, fa_mean_4, fa_mean_5) %>%
  melt(id.vars = "Group") %>%
  ggplot() +
  geom_histogram(aes(x = value, fill = variable)) +
  scale_fill_discrete(name = "ROI", labels = c("Genu", "Body", "Splenium")) +
  facet_wrap(Group ~ variable, scales = "free_y") +
  xlab("Fractional Anisotropy") + ylab("Count") 

ya_mat <- cor(select(ya_data, -record_id, -files, -Group))
ya_res <- cor.mtest(ya_mat, conf.level = 0.95)
corrplot(ya_mat, p.mat = ya_res$p, sig.level = 0.05, insig = "blank", type = "upper", addCoef.col = TRUE, pch.cex = 2)

oa_mat <- cor(select(oa_data, -record_id, -files, -Group))
oa_res <- cor.mtest(oa_mat, conf.level = 0.95)
corrplot(oa_mat, p.mat = oa_res$p, sig.level = 0.05, insig = "blank", type = "upper", addCoef.col = TRUE)

#Beta Whether the activity rises more steeply or more gradually from minimum to maximum 	the bigger the more rapid the change from high to low activity, and from low to high activity 
#Width (alph) 	A parameter related to durations of relatively active time and relatively inactive time of day 	Smaller values indicated longer durations of high activity 
#Width Ratio (widthratio) 	The fraction of the day that activity is above the mesor 	Smaller values indicated longer durations of low activity 

