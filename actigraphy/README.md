# Actigraphy Analysis
### scripts used for analysis of circadian sleep-activity cycles

Phillips Respironics Actiware 6.0 with Actiwatch 2.0 \

## 1) actigraph_prep.py
After exporting data from Actiware as csv, this script removes NaN values at the beginning and end of the period, since this is when the watch was being fitted to or retrieved from the participant. It also will interpolate up to 5 minutes of missing activity values.

## 2) cr_recording_period.R
Uses custom script to fit each participant's actigraphy data to an extended cosinor model and compute circadian measures that describe sleep-activity cycles, such as mesor (mean activity level), acrophase (time of peak activity), beta (rate of transition from low to high activity), etc. (Sherman et al, 2015).

We also use the nparACT package (Blume et al, 2016) to compute circadian measures such as interdaily stability, intradaily variability, relative amplitude, M5 (mean activity level for 5 consecutive hours of greatest activity), and L10 (mean activity level for 10 consecutive hours with lowest activity).

### References
Blume, C., Santhi, N., & Schabus, M. (2016). ‘nparACT’package for R: A free software tool for the non-parametric analysis of actigraphy data. MethodsX, 3, 430-435.

Sherman, S. M., Mumford, J. A., & Schnyer, D. M. (2015). Hippocampal activity mediates the relationship between circadian activity rhythms and memory in older adults. Neuropsychologia, 75, 617-625.
