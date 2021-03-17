# PVT results contain mean and sd reaction times (rt_mean, rt_sd), number of false starts (fs), number of response lapses (rl)
pvt <- read_csv("~/Box/CogNeuroLab/Aging Decision Making R01/data/pvt/pvt_stats_2020-06-19.csv")
head(pvt)

d <- merge(d, pvt, by = "record_id", all = T)
d <- d %>%
  drop_na(cc_fa) 

pvtcor <- d %>%
  select(rt_mean, vc_zscore, ds_zscore, matches("trails*.*z_score")) 
cor_boot(pvtcor, use = "complete.obs", n_rep = 1000)

pvtcor <- d %>%
  filter(Group == "Young Adults") %>%
  select(rt_mean, vc_zscore, ds_zscore, matches("trails*.*z_score")) 
cor_boot(pvtcor, use = "complete.obs", n_rep = 1000)

pvtcor <- d %>%
  filter(Group == "Older Adults") %>%
  select(rt_mean, cvlt_zscore, cowat_zscore, vc_zscore, ds_zscore, matches("trails*.*z_score"))
cor_boot(pvtcor, use = "complete.obs", n_rep = 1000)

# PVT and sleep, RAR correlations

pvtcor <- d %>%
  select(rt_mean, fs, actamp, fact, IS, IV, RA, global_psqi, sleep_time_mean_sleep, total_ac_mean_active, efficiency_mean_sleep)
write.csv(cor_boot(pvtcor, use = "complete.obs", n_rep = 1000), "~/Box/CogNeuroLab/Aging Decision Making R01/results/rest-activity_and_white_matter_microstructure/pvt_rar_sleep_correlations.csv")

pvtcoryoung <- d %>%
  filter(Group == "Young Adults") %>%
  select(rt_mean, fs, actamp, fact, IS, IV, RA, global_psqi, sleep_time_mean_sleep, total_ac_mean_active, efficiency_mean_sleep)
write.csv(cor_boot(pvtcoryoung, use = "complete.obs", n_rep = 1000), "~/Box/CogNeuroLab/Aging Decision Making R01/results/rest-activity_and_white_matter_microstructure/pvt_rar_sleep_correlations_ya.csv")

pvtcorolder <- d %>%
  filter(Group == "Older Adults") %>%
  select(rt_mean, fs, actamp, fact, IS, IV, RA, global_psqi, sleep_time_mean_sleep, total_ac_mean_active, efficiency_mean_sleep)
write.csv(cor_boot(pvtcorolder, use = "complete.obs", n_rep = 1000), "~/Box/CogNeuroLab/Aging Decision Making R01/results/rest-activity_and_white_matter_microstructure/pvt_rar_sleep_correlations_oa.csv")

pvtcoryoung <- d %>%
  filter(Group == "Young Adults") %>%
  select(rt_mean, fs, IV, cc_fa, coronaradiata_fa, cc_md, corona_radiata_md, cc_vol)
cor_boot(pvtcoryoung, use = "complete.obs", n_rep = 1000)
write.csv(cor_boot(pvtcoryoung, use = "complete.obs", n_rep = 1000), "~/Box/CogNeuroLab/Aging Decision Making R01/results/rest-activity_and_white_matter_microstructure/pvt_IV_MD_ya.csv")

d %>%
  filter(rt_mean < 500) %>%
  ggplot() + 
  geom_point(aes(x = IV, y = rt_mean, group = Group, color = Group, shape = Group)) + 
  stat_smooth(aes(x = IV, y = rt_mean, group = Group, color = Group), method = "lm") +
  theme_classic() + xlab("Intradaily Variability") + ylab("PVT Mean RT") +
  scale_color_brewer(palette="Set1") + scale_fill_brewer(palette="Set1") +
  #facet_wrap(.~Group) 
  ggsave(paste0(figs_dir, "IV_PVT-RT.png"), dpi=300, height=4, width=8, units="in")

summary(lm(rt_mean ~ IV*Group, data = d))
summary(lm(rt_mean ~ IV + Group, data = d))
cor.test(d$rt_mean[d$Group == "Young Adults"], d$IV[d$Group == "Young Adults"])

d %>%
  filter(rt_mean < 500) %>%
  ggplot() + 
  geom_point(aes(x = cc_fa, y = rt_mean, group = Group, color = Group, shape = Group)) + 
  stat_smooth(aes(x = cc_fa, y = rt_mean, group = Group, color = Group), method = "lm") +
  theme_classic() + xlab("Corpus Callosum FA") + ylab("PVT Mean RT") +
  scale_color_brewer(palette="Set1") + scale_fill_brewer(palette="Set1") +
  ggsave(paste0(figs_dir, "CCFA_PVT-RT.png"), dpi=300, height=4, width=8, units="in")

d %>%
  filter(rt_mean < 500) %>%
  ggplot() + 
  geom_point(aes(x = cc_md, y = rt_mean, group = Group, color = Group, shape = Group)) + 
  stat_smooth(aes(x = cc_md, y = rt_mean, group = Group, color = Group), method = "lm") +
  theme_classic() + xlab("Corpus Callosum MD") + ylab("PVT Mean RT") +
  scale_color_brewer(palette="Set1") + scale_fill_brewer(palette="Set1") +
  ggsave(paste0(figs_dir, "CCMD_PVT-RT.png"), dpi=300, height=4, width=8, units="in")

d %>%
  filter(rt_mean < 500) %>%
  ggplot() + 
  geom_point(aes(x = corona_radiata_md, y = rt_mean, group = Group, color = Group, shape = Group)) + 
  stat_smooth(aes(x = corona_radiata_md, y = rt_mean, group = Group, color = Group), method = "lm") +
  theme_classic() + xlab("Corona Radiata MD") + ylab("PVT Mean RT") +
  scale_color_brewer(palette="Set1") + scale_fill_brewer(palette="Set1") +
  ggsave(paste0(figs_dir, "CRMD_PVT-RT.png"), dpi=300, height=4, width=8, units="in")

summary(lm(rt_mean ~ corona_radiata_md*Group, data = d))
summary(lm(rt_mean ~ corona_radiata_md, data = filter(d, Group == "Young Adults")))
summary(lm(rt_mean ~ cc_md*Group, data = d))
summary(lm(rt_mean ~ cc_md, data = filter(d, Group == "Young Adults")))

cor.test(d$rt_mean[d$Group == "Young Adults"], d$corona_radiata_md[d$Group == "Young Adults"])
cor.test(d$rt_mean[d$Group == "Young Adults"], d$cc_md[d$Group == "Young Adults"])

pvtcoryoung <- d %>%
  filter(Group == "Young Adults") %>%
  select(cc_vol, actamp, fact, IS, IV, RA, global_psqi, sleep_time_mean_sleep, total_ac_mean_active, efficiency_mean_sleep)
cor_boot(pvtcoryoung, use = "complete.obs", n_rep = 1000)
write.csv(cor_boot(pvtcoryoung, use = "complete.obs", n_rep = 1000), "~/Box/CogNeuroLab/Aging Decision Making R01/results/rest-activity_and_white_matter_microstructure/pvt_rar_sleep_correlations_ya.csv")