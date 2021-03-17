# CC Volume
summary(lm(cc_vol ~ actamp*Group, data = d)) # NS
summary(lm(cc_vol ~ actamp + Group, data = d)) # Group only

## CC FA Model Selection
summary(lm(cc_fa ~ actamp*Group + cc_vol + total_ac_mean_active + efficiency_mean_sleep, data = d)) #NS
summary(lm(cc_fa ~ actamp*Group + cc_vol, data = d)) #NS
summary(lm(cc_fa ~ actamp*Group, data = d)) #NS

summary(lm(cc_fa ~ actamp + Group + cc_vol + total_ac_mean_active + efficiency_mean_sleep, data = d)) # total ac and sleep efficiency NS

## All Participants (Model 1.0)
summary(lm(cc_fa ~ actamp + Group + cc_vol, data = d)) ##
summary(lm(cc_fa ~ actamp*Group + cc_vol, data = d)) ##

summary(lm(genu_fa ~ actamp*Group + cc_vol, data = d)) #NS
summary(lm(ccbody_fa ~ actamp*Group + cc_vol, data = d)) #NS
summary(lm(splenium_fa ~ actamp*Group + cc_vol, data = d)) #NS

### Young Adults (Models 1.1, 1.2)
summary(lm(cc_fa ~ actamp + cc_vol + age, data = filter(d, Group == "Young Adults"))) # here age is significant, but CC vol is not
summary(lm(cc_fa ~ actamp + age, data = filter(d, Group == "Young Adults"))) #X

### Older Adults (Models 1.3, 1.4)
summary(lm(cc_fa ~ actamp + cc_vol + age, data = filter(d, Group == "Older Adults"))) # here age is not, but CC vol is
summary(lm(cc_fa ~ actamp + cc_vol, data = filter(d, Group == "Older Adults"))) 

## Run with and without age as a covariate, since age is important for within-YA analysis but not within-OA

### Model 1.0
lm1.0 <- lm(cc_fa ~ actamp + cc_vol + Group, data = d)
summary(lm1.0)
lm1.0.beta <- lm.beta(lm1.0)
print(lm1.0.beta)
summary(lm1.0.beta)
ShowRegTable(lm1.0.beta, exp= F)
cvdata <- d %>%
  select(cc_fa, actamp, Group, cc_vol) %>%
  drop_na()
beset::validate(lm1.0, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)

lmeff <- lm(cc_fa ~ efficiency_mean_sleep + Group + cc_vol, data = d)
summary(lmeff)
lmeff.beta <- lm.beta(lmeff)
print(lmeff.beta)
summary(lmeff.beta)
ShowRegTable(lmeff.beta, exp= F)
cvdata <- d %>%
  select(cc_fa, efficiency_mean_sleep, Group, cc_vol) %>%
  drop_na()
beset::validate(lmeff, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)

### Model 1.0.0 - R2 = 0.23592
lm1.0.0 <- lm(cc_fa ~ actamp + Group + cc_vol + total_ac_mean_active + efficiency_mean_sleep, data = d)
summary(lm1.0.0)
lm1.0.0.beta <- lm.beta(lm1.0.0)
print(lm1.0.0.beta)
summary(lm1.0.0.beta)
ShowRegTable(lm1.0.0.beta, exp= F)
cvdata <- d %>%
  select(cc_fa, actamp, Group, cc_vol) %>%
  drop_na()
beset::validate(lm1.0.0, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)

AIC(lm1.0) # 1.0 has lower AIC
AIC(lm1.0.0)

### Model 1.1 - R2 = .116
lm1.1 <- lm(cc_fa ~ actamp + cc_vol + age, filter(d, Group == "Young Adults"))
summary(lm1.1)
lm1.1.beta <- lm.beta(lm1.1)
print(lm1.1.beta)
summary(lm1.1.beta)
ShowRegTable(lm1.1.beta, exp= F)
cvdata <- d %>%
  filter(Group == "Young Adults") %>%
  select(cc_fa, actamp, age, cc_vol) %>%
  drop_na()
beset::validate(lm1.1, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)

### Model 1.2 R2 = .174
lm1.2 <- lm(cc_fa ~ actamp + age, filter(d, Group == "Young Adults"))
summary(lm1.2)
lm1.2.beta <- lm.beta(lm1.2)
print(lm1.2.beta)
summary(lm1.2.beta)
ShowRegTable(lm1.2.beta, exp= F)
cvdata <- d %>%
  filter(Group == "Young Adults") %>%
  select(cc_fa, actamp, age) %>%
  drop_na()
beset::validate(lm1.2, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)

