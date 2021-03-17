## Cognition and Rhythm Amplitude
npall <- d %>%
  select(actamp, vc_zscore, ds_zscore, matches("trails*.*z_score"), rt_mean, fs, rl) 
ampcogall <- cor_boot(npall, use = "complete.obs", n_rep = 1000)

npall <- d %>%
  select(IV, vc_zscore, ds_zscore, matches("trails*.*z_score")) 
cor_boot(npall, use = "complete.obs", n_rep = 1000)

####
npyoung <- d %>%
  filter(Group == "Young Adults") %>%
  select(actamp, vc_zscore, ds_zscore, matches("trails*.*z_score")) 
ampcogya <- cor_boot(npyoung, use = "complete.obs", n_rep = 1000)

npyoung <- d %>%
  filter(Group == "Young Adults") %>%
  select(IV, vc_zscore, ds_zscore, matches("trails*.*z_score")) 
cor_boot(npyoung, use = "complete.obs", n_rep = 1000)

###
npolder <- d %>%
  filter(Group == "Older Adults") %>%
  select(actamp, cvlt_zscore, cowat_zscore, vc_zscore, ds_zscore, matches("trails*.*z_score"))
ampcogoa <- cor_boot(npolder, use = "complete.obs", n_rep = 1000)

cor.test(npolder$actamp, npolder$trails_b_z_score, use = "complete.obs")

npolder <- d %>%
  filter(Group == "Older Adults") %>%
  select(IV, cvlt_zscore, cowat_zscore, vc_zscore, ds_zscore, matches("trails*.*z_score"))
cor_boot(npolder, use = "complete.obs", n_rep = 1000)

plot.amptmtb <- d %>%
  filter(actamp < 3) %>%
  ggplot() + 
  geom_point(aes(x = actamp, y = trails_b_z_score, group = Group, color = Group)) + 
  theme_classic() + xlab("Amplitude") + ylab("Trails B Z-Score") +
  scale_color_brewer(palette="Set1") + scale_fill_brewer(palette="Set1") +
  facet_wrap(.~Group, scales = "fixed") +
  ggsave(paste0(figs_dir, "amp_tmtbz.png"), dpi=300, height=4, width=8, units="in")

## Cognition and CC Volume

npall <- d %>%
  select(cc_vol, vc_zscore, ds_zscore, matches("trails*.*z_score")) 
cor_boot(npall, use = "complete.obs", n_rep = 1000)

####
npyoung <- d %>%
  filter(Group == "Young Adults") %>%
  select(cc_vol, vc_zscore, ds_zscore, matches("trails*.*z_score")) 
cor_boot(npyoung, use = "complete.obs", n_rep = 1000)

###
npolder <- d %>%
  filter(Group == "Older Adults") %>%
  select(cc_vol, cvlt_zscore, cowat_zscore, vc_zscore, ds_zscore, matches("trails*.*z_score"))
cor_boot(npolder, use = "complete.obs", n_rep = 1000)

## Trails B and non-parametric rest-activity measures
mod1 <- beset_lm(time_trails_b ~ ., data = select(d, IS, IV, RA, time_trails_b), n_folds = sum(complete.cases(select(d, IS, IV, RA, cc_fa)))-1)
summary(mod1, oneSE = F)


mod1 <- beset_lm(time_trails_b ~ ., data = select(d, actamp:fact, -rsqact, time_trails_b, age, sex, years_educ, Group), n_folds = sum(complete.cases(select(d, actamp:fact, time_trails_b)))-1)
summary(mod1, oneSE = F)

lm1 <- lm(time_trails_b ~ actamp + age + Group, d)
summary(lm1)
plot(lm1)

