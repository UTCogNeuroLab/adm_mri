source(load.R)
source(ICV-norm.R)
source(fslstats-concat.R)

rc <- read_csv(paste0(data_dir, "AgingDecisionMakingA_DATA_2020-04-01_1502.csv"))
rc$record_id <- stringr::str_pad(rc$record_id, 4, side = "left", pad = 0)
rc$record_id <- ifelse(rc$age < 60, paste0("3", rc$record_id), paste0("4", rc$record_id))
rc$Group <- factor(ifelse(rc$record_id < 40000, -1, 1), labels = c("Young Adults", "Older Adults"))

rc %>%
  fill(record_id,) %>%
  mutate(record_id = as.factor(record_id)) %>%
  fill(sex, years_educ, .direction = "downup") %>%
  filter(redcap_event_name == "online_eligibility_arm_1") %>%
  distinct() -> rc

rc %>%
  drop_na(record_id) %>%
  filter(age > 30 & age < 60) %>%
  select(record_id) -> exclude

np <- read_csv(paste0(data_dir, "neuropsych/AgingDecMemNeuropsyc_DATA_2019-06-12_0708.csv"))
np %>%
  mutate_all(as.numeric) -> np
head(np)

cr <- read_csv(paste0(data_dir, "actigraphy/circadian_measures/7_days/cr_7days.csv"))
npact <- read_csv(paste0(data_dir, "/actigraphy/circadian_measures/7_days/nparact_7days.csv"))
sleep <- read_csv(paste0(data_dir, "actigraphy/actiware_exports/sleep_metrics_summarized.csv"))

cr %>%
  merge(data, by = "record_id", all = T) %>%
  merge(npact, by = "record_id", all = T) %>%
  merge(select(fsvol2, record_id, cc_vol), by = "record_id", all = T) %>%
  merge(sleep, by.x = "record_id", by.y = "subject_id", all = T) %>%
  merge(rc, by = "record_id", all = F) %>%
  merge(select(np, -age, -education, -gender), by = "record_id", all = T) %>%
  drop_na(record_id) %>%
  filter(age <= 30 | age >= 60) -> d

write_csv(d, paste0(data_dir, "dataset_", Sys.Date(), ".csv"))