### Model 1.1.0 - R2 = 0.03357
lm1.1.0 <- lm(cc_fa ~ actamp + age + cc_vol + total_ac_mean_active + efficiency_mean_sleep, data = filter(d, Group == "Young Adults"))
summary(lm1.1.0)
lm1.1.0.beta <- lm.beta(lm1.1.0)
print(lm1.1.0.beta)
summary(lm1.1.0.beta)
ShowRegTable(lm1.1.0.beta, exp= F)
cvdata <- d %>%
  filter(Group == "Young Adults") %>%
  select(cc_fa, actamp, age, cc_vol, total_ac_mean_active, efficiency_mean_sleep) %>%
  drop_na()
beset::validate(lm1.1.0, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)

lm1.1.0 <- lm(cc_fa ~ actamp + age + cc_vol + total_ac_mean_active, data = filter(d, Group == "Young Adults"))
summary(lm1.1.0)
lm1.1.0.beta <- lm.beta(lm1.1.0)
print(lm1.1.0.beta)
summary(lm1.1.0.beta)
ShowRegTable(lm1.1.0.beta, exp= F)
cvdata <- d %>%
  filter(Group == "Young Adults") %>%
  select(cc_fa, actamp, age, cc_vol, total_ac_mean_active) %>%
  drop_na()
beset::validate(lm1.1.0, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)

AIC(lm1.1) 
AIC(lm1.2) # 1.2 has lowest AIC
AIC(lm1.1.0) 

### Model 1.3 - R2 = 0.10591
lm1.3 <- lm(cc_fa ~ actamp + cc_vol + age, filter(d, Group == "Older Adults"))
summary(lm1.3)
lm1.3.beta <- lm.beta(lm1.3)
print(lm1.3.beta)
summary(lm1.3.beta)
ShowRegTable(lm1.3.beta, exp= F)
cvdata <- d %>%
  filter(Group == "Older Adults") %>%
  select(cc_fa, actamp, age, cc_vol) %>%
  drop_na()
beset::validate(lm1.3, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)

### Model 1.4 - R2 = 0.15128
lm1.4 <- lm(cc_fa ~ actamp + cc_vol, filter(d, Group == "Older Adults"))
summary(lm1.4)
lm1.4.beta <- lm.beta(lm1.4)
print(lm1.4.beta)
summary(lm1.4.beta)
ShowRegTable(lm1.4.beta, exp= F)
cvdata <- d %>%
  filter(Group == "Older Adults") %>%
  select(cc_fa, actamp, cc_vol) %>%
  drop_na()
beset::validate(lm1.4, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)

### Model 1.3.0 - R2 = 0.03573
lm1.3.0 <- lm(cc_fa ~ actamp + cc_vol + total_ac_mean_active + efficiency_mean_sleep, data = filter(d, Group == "Older Adults"))
summary(lm1.3.0)
lm1.3.0.beta <- lm.beta(lm1.3.0)
print(lm1.3.0.beta)
summary(lm1.3.0.beta)
ShowRegTable(lm1.3.0.beta, exp= F)
cvdata <- d %>%
  filter(Group == "Older Adults") %>%
  select(cc_fa, actamp, age, cc_vol, total_ac_mean_active, efficiency_mean_sleep) %>%
  drop_na()
beset::validate(lm1.3.0, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)

AIC(lm1.3) 
AIC(lm1.4) # 1.4 has lowest AIC
AIC(lm1.3.0) 

## Sex effects?
t.test(d$cc_fa ~ d$sex) #NS
t.test(d$actamp ~ d$sex) #NS

## corona radiata
summary(lm(coronaradiata_fa ~ actamp + Group + total_ac_mean_active + sleep_time_mean_sleep, data = d)) 
summary(lm(coronaradiata_fa ~ actamp + Group, data = d))

# CC Mean Diffusivity
#md <- read_csv("~/Box/CogNeuroLab/Aging Decision Making R01/data/md_roi_values.csv")

## Interaction R2 = 0.44 ??
lm2.0 <- lm(cc_md ~ Group*IV + cc_vol, data = d)
summary(lm2.0)
lm2.0.beta <- lm.beta(lm2.0)
print(lm2.0.beta)
summary(lm2.0.beta)
ShowRegTable(lm2.0.beta, exp= F)
cvdata <- d %>%
  select(cc_md, IV, Group, cc_vol) %>%
  drop_na()
beset::validate(lm2.0, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)


summary(lm(corona_radiata_md ~ Group*IV, data = d)) #NS
summary(lm(corona_radiata_md ~ Group + IV, data = d)) # IV NS

lm1.0.int <- lm(cc_fa ~ actamp*Group + cc_vol, data = d)
summary(lm1.0.int)
lm1.0.int.beta <- lm.beta(lm1.0.int)
print(lm1.0.int.beta)
summary(lm1.0.int.beta)
ShowRegTable(lm1.0.int.beta, exp= F)
cvdata <- d %>%
  select(cc_fa, actamp, Group, cc_vol) %>%
  drop_na()
