d <- read_csv(paste0(data_dir, "dataset_2020-06-17.csv")) #includes mean fa from spherical rois 6mm rad

d$Group <- factor(d$Group, levels = c("Young Adults", "Older Adults"))
d$sex <- factor(ifelse(substr(d$sex, 1, 1) == "M", -1, 1), labels = c("Male", "Female"))
d$stroke <- as.factor(ifelse(d$stroke == 0, "Negative", "Positive"))

recodeVars = c("vascular_disease", "diabetes", "cancer", "head_inj", 
               "neurologicaldisorders", "psychiatric_do", "sleep_do")

d %>%
  select(recodeVars) %>%
  mutate_if(is.integer, factor) %>%
  mutate_at(recodeVars, funs(recode(.,`1` = "Positive", `2` = "Negative", `3` = "Negative"))) -> d[recodeVars]

# all participants
d2 <- d 

# only participants with dti data
d <- d2 %>%
  drop_na(cc_fa) %>%
  distinct(record_id, .keep_all = T)