source(load.R)

ya <- as.data.frame(list.files("/Volumes/G-DRIVE mobile/derivatives/tbss_ya/origdata/"))
colnames(ya) <- "files"
ya$cc_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_ya/stats/mean_fa_cc-ya.txt", delim =" ", col_names = F)[,1]))
ya$ccbody_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_ya/stats/mean_fa_ccbody-ya.txt", delim =" ", col_names = F)[,1]))
ya$splenium_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_ya/stats/mean_fa_splenium-ya.txt", delim =" ", col_names = F)[,1]))
ya$genu_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_ya/stats/mean_fa_genu-ya.txt", delim =" ", col_names = F)[,1]))
ya$coronaradiata_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_ya/stats/mean_fa_coronaradiata-ya.txt", delim =" ", col_names = F)[,1]))
ya$postthalamicradiation_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_ya/stats/mean_fa_postthalamicradiation-ya.txt", delim =" ", col_names = F)[,1]))
ya$suplongfasciculus_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_ya/stats/mean_fa_suplongfasciculus-ya.txt", delim =" ", col_names = F)[,1]))
ya$externalcapsule_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_ya/stats/mean_fa_externalcapsule-ya.txt", delim =" ", col_names = F)[,1]))
ya$global_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_ya/stats/mean_fa_global-ya.txt", delim =" ", col_names = F)[,1]))

head(ya)

oa <- as.data.frame(list.files("/Volumes/G-DRIVE mobile/derivatives/tbss_oa/origdata/"))
colnames(oa) <- "files"
oa$cc_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_oa/stats/mean_fa_cc-oa.txt", delim =" ", col_names = F)[,1]))
oa$ccbody_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_oa/stats/mean_fa_ccbody-oa.txt", delim =" ", col_names = F)[,1]))
oa$splenium_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_oa/stats/mean_fa_splenium-oa.txt", delim =" ", col_names = F)[,1]))
oa$splenium_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_oa/stats/mean_fa_splenium-oa.txt", delim =" ", col_names = F)[,1]))
oa$genu_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_oa/stats/mean_fa_genu-oa.txt", delim =" ", col_names = F)[,1]))
oa$coronaradiata_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_oa/stats/mean_fa_coronaradiata-oa.txt", delim =" ", col_names = F)[,1]))
oa$postthalamicradiation_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_oa/stats/mean_fa_postthalamicradiation-oa.txt", delim =" ", col_names = F)[,1]))
oa$suplongfasciculus_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_oa/stats/mean_fa_suplongfasciculus-oa.txt", delim =" ", col_names = F)[,1]))
oa$externalcapsule_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_oa/stats/mean_fa_externalcapsule-oa.txt", delim =" ", col_names = F)[,1]))
oa$global_fa <- as.numeric(unlist(read_delim("/Volumes/G-DRIVE mobile/derivatives/tbss_oa/stats/mean_fa_global-oa.txt", delim =" ", col_names = F)[,1]))

head(oa)

data <- rbind(ya, oa)
data$record_id <- substring(data$files, 5, 9)
data$record_id 