roi <- read_csv('/Users/megmcmahon/Box/CogNeuroLab/Aging Decision Making R01/data/fa_roi_sphere3.csv')
colnames(roi)

d <- merge(d, roi, by.x = "record_id", by.y = "X1", all = T)
write.csv(d, paste0(data_dir, "dataset_2020-10-10.csv"))

d %>%
  filter(actamp < 3) %>%
  select(record_id, Group, actamp, matches(" L| R"), Genu, Splenium, -matches("Cluster")) %>%
  pivot_longer(-c(record_id, Group, actamp), names_to = "ROI", values_to = "FA") -> d_long

d_long$ROI[d_long$ROI == "Long Fasciculus 1 R"] <- "Longitudinal Fasciculus R 1"
d_long$ROI[d_long$ROI == "Long Fasciculus 2 R"] <- "Longitudinal Fasciculus R 2"
d_long$ROI[d_long$ROI == "Long Fasciculus 1 L"] <- "Longitudinal Fasciculus L 1"
d_long$ROI[d_long$ROI == "Long Fasciculus 2 L"] <- "Longitudinal Fasciculus L 2"

d_long$ROI <- factor(d_long$ROI, levels = c("Frontal Forceps R", "Frontal Forceps L", "Posterior Forceps R", "Posterior Forceps L", "Longitudinal Fasciculus R 1", "Longitudinal Fasciculus L 1", "Longitudinal Fasciculus R 2", "Longitudinal Fasciculus L 2", "Posterior Thalamic Radiation R", "Posterior Thalamic Radiation L", "Genu", "Splenium"))

roiplot <- d_long %>%
  ggplot() + 
  geom_point(aes(x = actamp, y = FA, group = Group, color = Group, shape = Group)) + 
  geom_smooth(aes(x = actamp, y = FA, group = Group, color = Group), method = "lm") + 
  facet_wrap(. ~ ROI, scales = "free", nrow = 3) +
  theme_minimal() + xlab("Rhythm Amplitude") + ylab("Fractional Anisotropy") +
  scale_color_brewer(palette="Set1") + theme(text = element_text(size=20)) +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "bottom")
  ggsave(paste0(figs_dir, "amp_fa_sphere_rois_by_group_12.png"), dpi=400, height=10, width=15, units="in")

d$ptr_r <- d$`Posterior Thalamic Radiation R`
fitfa <- lm(ptr_r ~ actamp*Group, data = d)
summary(fitfa)
interact_plot(fitfa, pred = actamp, modx = Group, interval = TRUE, plot.points = TRUE) + 
  ylab('R Posterior Thalamic Radiation FA') +
  xlab('Amplitude') +
  ggsave('~/Box/CogNeuroLab/Aging Decision Making R01/results/rest-activity_and_white_matter_microstructure/Posterior Interaction Plot R.png', dpi = 400)

fitfa <- lm(ptr_l ~ actamp*Group, data = d)
summary(fitfa)
interact_plot(fitfa, pred = actamp, modx = Group, interval = TRUE, plot.points = TRUE) + 
  ylab('L Posterior Thalamic Radiation FA') +
  xlab('Amplitude') +
  ggsave('~/Box/CogNeuroLab/Aging Decision Making R01/results/rest-activity_and_white_matter_microstructure/Posterior Interaction Plot L.png', dpi = 400)
