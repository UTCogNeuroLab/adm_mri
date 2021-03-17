d <- read_csv(paste0(data_dir, "dataset_2020-06-17.csv")) #includes mean fa from spherical rois 6mm rad
d$Group <- factor(d$Group, levels = c("Young Adults", "Older Adults"))

recodeVars = c("vascular_disease", "diabetes", "cancer", "head_inj", 
               "neurologicaldisorders", "psychiatric_do", "sleep_do", "sex", "stroke", "Group")

d[,recodeVars] <- d %>%
  select(recodeVars) %>%
  mutate_if(is.integer, factor) %>%
  mutate_if(is.character, factor)