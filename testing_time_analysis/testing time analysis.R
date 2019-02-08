# Aging Study
# Difference in test time and acrophase vs. accuracy on the memory match task
# YM and MM

require(ggplot2)

# Load Data ---------------------------------------------------------------


testtime <- read.csv("~/FILENAME")

# will need to double check variable names - should make them "record_id" and "ttime"

data <- read.csv("~/Box/CogNeuroLab/Aging Decision Making R01/Data/combined_data_2019-01-23-v2.csv")

d <- merge(data, testtime, by = "record_id")


# Analysis ----------------------------------------------------------------

d$ttimediff <- d$actphi - d$ttime

ggplot(data = d, aes(x = ttimediff, y = accuracy, colour = group)) + 
  geom_point()

ggplot(data = d, aes(x = ttimediff, y = rt, colour = group)) + 
  geom_point()

summary(lm(accuracy ~ ttimediff, data = d))

summary(lm(rt ~ ttimediff, data = d))