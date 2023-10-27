% Generate structure containing experimental particle characteristics shown
% Written by Danica Roth, Colorado School of Mines, May 2019.
% Edited by Hayden Jacobson, Colorado School of Mines, Feb 2023.

clearvars -except numsites theta ep

% Read in data
if ep==1 %due to missing data in epoch 1 must specify formatting 
stats{1}=csvread('Data/Inputs/e1/rockstatsS21/rockstats.small.csv');
stats{2}=csvread('Data/Inputs/e1/rockstatsS21/rockstats.medium.csv');
stats{3}=csvread('Data/Inputs/e1/rockstatsS21/rockstats.large.csv'); %Note that this is placeholder data only
stats{4}=csvread('Data/Inputs/e1/rockstatsS26/rockstats.small.csv');
stats{5}=csvread('Data/Inputs/e1/rockstatsS26/rockstats.medium.csv');
stats{6}=csvread('Data/Inputs/e1/rockstatsS26/rockstats.large.csv');
stats{7}=csvread('Data/Inputs/e1/rockstatsS39/rockstats.small.csv');
stats{8}=csvread('Data/Inputs/e1/rockstatsS39/rockstats.medium.csv');
stats{9}=csvread('Data/Inputs/e1/rockstatsS39/rockstats.large.csv');
rocksize={'small','med','large','small','med','large','small','med','large'};
else 
stats{1}=csvread(sprintf('Data/Inputs/e%d/rockstats.small.csv',ep));
stats{2}=csvread(sprintf('Data/Inputs/e%d/rockstats.medium.csv',ep));
stats{3}=csvread(sprintf('Data/Inputs/e%d/rockstats.large.csv',ep));
rocksize={'small','med','large'};
end

% Populate fields of rockstats structure
for i=1:length(stats)
        rockstats(i).RockSize=rocksize{i};
        rockstats(i).IntermediateAxis.mean=nanmean(stats{i}(:,1))./1e2;
end

save(sprintf('Data/Results/rockstats%d.mat',ep));

disp('Experimental particle data saved');