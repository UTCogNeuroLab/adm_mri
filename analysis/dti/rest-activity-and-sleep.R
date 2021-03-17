cor.test(d$actamp, d$total_ac_mean_active)
cor.test(d$actamp, d$efficiency_mean_sleep) #p = 0.014, R=0.24
cor.test(d$actamp, d$sleep_time_mean_sleep)

cor.test(d$cc_fa, d$total_ac_mean_active) #p = 0.02073, R=0.229
cor.test(d$cc_fa, d$efficiency_mean_sleep)
cor.test(d$cc_fa, d$sleep_time_mean_sleep)

cor.test(d$cc_fa, d$actamp) #yep

d$Amplitude <- factor(ifelse(d$actamp < median(d$actamp, na.rm = T), 0, 1), labels = c("Low", "High"))
head(d$Amplitude)

listVars = c("sleep_time_mean_sleep", "efficiency_mean_sleep", "onset_latency_mean_sleep", "total_ac_mean_active")
nonnormalVars = c("sleep_time_mean_sleep", "efficiency_mean_sleep", "onset_latency_mean_sleep", "total_ac_mean_active")
tab <- CreateTableOne(listVars, data = d, strata = c("Amplitude"), test = T)
print(tab, nonnormal = nonnormalVars)


t.test(d$total_ac_mean_active ~ d$Amplitude) # t = 0.19374, df = 63.097, p-value = 0.847
t.test(d$efficiency_mean_sleep ~ d$Amplitude) # p = 0.03349, t = -2.1609, df = 85.975, mlow = 79.22, mhigh = 82.65558
t.test(d$sleep_time_mean_sleep ~ d$Amplitude) # t = 0.11654, df = 68.296, p-value = 0.9076
t.test(d$onset_latency_mean_sleep ~ d$Amplitude) # t = 2.8631, df = 86.78, p-value = 0.005259