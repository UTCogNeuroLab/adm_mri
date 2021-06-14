# Rest-activity rhythms and functional connectivity evoked during episodic memory
Megan McMahon
2021

Study information:
Preregistration plan in progress on OSF

## Actigraphy

Actigraphy data collected for 10-14 days for each participant. Some participants had their actigraphy periods split into multiple periods since they were unable to come into lab for their initial Session 2 visit due to bad weather.

Actigraphy data was preprocessed using the preproc function in the [wearables package](http://github.com/UTCogNeuroLab/wearables) on GitHub. This involved truncating the data to include just 7 days in order to retain more subjects, interpolating up to 10 min periods of missing data, and excluding subjects who had less than 7 days of data or  > 10% missing data.

Rest-activity rhythm measures were calculated using an in-house R script (fit_cosinor.R) based on the logistic-transform cosinor method (Marler et al., 2006)

## fMRI

fMRI data was preprocessed using fMRIprep.

Subjects with mean FD > 0.50 mm or with > 20% of TRs with mean FD > 0.50 mm will be excluded from analyses.
