library(readr)
library(dplyr)
library(readxl)

#load data
dti = c()
dti$files = list.files("/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss/origdata/")
dti$record_id = substr(dti$files, 5, 9)

cr <- read_csv('~/Box/CogNeuroLab/Aging Decision Making R01/Data/CR/circadian_rhythms_2019-09-07.csv')
cr$actquot <- cr$actamp/cr$actmesor

neuro <- read_csv('~/Box/CogNeuroLab/Aging Decision Making R01/Data/Neuropsych/AgingDecMemNeuropsyc_DATA_2019-06-12_0708.csv')

neuro_ya <- readxl::read_xlsx("Box/CogNeuroLab/Aging Decision Making R01/Data/Neuropsych/Neuropsych_Data_YA.xlsx", sheet = "TOTALS")
neuro_oa <- readxl::read_xlsx("Box/CogNeuroLab/Aging Decision Making R01/Data/Neuropsych/Neuropsych_Data_OA.xlsx", sheet = "TOTALS")
colnames(neuro_ya) <- c("record_id", "Executive function")
ef <- rbind(neuro_ya, select(neuro_oa, record_id, `Executive function`))
ef

#create dataframe containing relevant variables
dsnmat <- merge(select(neuro, record_id, age, trails_b_z_score), select(cr, record_id, IS:RA, actamp:fact), by = 'record_id', all=TRUE)
dsnmat <- merge(dti, dsnmat, by = "record_id", all=FALSE)
dsnmat <- merge(dsnmat, ef, by = "record_id")
dsnmat$record_id <- as.character(dsnmat$record_id)

dsnmat$age[dsnmat$record_id == "40876"] = 71
dsnmat$age[dsnmat$record_id == "40878"] = 71

dsnmat_ya <- dsnmat[dsnmat$record_id < 40000, ]
dsnmat_oa <- dsnmat[dsnmat$record_id > 40000, ]

write_csv(dsnmat, '/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss/dsnmat_data.csv')
write_csv(dsnmat_ya, '/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss/dsnmat_data_ya.csv')
write_csv(dsnmat_oa, '/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss/dsnmat_data_oa.csv')

#demean every column
id <- select(dsnmat, record_id, files)
id_ya <- id[id$record_id < 40000, ]
id_oa <- id[id$record_id > 40000, ]

dsnmat <- select(dsnmat, -record_id, -files)
dsnmat_ya <- select(dsnmat_ya, -record_id, -files)
dsnmat_oa <- select(dsnmat_oa, -record_id, -files)

center_colmeans <- function(x) {
  xcenter = colMeans(x, na.rm = TRUE)
  x - rep(xcenter, rep.int(nrow(x), ncol(x)))
}

dsnmat_demeaned <- center_colmeans(dsnmat)
dsnmat_demeaned_ya <- center_colmeans(dsnmat_ya)
dsnmat_demeaned_oa <- center_colmeans(dsnmat_oa)

dsnmat_demeaned <- cbind(id, dsnmat_demeaned)
dsnmat_demeaned_ya <- cbind(id_ya, dsnmat_demeaned_ya)
dsnmat_demeaned_oa <- cbind(id_oa, dsnmat_demeaned_oa)

#save as csv for input into fsl_gui
write_csv(dsnmat_demeaned, '/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss/dsnmat_demeaned_data.csv')
write_csv(dsnmat_demeaned_ya, '/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss/dsnmat_demeaned_ya_data.csv')
write_csv(dsnmat_demeaned_oa, '/Volumes/schnyer/Aging_DecMem/Scan_Data/BIDS/derivatives/tbss/dsnmat_demeaned_oa_data.csv')



