load('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/rest/FC_wb.mat');

ts = [];
swfc = [];
winlength = 36;

ts_dir = dir('/Users/megmcmahon/ts_data/ts_data/*.1D');
cd /Users/megmcmahon/ts_data/ts_data/

for i = 1:length(ts_dir)
    ts{i} = load(ts_dir(i).name); 
    swfc{i}=dcp_swfc(ts{i},winlength);
end