beset::validate(lm1.0.int, data = cvdata, n_folds = sum(complete.cases(cvdata))-1)

### STOPPED HERE

p.legend <- d %>%
  ggplot() + 
  geom_point(aes(x = IV, y = cc_md, group = Group, color = Group, shape = Group), size = 2) + 
  stat_smooth(aes(x = IV, y = cc_md, group = Group, color = Group), method = "lm") + 
  theme_classic() + xlab("Intradaily Variability") + ylab("MD") +
  scale_color_brewer(palette="Set1") + theme(legend.position = "right")

p1.a <- d %>%
  filter(actamp < 3) %>%
  ggplot() + 
  geom_point(aes(x = actamp, y = cc_fa, group = Group, color = Group, shape = Group), size = 2) + 
  stat_smooth(aes(x = actamp, y = cc_fa, group = Group, color = Group), method = "lm") + 
  theme_classic() + xlab("Amplitude") + ylab("CC FA") +
  scale_color_brewer(palette="Set1") + theme(legend.position = "none") + ggtitle("(A)")

# p1.b <- d %>%
#   filter(actamp < 3) %>%
#   ggplot() + 
#   geom_point(aes(x = actamp, y = cc_md, group = Group, color = Group, shape = Group), size = 2) + 
#   stat_smooth(aes(x = actamp, y = cc_md, group = Group, color = Group), method = "lm") + 
#   theme_classic() + xlab("Amplitude") + ylab("MD") +
#   scale_color_brewer(palette="Set1") + theme(legend.position = "none")  + ggtitle("(B)")

p1.c <- d %>%
  filter(actamp < 3) %>%
  ggplot() + 
  geom_point(aes(x = actamp, y = cc_vol, group = Group, color = Group, shape = Group), size = 2) + 
  stat_smooth(aes(x = actamp, y = cc_vol, group = Group, color = Group), method = "lm") + 
  theme_classic() + xlab("Amplitude") + ylab("CC Volume") +
  scale_color_brewer(palette="Set1") + theme(legend.position = "none") +  ggtitle("(B)")

p1.d <- d %>%
  ggplot() + 
  geom_point(aes(x = cc_vol, y = cc_fa, group = Group, color = Group, shape = Group), size = 2) + 
  stat_smooth(aes(x = cc_vol, y = cc_fa, group = Group, color = Group), method = "lm") + 
  theme_classic() + xlab("CC Volume") + ylab("CC FA") +
  scale_color_brewer(palette="Set1") + theme(legend.position = "right") + ggtitle("(C)")

library(cowplot)
# legend <- cowplot::get_legend(p.legend)
# #empty <- plot(0,type='n',axes=FALSE,ann=FALSE)

fig4 <- grid.arrange(p1.a, p1.c, p1.d, nrow = 1, widths = c(3.5, 3.5, 4.75))
ggsave(paste0(figs_dir, "figure4-11-new.png"), fig4, dpi=300, height=5, width=12, units="in")


# Supplement Figure 

p2.c <- d %>%
  ggplot() + 
  geom_point(aes(x = IV, y = cc_fa, group = Group, color = Group, shape = Group), size = 2) + 
  stat_smooth(aes(x = IV, y = cc_fa, group = Group, color = Group), method = "lm") + 
  theme_classic() + xlab("Intradaily Variability") + ylab("FA") +
  scale_color_brewer(palette="Set1") + theme(legend.position = "none") + ggtitle("(C)")

p1.e <- d %>%
  ggplot() + 
  geom_point(aes(x = IV, y = cc_md, group = Group, color = Group, shape = Group), size = 2) + 
  stat_smooth(aes(x = IV, y = cc_md, group = Group, color = Group), method = "lm") + 
  theme_classic() + xlab("Intradaily Variability") + ylab("MD") +
  scale_color_brewer(palette="Set1") + theme(legend.position = "none") + ggtitle("(E)")

p2.d <- d %>%
  ggplot() + 
  geom_point(aes(x = IV, y = cc_md, group = Group, color = Group, shape = Group), size = 2) + 
  stat_smooth(aes(x = IV, y = cc_md, group = Group, color = Group), method = "lm") + 
  theme_classic() + xlab("Intradaily Variability") + ylab("MD") +
  scale_color_brewer(palette="Set1") + theme(legend.position = "none") + ggtitle("(D)")

p1.f <- d %>%
  ggplot() + 
  geom_point(aes(x = IV, y = cc_vol, group = Group, color = Group, shape = Group), size = 2) + 
  stat_smooth(aes(x = IV, y = cc_vol, group = Group, color = Group), method = "lm") + 
  theme_classic() + xlab("Intradaily Variability") + ylab("Volume") +
  scale_color_brewer(palette="Set1") + theme(legend.position = "none") + ggtitle("(F)")



