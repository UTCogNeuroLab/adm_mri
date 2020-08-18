library(tidyverse)
library(readr)

work_dir <- "~/Box/CogNeuroLab/Aging Decision Making R01/"
results_dir <- paste0(work_dir, "results/rest-activity_and_white_matter_microstructure/")
figs_dir <- paste0(results_dir, "figures/")
data_dir <- paste0(work_dir, "data/")

sleep <- read_delim(paste0(data_dir, "actigraphy/actiware_exports/Combined Export File.csv"), delim = ",", skip = 0)
head(sleep)

sleep %>%
  drop_na(subject_id) %>%
  filter(!grepl('Summary', interval_type)) %>%
  filter(analysis_name == "New Analysis") %>%
  as.data.frame() %>%
  distinct() %>%
  mutate_at(vars(subject_id, interval_type, analysis_name), .funs=tolower) %>%
  mutate(interval_type = as.factor(interval_type)) %>%
  mutate(subject_id = as.factor(subject_id)) %>%
  mutate(start_date = as.Date(start_date, format = "%m/%d/%Y")) %>%
  group_by(subject_id, interval_type) %>%
  top_n(7, start_date) -> sleep2

head(sleep2)

write_csv(sleep2, path = paste0(data_dir, "actigraphy/actiware_exports/sleep_metrics_cleaned.csv"))

sleep2 %>%
  select(subject_id, interval_type, duration, total_ac, onset_latency, efficiency, sleep_time) %>%
  group_by(subject_id, interval_type) %>%
  summarise_all(list(mean = mean, sd = sd, max = max, min = min)) -> sleep_summary

head(sleep_summary)
newcols <- colnames(sleep_summary)[grepl("mean|sd|max|min", colnames(sleep_summary))]

sleep_summary %>%
  pivot_wider(names_from = interval_type, values_from = newcols) -> sleep_summary2

write_csv(sleep_summary2, path = paste0(data_dir, "actigraphy/actiware_exports/sleep_metrics_summarized.csv"))

