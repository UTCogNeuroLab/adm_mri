# cosinor rest-activity rhythm simulation
library(lubridate)
library(simglm)
library(readr)
library(tableone)

work_dir <- "~/Box/CogNeuroLab/Aging Decision Making R01/"
results_dir <- paste0(work_dir, "results/rest-activity_and_white_matter_microstructure/")
figs_dir <- paste0(results_dir, "figures/")
data_dir <- paste0(work_dir, "data/")
d <- read_csv(paste0(data_dir, "dataset_2020-06-17.csv")) 

# get characteristics from dataset
tab1 <- CreateTableOne(vars = c("actalph", "actbeta", "actphi", "actamp", "actmin"), data = d)
print(tab1, minMax = T)

actalph <- rep(mean(d$actalph, na.rm = T), 5)
actbeta <- rep(mean(d$actbeta, na.rm = T), 5)
actphi <- rep(mean(d$actphi, na.rm = T), 5)
actmin <- rep(mean(d$actmin, na.rm = T), 5)
actamp <- c(mean(d$actamp, na.rm = T) - 2*sd(d$actamp, na.rm = T), 
            mean(d$actamp, na.rm = T) - sd(d$actamp, na.rm = T),
            mean(d$actamp, na.rm = T),
            mean(d$actamp, na.rm = T) + sd(d$actamp, na.rm = T),
            mean(d$actamp, na.rm = T) + 2*sd(d$actamp, na.rm = T))

fixed_data <- simulate_fixed(data = NULL, sim_arguments)
head(fixed_data, n = 20)

# extended cosinor model
carhythm = function(actphi,actbeta,actalph,actmin,actamp,cloktime) {
  twopio24 = (2*3.14159)/24 
  rhythm = cos(twopio24*(cloktime - actphi ))
  lexpt=actbeta*(rhythm - actalph)
  expt = exp(lexpt)
  er = expt/(1 + expt)
  actmin + actamp*er
  
}

# create 15 day time sequence
d <- c()
d$time <- seq(ymd_hms('2020-01-01 00:00:00'),ymd_hms('2020-01-05 00:00:00'), by = '5 min')

# take only hours and format them as numbers
d$cloktime <- lubridate::hour(d$time) + lubridate::minute(d$time)/60
d <- data.frame(d)


d2 <- c()
l <- length(d$time)
for (i in 1:length(actamp)){
  d$id <- rep(round(actamp[i], 2), l)
  d$activity <- carhythm(actphi[i],actbeta[i],actalph[i],actmin[i],actamp[i],d$cloktime) + rnorm(l)*2
  d2 <- rbind(d2, d)
  
}
d2$id <- factor(d2$id)
head(d2)

ggplot(d2, aes(time, activity)) + 
  geom_point() + 
  facet_wrap(. ~ id) + 
  theme_classic()