fig4.2 <- grid.arrange(p1.a, p1.b, p1.c, p1.d, p1.e, p1.f, legend, nrow = 3, heights = c(2, 2, 0.75), layout_matrix=rbind(c(1,2), c(3,4), 6))
ggsave(paste0(figs_dir, "figure4-22.png"), fig4.2, dpi=300, height=10, width=12, units="in")

# young adults
lm1 <- lm(cc_md ~ age + cc_vol + IV, ya)
summary(lm1)
lm1.beta <- lm.beta(lm1)
print(lm1.beta)
summary(lm1.beta)
ShowRegTable(lm1.beta, exp= F)
cvdata <- d %>%
  filter(Group == "Young Adults") %>%
  select(age, cc_md, cc_vol, IV) %>%
  drop_na()
beset::validate(lm1, data = cvdata, n_folds = sum(complete.cases(cvdata))-1) #var exp = 0.009

# older adults - NS
lm1 <- lm(cc_md ~ age + cc_vol + IV, oa)
summary(lm1)
lm1.beta <- lm.beta(lm1)
print(lm1.beta)
summary(lm1.beta)
ShowRegTable(lm1.beta, exp= F)
cvdata <- d %>%
  filter(Group == "Young Adults") %>%
  select(age, cc_md, cc_vol, IV) %>%
  drop_na()
beset::validate(lm1, data = cvdata, n_folds = sum(complete.cases(cvdata))-1) 

lm1 <- lm(corona_radiata_md ~ age + cc_vol + IV, ya)
summary(lm1)
cvdata <- d %>%
  filter(Group == "Young Adults") %>%
  select(age, IV, corona_radiata_md) %>%
  drop_na()
beset::validate(lm1, data = cvdata, n_folds = 39) #var exp = 0.009

lm1 <- lm(cc_md ~ exercise_prop + sleep_time_mean_sleep + age + cc_vol + IV, ya)
summary(lm1)
lm1.beta <- lm.beta(lm1)
print(lm1.beta)
summary(lm1.beta)
ShowRegTable(lm1.beta, exp= F)
cvdata <- d %>%
  filter(Group == "Young Adults") %>%
  select(sleep_time_mean_sleep, age, cc_vol, IV, exercise_prop) %>%
  drop_na()
beset::validate(lm1, data = cvdata, n_folds = sum(complete.cases(cvdata))-1) #0.056 R

lm1 <- lm(cc_md ~ Group*IV + sleep_time_mean_sleep + exercise_prop + age + cc_vol, d)
summary(lm1)
lm1.beta <- lm.beta(lm1)
print(lm1.beta)
summary(lm1.beta)
ShowRegTable(lm1.beta, exp= F)
cvdata <- d %>%
  select(sleep_time_mean_sleep, age, cc_vol, IV, exercise_prop) %>%
  drop_na()
beset::validate(lm1, data = cvdata, n_folds = sum(complete.cases(cvdata))-1) #0.056 R

# create dummy variable
d$GroupI <- ifelse(d$Group == "Older Adults", 1, 0)

# significant age group interaction effect for cc md, IV
lm1 <- lm(formula = cc_md ~ Group*IV + cc_vol + age + exercise_prop + sleep_time_mean_sleep, data = d)
summary(lm1)
lm1.beta <- lm.beta(lm1)
print(lm1.beta)
summary(lm1.beta)
ShowRegTable(lm1.beta, exp= F)
cvdata <- d %>%
  select(cc_md, GroupI, age, cc_vol, IV, sleep_time_mean_sleep, exercise_prop) %>%
  drop_na()
beset::validate(lm1.beta, data = cvdata, n_folds = sum(complete.cases(cvdata))-1) 

lm1 <- lm(formula = cc_md ~ Group*IV + cc_vol + age, data = d)
summary(lm1)
lm1.beta <- lm.beta(lm1)
print(lm1.beta)
summary(lm1.beta)
ShowRegTable(lm1.beta, exp= F)
cvdata <- d %>%
  select(cc_md, GroupI, age, cc_vol, IV) %>%
  drop_na()
beset::validate(lm1.beta, data = cvdata, n_folds = sum(complete.cases(cvdata))-1) 

# no significant age group interaction effect for cc fa, amplitude
lm2 <- lm(formula = cc_fa ~ Group*actamp + cc_vol + age, data = d)
summary(lm2)
lm2.beta <- lm.beta(lm2)
print(lm2.beta)
summary(lm2.beta)
ShowRegTable(lm2.beta, exp= F)
cvdata <- d %>%
  select(cc_fa, GroupI, age, cc_vol, actamp) %>%
  drop_na()
beset::validate(lm2.beta, data = cvdata, n_folds = sum(complete.cases(cvdata))-1) 