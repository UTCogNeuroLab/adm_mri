%Graph Metrics - BCT
%Megan McMahon
%2019

%% Load existing data if available
%FC matrices are first generated through xcpEngine and the nbs.mlx script. This script then reformats FC matrices for use with Brain Connectivity Toolbox.
addpath '~/neuro/BCT/2019_03_03_BCT';
cd '~/Box/adm/data/rsfmri/bct';

%load subject list
load('~/Box/adm/data/rsfmri/sublist.mat');

%load fc matrix from nbs.mlx script if available
load('~/Box/adm/data/rsfmri/nbs/fcmat/fcmat_77sub_07-09-2019.mat')

%load existing bct fc matrix .mat file if available
load('~/Box/adm/data/rsfmri/bct/fc_bct_77sub_07-09-2019.mat')


%% Create FC matrices for BCT
%BCT matrices should contain only positive connections, with no self-connections (diagonal = 0)
%create connectivity matrices for BCT
for i = 1:length(fcmat) 
    fc_bct{i,1} = fcmat{i,2} - diag(diag(fcmat{i,2})); %0 diagonal for BCT
    %fc_bct{i,1} = atanh(fc_bct{i,1}); %r to z transform
    fc_bct{i,1}(fc_bct{i,1}<0) = 0; %replaces negative values with 0

    %whole brain
    fc_bct{i,2} = threshold_proportional(fc_bct{i,1}, 0.05); %prop threshold
    fc_bct{i,3} = threshold_proportional(fc_bct{i,1}, 0.10);
    fc_bct{i,4} = threshold_proportional(fc_bct{i,1}, 0.15);
    fc_bct{i,5} = threshold_proportional(fc_bct{i,1}, 0.20);
    fc_bct{i,6} = threshold_proportional(fc_bct{i,1}, 0.25);
end 

save(sprintf('~/Box/adm/data/rsfmri/bct/fc_bct_%dsub_%s.mat', length(sub), datestr(now,'mm-dd-yyyy')), 'fc_bct');

%% Between vs Within Network FC
for i = 1:length(fc_bct)
    mat = fc_bct{i,1};
    fc_bct_up{i,1} = triu(mat);
end

for i = 1:length(fc_bct)
    fpn_w(i,1) = mean(mean(fc_bct_up{i,1}(fpn, fpn)));
    fpn_w(i,1) = mean(mean(fc_bct_up{i,1}(fpn, fpn)));
    sal_w(i,1) = mean(mean(fc_bct_up{i,1}(sal, sal)));
    
    fpn_btw(i,1) = mean(mean(fc_bct_up{i,1}(fpn, notfpn)));
    fpn_btw(i,1) = mean(mean(fc_bct_up{i,1}(fpn, notfpn)));
    sal_btw(i,1) = mean(mean(fc_bct_up{i,1}(fpn, notsal)));
    
    fpn_fpn(i,1) = mean(mean(fc_bct_up{i,1}(fpn, fpn)));
    fpn_sal(i,1) = mean(mean(fc_bct_up{i,1}(fpn, sal)));
    fpn_sal(i,1) = mean(mean(fc_bct_up{i,1}(fpn, sal)));
    
end

fc_mean_table = table(fpn_w, fpn_w, sal_w, fpn_btw, fpn_btw, sal_btw, fpn_fpn, fpn_sal, fpn_sal)

writetable(fc_mean_table, sprintf('~/Box/adm/data/rsfmri/bct/fc_mean_%s.csv', datestr(now,'mm-dd-yyyy')));

%% Brain Connectivity Toolbox Graph Metrics
%Setup
net_id = csvread('~/Box/adm/data/rsfmri/schaefer/schaefer_affiliation.csv');
load('~/Box/adm/data/rsfmri/schaefer/dmn.mat'); 
load('~/Box/adm/data/rsfmri/schaefer/fpn.mat'); 
load('~/Box/adm/data/rsfmri/schaefer/sal.mat'); 

%thresholds
threshold = [1.00 0.05 0.10 0.15 0.20 0.25];

fcmet = table;
fcmet.record_id = sub;

%% Compute nodewise metrics
for j = 1:length(threshold)
    for i = 1:length(fc_bct)
        nodewise_participation{i,j} = participation_coef(fc_bct{i,j},net_id);
        nodewise_clustering{i,j} = clustering_coef_wu(weight_conversion(fc_bct{i,j}, 'normalize'));
    end
end


%% Whole brain metrics
%efficiency takes a long time to run!!

for j = 1:length(threshold) %at each graph threshold
    for i = 1:length(fc_bct) %for each subject
%         D{i,1} = distance_wei(fc_bct{i,1});
%         fcmet.wb_charpath(i,1) = charpath(D{i,1});
%         fcmet.wb_participation(i,j) = mean(nodewise_participation{i,j});
%         [Ci fcmet.wb_modularity(i,j)] = modularity_und(fc_bct{i,j}, 1);
%         fcmet.wb_clustering(i,j) = mean(nodewise_clustering{i,j});
        fcmet.wb_efficiency(i,j) = efficiency_wei(fc_bct{i,j}, 0); %global
        sprintf('participant %d out of %d', i, length(fc_bct))
    end
    sprintf('completed for threshold %d out of %d', j, length(threshold))
end

%% Default mode network metrics
for j = 1:length(threshold)
    for i = 1:length(fc_bct)
        fcmet.dmn_charpath(i,1) = charpath(D{i,1}(dmn, dmn)); 
        fcmet.dmn_participation(i,j) = mean(nodewise_participation{i,j}(dmn));
        [Ci fcmet.dmn_modularity(i,j)] = modularity_und(fc_bct{i,j}(dmn, dmn), 1);
        fcmet.dmn_clustering(i,j) = mean(nodewise_clustering{i,j}(dmn));
        fcmet.dmn_efficiency(i,j) = efficiency_wei(fc_bct{i,j}([dmn, dmn]), 0);
    end
    sprintf('completed for threshold %d out of %d', j, length(threshold))
end


%% Frontoparietal network metrics
for j = 1:length(threshold)
    for i = 1:length(fc_bct)
        fcmet.fpn_charpath(i,1) = charpath(D{i,1}(fpn, fpn));        
        fcmet.fpn_participation(i,j) = mean(nodewise_participation{i,j}(fpn));
        [Ci fcmet.fpn_modularity(i,j)] = modularity_und(fc_bct{i,j}(fpn, fpn), 1);
        fcmet.fpn_clustering(i,j) = mean(nodewise_clustering{i,j}(fpn));
        fcmet.fpn_efficiency(i,j) = efficiency_wei(fc_bct{i,j}([fpn, fpn]), 0); 
    end
    sprintf('completed for threshold %d out of %d', j, length(threshold))
end


%% Salience network metrics
for j = 1:length(threshold)
    for i = 1:length(fc_bct)
        fcmet.sal_charpath(i,1) = charpath(D{i,1}(sal, sal)); 
        [Ci fcmet.sal_modularity(i,j)] = modularity_und(fc_bct{i,j}(sal, sal), 1);
        fcmet.sal_participation(i,j) = mean(nodewise_participation{i,j}(sal));
        fcmet.sal_clustering(i,j) = mean(nodewise_clustering{i,j}(sal));
        fcmet.sal_efficiency(i,j) = efficiency_wei(fc_bct{i,j}([sal, sal]), 0); 
    end
    sprintf('completed for threshold %d out of %d', j, length(threshold))
end

%% Save as .csv file
writetable(fcmet1, sprintf('~/Box/adm/data/rsfmri/bct/fcmet_%s.csv', datestr(now,'mm-dd-yyyy')));

