

%% Load timeseries
ts = [];
ts_dir = dir('/Users/megmcmahon/ts_data/ts_data/*.1D');
cd /Users/megmcmahon/ts_data/ts_data/
for i = 1:length(ts_dir)
    ts{i} = load(ts_dir(i).name); 
end

record_id = char(ts_dir.name);
record_id = str2num(record_id(:, 1:5));
group = (record_id > 40000);
OA_ind = find(group, 1);

%% xDF https://github.com/asoroosh/xDF#xxDF
% Suppose X is a matrix of size IxT 
% where I is number of regions and T is number of data-points,

threshold = 0.10:0.02:0.20;

schaefer = load('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/schaefer400/schaefer_affiliation.csv');
dmn = find(schaefer == 7);
fpn = find(schaefer == 6);

FC_wb = [];
FC_dmn = [];
FC_fpn = [];

for i = 1:length(ts)
    [VarRho,Stat] = xDF(ts{i}',240,'truncate','adaptive','verbose');
    FC_wb{i, 1} = Stat.z; %FC_wb of IxI
    FC_dmn{i,1} = Stat.z(dmn, dmn); %Default Mode Network
    FC_fpn{i,1} = Stat.z(fpn,fpn); % Frontoparietal Control Network
end

for i = 1:length(ts)
    for j = 1:length(threshold)
        [~,CE_den]=CostEff_bin(FC_wb{i,1},threshold(j));
        FC_wb{i, j+1} = threshold_proportional(FC_wb{i,1},CE_den);
        FC_dmn{i,j+1} = threshold_proportional(FC_dmn{i,1},CE_den);
        FC_fpn{i,j+1} = threshold_proportional(FC_fpn{i,1},CE_den);
    end
end

save('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/rest/FC_wb.mat', 'FC_wb');
save('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/rest/FC_dmn.mat', 'FC_dmn');
save('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/rest/FC_fpn.mat', 'FC_fpn');

%% BCT metrics

%A node is considered a hub if its regional betweenness centrality is 1 SD higher than the mean network betweenness (Bernhardt et al., 2011).
%Comparing connectivity pattern and small-world organization between structural correlation and resting-state networks in healthy adults 
%SM. Hadi Hosseini, PhD1,* and Shelli R. Kesler, PhD1,2

bct = [];
FC_wb_norm = [];
for i = 1:length(FC_wb)
    for j = 1:length(threshold)
        % Whole Brain
        FC_wb_norm{i,j} = weight_conversion(FC_wb{i,j}, 'normalize');
        
        bct.wb.clustering(i,j) = mean(clustering_coef_wu(FC_wb_norm{i,j}));
        bct.wb.efficiency(i,j) = efficiency_wei(FC_wb{i,j});
        [~, bct.wb.modularity(i,j)] = modularity_und(FC_wb{i,j});
        
        P = participation_coef(FC_wb{i,j}, schaefer, 0);
        B = betweenness_wei(FC_wb{i,j});
        
        bct.wb.participation_mean(i,j) = mean(P);
        bct.wb.betweenness_mean(i,j) = mean(B);
    end
end

FC_dmn_norm = [];
FC_fpn_norm = [];
for i = 1:length(FC_wb)
    for j = 1:length(threshold)
        P = participation_coef(FC_wb{i,j}, schaefer, 0);
        B = betweenness_wei(FC_wb{i,j});
        
        bct.wb.participation{i,j} = P;
        bct.wb.participation{i,j} = B;
        
        % Default Mode Network
        FC_dmn_norm{i,j} = weight_conversion(FC_dmn{i,j}, 'normalize');
        
        bct.dmn.clustering(i,j) = mean(clustering_coef_wu(FC_dmn_norm{i,j}));
        bct.dmn.efficiency(i,j) = efficiency_wei(FC_dmn{i,j});
        [~, bct.dmn.modularity(i,j)] = modularity_und(FC_dmn{i,j});
        bct.dmn.participation_mean(i,j) = mean(P(dmn));
        bct.dmn.betweenness_mean(i,j) = mean(B(dmn));

        % Frontoparietal Control Network
        FC_fpn_norm{i,j} = weight_conversion(FC_fpn{i,j}, 'normalize');
        
        bct.fpn.clustering(i,j) = mean(clustering_coef_wu(FC_fpn_norm{i,j}));
        bct.fpn.efficiency(i,j) = efficiency_wei(FC_fpn{i,j});
        [~, bct.fpn.modularity(i,j)] = modularity_und(FC_fpn{i,j});
        bct.fpn.participation_mean(i,j) = mean(P(fpn));
        bct.fpn.betweenness_mean(i,j) = mean(B(fpn));

    end
end

save('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/bct/bct.mat', 'bct');
%% Plot

%Whole Brain
figure;
subplot(3,2,1); 
plot(0.12:0.02:0.20, mean(bct.wb.clustering(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.wb.clustering(OA_ind:length(bct.wb.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.10 0.21]);
ylabel('Clustering Coefficient');

subplot(3,2,2); 
plot(0.12:0.02:0.20, mean(bct.wb.efficiency(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.wb.efficiency(OA_ind:length(bct.wb.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Global Efficiency');

subplot(3,2,3); 
plot(0.12:0.02:0.20, mean(bct.wb.modularity(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.wb.modularity(OA_ind:length(bct.wb.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Modularity');

subplot(3,2,4); 
plot(0.12:0.02:0.20, mean(bct.wb.participation_mean(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.wb.participation_mean(OA_ind:length(bct.wb.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Participation Coefficient');

subplot(3,2,5); 
plot(0.12:0.02:0.20, mean(bct.wb.betweenness_mean(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.wb.betweenness_mean(OA_ind:length(bct.wb.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Betweenness Centrality');


%Default Mode Network
figure;
subplot(3,2,1); 
plot(0.12:0.02:0.20, mean(bct.dmn.clustering(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.dmn.clustering(OA_ind:length(bct.dmn.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.10 0.21]);
ylabel('Clustering Coefficient');

subplot(3,2,2); 
plot(0.12:0.02:0.20, mean(bct.dmn.efficiency(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.dmn.efficiency(OA_ind:length(bct.dmn.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Global Efficiency');

subplot(3,2,3); 
plot(0.12:0.02:0.20, mean(bct.dmn.modularity(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.dmn.modularity(OA_ind:length(bct.dmn.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Modularity');

subplot(3,2,4); 
plot(0.12:0.02:0.20, mean(bct.dmn.participation_mean(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.dmn.participation_mean(OA_ind:length(bct.dmn.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Participation Coefficient');

subplot(3,2,5); 
plot(0.12:0.02:0.20, mean(bct.dmn.betweenness_mean(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.dmn.betweenness_mean(OA_ind:length(bct.dmn.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Betweenness Centrality');


%Frontoparietal Control Network
figure;
subplot(3,2,1); 
plot(0.12:0.02:0.20, mean(bct.fpn.clustering(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.fpn.clustering(OA_ind:length(bct.fpn.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.10 0.21]);
ylabel('Clustering Coefficient');

subplot(3,2,2); 
plot(0.12:0.02:0.20, mean(bct.fpn.efficiency(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.fpn.efficiency(OA_ind:length(bct.fpn.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Global Efficiency');

subplot(3,2,3); 
plot(0.12:0.02:0.20, mean(bct.fpn.modularity(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.fpn.modularity(OA_ind:length(bct.fpn.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Modularity');

subplot(3,2,4); 
plot(0.12:0.02:0.20, mean(bct.fpn.participation_mean(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.fpn.participation_mean(OA_ind:length(bct.fpn.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Participation Coefficient');

subplot(3,2,5); 
plot(0.12:0.02:0.20, mean(bct.fpn.betweenness_mean(1:OA_ind-1,2:6)), '-b', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
hold on
plot(0.12:0.02:0.20, mean(bct.fpn.betweenness_mean(OA_ind:length(bct.fpn.clustering),2:6)), '-r', 'LineWidth', 2, 'Marker', 'o', 'MarkerSize', 10);
legend({'Young Adults','Older Adults'},'Location','southwest'); xlim([0.11 0.21]);
ylabel('Betweenness Centrality');

%% Analysis

%Averaging metrics across thresholds
bct_x = table();
bct_x.record_id = record_id;
bct_x.wb_clustering_x = mean(bct.wb.clustering(:,2:6), 2);
bct_x.wb_efficiency_x = mean(bct.wb.efficiency(:,2:6), 2);
bct_x.wb_modularity_x = mean(bct.wb.modularity(:,2:6), 2);
bct_x.wb_participation_x = mean(bct.wb.participation_mean(:,2:6), 2);
bct_x.wb_betweenness_x = mean(bct.wb.betweenness_mean(:,2:6), 2);

bct_x.dmn_clustering_x = mean(bct.dmn.clustering(:,2:6), 2);
bct_x.dmn_efficiency_x = mean(bct.dmn.efficiency(:,2:6), 2);
bct_x.dmn_modularity_x = mean(bct.dmn.modularity(:,2:6), 2);
bct_x.dmn_participation_x = mean(bct.dmn.participation_mean(:,2:6), 2);
bct_x.dmn_betweenness_x = mean(bct.dmn.betweenness_mean(:,2:6), 2);

bct_x.fpn_clustering_x = mean(bct.fpn.clustering(:,2:6), 2);
bct_x.fpn_efficiency_x = mean(bct.fpn.efficiency(:,2:6), 2);
bct_x.fpn_modularity_x = mean(bct.fpn.modularity(:,2:6), 2);
bct_x.fpn_participation_x = mean(bct.fpn.participation_mean(:,2:6), 2);
bct_x.fpn_betweenness_x = mean(bct.fpn.betweenness_mean(:,2:6), 2);

writetable(bct_x, '~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/bct/bct_x.csv');

%% Create design matrices
dsnmat = cat(2, cat(1, ones(40, 1), zeros(36, 1)), cat(1, zeros(40, 1), ones(36, 1)));
save('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/dsnmat_ya_oa.mat', 'dsnmat'); 

dsnmat_age_ef_int = cat(2, cat(1, ones(48, 1), ones(44, 1).*-1), efzscores);
dsnmat_age_ef_int(:,3) = dsnmat_age_ef_int(:,1) .* dsnmat_age_ef_int(:,2);
save('~/Box/CogNeuroLab/Aging Decision Making R01/Analysis/dsnmat_age_ef_int.mat', 'dsnmat_age_ef_int'); 

%remove columns of ones
%join dmn and fpn
%trails b and digit span backwards for ya and oa
%dsnmat = one group col, one score col, one group * score column

%% Save out adjacency matrix
global nbs; adj=nbs.NBS.con_mat{2}+nbs.NBS.con_mat{2}'; dlmwrite('adj_fact-int-2.txt',full(adj),'delimiter',' ','precision','%d')

