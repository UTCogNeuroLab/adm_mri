library(tidyverse)
library(readr)
library(corrplot)
library(reshape2)

load('~/Box/CogNeuroLab/Aging Decision Making R01/Data/combined_data.RData')
dti <- readxl::read_xlsx('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/dwi/cr_fa_md.xlsx')
dti <- merge(dti, select(d, record_id, trails_b_z_score), by = "record_id")
d <- c()

d <- select(dti, -fa_mean_3_skel, -fa_mean_4_skel, -fa_mean_5_skel, -md_mean_3_skel, -md_mean_4_skel, -md_mean_5_skel)
d$Group <- factor(ifelse(d$record_id < 40000, 0, 1), label = c("Young Adults", "Older Adults"))
ya_data <- d[d$Group == "Young Adults", ]
oa_data <- d[d$Group == "Older Adults", ]

# histograms
d %>%
  select(Group, IS:RA, actamp:fact) %>%
  melt(id.vars = "Group") %>%
  ggplot() +
  geom_histogram(aes(x = value, fill = variable)) + 
  facet_wrap(variable ~ Group, scales = "free") +
  xlab("CR") + ylab("Count") 

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

d %>%
  select(Group, fa_mean_sca, md_mean_sca) %>%
  melt(id.vars = "Group") %>%
  ggplot() +
  geom_histogram(aes(x = value, fill = variable)) +
  scale_fill_discrete(name = "ROI", labels = c("FA", "MD")) +
  facet_wrap(Group ~ variable, scales = "free") +
  ylab("Count") 

# remove actbeta outlier
library(car)

summary(d$actbeta)
d$record_id[d$actbeta == max(d$actbeta)]
d[d$record_id == 40758,] <- NA

# correlation plots
alpha = 0.05

ya_mat <- cor(select(ya_data, -record_id, -files, -Group))
ya_res <- cor.mtest(ya_mat, conf.level = (1-alpha))
corrplot(ya_mat, p.mat = ya_res$p, sig.level = alpha, insig = "blank", type = "upper", addCoef.col = TRUE, number.cex = .6)

oa_mat <- cor(select(oa_data, -record_id, -files, -Group))
oa_res <- cor.mtest(oa_mat, conf.level = (1-alpha))
corrplot(oa_mat, p.mat = oa_res$p, sig.level = alpha, insig = "blank", type = "upper", addCoef.col = TRUE, number.cex = .6)

lm1 <- lm(md_mean_4 ~ age + actalpha, data = oa_data)
summary(lm1)
d %>%
  select(Group, md_mean_3, md_mean_4, md_mean_5, actalph) %>%
  melt(id.vars = c("Group", "actalph")) %>%
  ggplot(aes(color = Group, group = Group)) +
  geom_point(aes(x = actalph, y = value, group = Group, color = Group)) +
  stat_smooth(aes(x = actalph, y = value, group = Group, color= Group), method = "lm") + 
  scale_color_manual(values = c("blue", "red")) +
  facet_wrap(Group ~ variable, scales = "free_y") +
  xlab("Width (alpha)") + ylab("Mean Diffusivity") 

lm2 <- lm(md_mean_4 ~ age + actwidthratio, data = oa_data)
summary(lm2)
d %>%
  select(Group, md_mean_3, md_mean_4, md_mean_5, actwidthratio) %>%
  melt(id.vars = c("Group", "actwidthratio")) %>%
  ggplot(aes(color = Group, group = Group)) +
  geom_point(aes(x = actwidthratio, y = value, group = Group, color = Group)) +
  stat_smooth(aes(x = actwidthratio, y = value, group = Group, color= Group), method = "lm") + 
  scale_color_manual(values = c("blue", "red")) +
  facet_wrap(Group ~ variable, scales = "free_y") +
  xlab("Width-ratio") + ylab("Mean Diffusivity") 

lm3 <- lm(md_mean_4 ~ age + actbeta, data = oa_data)
summary(lm3)
d %>%
  na.omit() %>%
  select(Group, md_mean_3, md_mean_4, md_mean_5, actbeta) %>%
  melt(id.vars = c("Group", "actbeta")) %>%
  ggplot() +
  geom_point(aes(x = actbeta, y = value, group = Group, color = Group)) +
  stat_smooth(aes(x = actbeta, y = value, group = Group, color= Group), method = "lm") + 
  scale_color_manual(values = c("blue", "red")) +
  facet_wrap(Group ~ variable, scales = "free_y") +
  xlab("Slope (beta)") + ylab("Mean Diffusivity") 

stepdata <- select(oa_data, IS:RA, actalpha:fact, actquot, md_mean_4)
#step(md_mean_4 ~ ., data = stepdata, direction = "both")
