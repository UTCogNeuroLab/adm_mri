## Demographics
d %>%
  drop_na(cc_fa) %>%
  group_by(Group) %>%
  summarize(n = n(), age_x = mean(age, na.rm = T), age_sd = sd(age, na.rm = T))

tab1 <- CreateTableOne(vars = c("age", "years_educ", "sex"), data = d, factorVars = c("sex"), strata = "Group")
tab1Mat <- print(tab1, quote = FALSE, noSpaces = TRUE, printToggle = FALSE)
## Save to a CSV file
write.csv(tab1Mat, file = paste0(results_dir, "table1.csv"))

## Health Characteristics
d %>%
  drop_na(cc_fa) %>%
  group_by(Group) %>%
  summarize(heart = length(which(heart == 1))/n(), 
            vascular_disease = length(which(vascular_disease == "Positive"))/n(), 
            diabetes = length(which(diabetes == "Positive"))/n(), 
            cancer = length(which(cancer == "Positive"))/n(), 
            head_injury = length(which(head_inj == "Positive"))/n(), 
            neuro = length(which(neurologicaldisorders == "Positive"))/n(), 
            stroke = length(which(stroke == "Positive"))/n(), 
            psychiatric = length(which(psychiatric_do == "Positive"))/n(), 
            sleep = length(which(sleep_do == "Positive"))/n())



listVars = c("age", "sex", "years_educ", "vascular_disease", "diabetes", "cancer", "head_inj", 
             "neurologicaldisorders", "stroke", "psychiatric_do", "sleep_do")

catVars = c("sex", "vascular_disease", "diabetes", "stroke", "cancer", "head_inj", 
            "neurologicaldisorders", "psychiatric_do", "sleep_do")

tab2 <- CreateTableOne(listVars, data = d, factorVars = catVars, strata = c("Group"))
tab2Mat <- print(tab2, quote = FALSE, noSpaces = TRUE, printToggle = FALSE)
write.csv(tab2Mat, file = paste0(results_dir, "table2.csv"))

## Sleep and Rest-Activity Rhythm Characteristics
listVars = c("sleep_time_mean_sleep", "efficiency_mean_sleep", "onset_latency_mean_sleep", "total_ac_mean_active", "actamp", "actalph", "actbeta", "actmesor", "actphi", "actupmesor", "actdownmesor", "actmin", "fact", "IS", "IV", "RA", "L5", "M10")
tab3 <- CreateTableOne(listVars, data = d, strata = c("Group"), test = T, addOverall = T)
tab3Mat <- print(tab3, quote = T, noSpaces = TRUE, printToggle = FALSE, minMax = FALSE)
write.csv(tab3Mat, file = paste0(results_dir, "table3.csv"))

## Microstructure Characteristics
listVars = c("global_fa", "cc_fa", "genu_fa", "ccbody_fa", "splenium_fa", "coronaradiata_fa", "suplongfasciculus_fa", 
             "externalcapsule_fa", "postthalamicradiation_fa")
tab4 <- CreateTableOne(listVars, data = d, strata = c("Group"))
tab4Mat <- print(tab4, quote = FALSE, noSpaces = TRUE, printToggle = FALSE)
write.csv(tab4Mat, file = paste0(results_dir, "table4.csv"))

## Neuropsych and PVT Results
d %>%
  select(vc_zscore, cowat_zscore, cvlt_sdelay_recall_zscore, cvlt_ldelay_recall_zscore, cvlt_zscore, ds_zscore, cw_stroop_agecorrected, trails_a_z_score, trails_b_z_score, rt_mean, fs, rl, Group) %>%
  melt(id.vars = "Group") %>%
  ggplot(aes(value, group = Group, fill = Group, alpha = 0.75)) +
  facet_wrap(~ variable, scales = "free") +
  geom_density() + 
  theme_classic() + scale_fill_brewer(palette = "Set1")

d %>%
  select(vc_zscore, cowat_zscore, cvlt_sdelay_recall_zscore, cvlt_ldelay_recall_zscore, cvlt_zscore, ds_zscore, cw_stroop_agecorrected, trails_a_z_score, trails_b_z_score, rt_mean, fs, rl) %>%
  keep(is.numeric) %>% 
  shapiro_test(vc_zscore, cowat_zscore, cvlt_sdelay_recall_zscore, cvlt_ldelay_recall_zscore, cvlt_zscore, ds_zscore, cw_stroop_agecorrected, trails_a_z_score, trails_b_z_score, rt_mean, fs, rl)

listVars = c("vc_zscore", "cowat_zscore", "cvlt_sdelay_recall_zscore", "cvlt_ldelay_recall_zscore", "cvlt_zscore", "ds_zscore", "cw_stroop_agecorrected", "trails_a_z_score", "trails_b_z_score", "rt_mean", "fs", "rl")
nonnormalVars <- 
  tab5 <- CreateTableOne(listVars, data = d, strata = c("Group"))
tab5Mat <- print(tab5, quote = FALSE, noSpaces = TRUE, printToggle = FALSE)
write.csv(tab5Mat, file = paste0(results_dir, "table5.csv"))