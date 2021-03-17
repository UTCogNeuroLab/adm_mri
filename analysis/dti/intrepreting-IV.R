d$`Intradaily Variability` <- factor(ifelse(d$IV > median(d$IV, na.rm = T), 1, -1))

listVars = c("sleep_time_mean_sleep", "efficiency_mean_sleep", "onset_latency_mean_sleep", "total_ac_mean_active", "exercise_prop")
nonnormalVars = c("sleep_time_mean_sleep", "efficiency_mean_sleep", "onset_latency_mean_sleep", "total_ac_mean_active", "exercise_prop")
tab <- CreateTableOne(listVars, data = d, strata = c("Intradaily Variability"), test = T)
print(tab, nonnormal = nonnormalVars)

t.test(d$sleep_time_mean_sleep ~ d$`Intradaily Variability`) # p =0.004
t.test(d$total_ac_mean_active ~ d$`Intradaily Variability`) #NS
t.test(d$onset_latency_mean_sleep ~ d$`Intradaily Variability`) #NS
t.test(d$efficiency_mean_sleep ~ d$`Intradaily Variability`) #NS

shapiro.test(d$exercise_prop)
t.test(d$exercise_prop ~ d$`Intradaily Variability`) #t = -2.4766, df = 84.539, p-value = 0.01526, low = 0.2938225, high = 0.4273378 

ya <- filter(d, Group == "Young Adults")
t.test(ya$sleep_time_mean_sleep ~ ya$`Intradaily Variability`) # p=0.04
t.test(ya$total_ac_mean_active ~ ya$`Intradaily Variability`) #NS
t.test(ya$onset_latency_mean_sleep ~ ya$`Intradaily Variability`) #NS
t.test(ya$efficiency_mean_sleep ~ ya$`Intradaily Variability`) #NS

oa <- filter(d, Group == "Older Adults")
t.test(oa$sleep_time_mean_sleep ~ oa$`Intradaily Variability`) # p=0.09
t.test(oa$total_ac_mean_active ~ oa$`Intradaily Variability`) #NS
t.test(oa$onset_latency_mean_sleep ~ oa$`Intradaily Variability`) #NS
t.test(oa$efficiency_mean_sleep ~ oa$`Intradaily Variability`) #NS