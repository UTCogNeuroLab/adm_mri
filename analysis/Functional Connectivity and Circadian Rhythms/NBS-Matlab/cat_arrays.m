folder = '~/Box/ADM_Study/ADM/data/corr_numpyarrays';
dircontent = dir(fullfile(folder, '*.csv')); 
images = arrayfun(@(f) csvread(fullfile(folder, f.name)), dircontent, 'UniformOutput', false);
image = cat(3, images{:});  