d %>%
  filter(actamp < 3) %>%
  ggplot() + 
  geom_point(aes(x = actamp, y = time_trails_b, group = Group, color = Group)) + 
  stat_smooth(aes(x = actamp, y = time_trails_b, color = NA), color = 'black', method = "lm") +
  theme_classic() + xlab("Amplitude") + ylab("Time Trails B (s)") +
  scale_color_brewer(palette="Set1") + scale_fill_brewer(palette="Set1") +
  ggsave(paste0(figs_dir, "amp_tmtb.png"), dpi=300, height=4, width=8, units="in")

d$TMT <- factor(ifelse(d$trails_b_z_score < 0, -1, 1), labels = c("Low", "High"))
d$CVLT <- factor(ifelse(d$cvlt_zscore < 0, -1, 1), labels = c("Low", "High"))
d$DS <- factor(ifelse(d$ds_zscore < 0, -1, 1), labels = c("Low", "High"))
d$VC <- factor(ifelse(d$vc_zscore < 0, -1, 1), labels = c("Low", "High"))

d %>%
  drop_na(Group, TMT) %>%
  ggplot() + 
  geom_point(aes(x = TMT, y = actamp, group = Group, color = Group)) + 
  theme_classic() + xlab("Trails B") + ylab("Amplitude") + 
  facet_wrap(. ~ Group, scales = "free") + scale_color_brewer(palette="Set1") + ylim(0, 4) +
  ggsave(paste0(figs_dir, "amp_tmtb_bar.png"), dpi=300, height=4, width=8, units="in")

t.test(actamp ~ TMT, filter(d, Group == "Young Adults")) # NS
t.test(actamp ~ TMT, filter(d, Group == "Older Adults")) # p = 0.04
t.test(actamp ~ TMT, filter(d, Group == "Older Adults" & actamp < 3)) # p = 0.08

t.test(cc_fa ~ TMT, filter(d, Group == "Young Adults")) # NS
t.test(genu_fa ~ TMT, filter(d, Group == "Older Adults")) # p = 0.04

t.test(actamp ~ CVLT, filter(d, Group == "Older Adults")) # NS

t.test(actamp ~ DS, filter(d, Group == "Young Adults")) # NS
t.test(actamp ~ DS, filter(d, Group == "Older Adults")) # NS

df <- select(d, time_trails_b, actamp, matches("_fa"), Group, age, years_educ)
df <- df[complete.cases(df),]

mod <- beset_lm(time_trails_b ~ ., data = df, n_folds = sum(complete.cases(df))-1)
summary(mod, oneSE = F)
tmtlm <- lm(time_trails_b ~ Group + age + actamp, data = d)
summary(tmtlm)

d %>%
  filter(actamp < 3) %>%
  filter(time_trails_b < 150) %>%
  ggplot() + 
  geom_point(aes(x = actamp, y = time_trails_b, group = Group, color = Group)) + 
  stat_smooth(aes(x = actamp, y = time_trails_b, group = Group, color = Group), method = "lm") + 
  theme_classic() + xlab("Amplitude") + ylab("TMT-B (seconds)") +
  scale_color_brewer(palette="Set1") + theme(text = element_text(size=20)) +
  labs(caption = paste0("y = 44.180 -15.977 amp -64.145 Group + 1.741 age, R2 = ", round(summary(tmtlm)$r.squared, 2), "\n F(3,78) = ", round(summary(tmtlm)$fstatistic[[1]], 2), " \n Amplitude p = 0.071")) +
  ggsave(paste0(figs_dir, "amp_tmtb.png"), dpi=300, height=4, width=5, units="in")

d %>%
  group_by(Group) %>%
  summarize(ccfa_med = median(cc_fa, na.rm = T))

d %>%
  filter(actamp < 3) %>%
  filter(time_trails_b < 150) %>%
  ggplot() + 
  geom_point(aes(x = cc_fa, y = time_trails_b, group = Group, color = Group)) + 
  stat_smooth(aes(x = cc_fa, y = time_trails_b, group = Group, color = Group), method = "lm") + 
  theme_classic() + xlab("CC FA") + ylab("TMT-B (seconds)") +
  scale_color_brewer(palette="Set1") + theme(text = element_text(size=20))