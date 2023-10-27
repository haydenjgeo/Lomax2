% Generate data structure containing empirical particle travel distance
% distributions, raw experimental data and metadata. 
% 
% Note: If adjusting this code for different data, particle travel distance 
% data for each site should be contained in csv files following naming format: 
% L##.rockdist.csv, where L is a site identifier and ## is a 2-digit 
% slope angle measured in degrees. 

% All *.rockdist.csv files must have 3 columns, with each column containing
% data for the particle sizes described in the rockstats.mat data
% structure. Columns describe travel distances in units of m.

% Written by Danica Roth, Colorado School of Mines, May 2019.
% Edited by Hayden Jacobson, Colorado School of Mines, September 2023 

clearvars -except numsites theta ep


% Read in all data
load(sprintf('rockstats%d.mat',ep));
files=dir(sprintf('Data/Inputs/e%d/*rockdist.csv',ep));
filenames={files.name};
for i=1:length(filenames)
    sites{i}=filenames{i}(1:3);
    eval([filenames{i}(1:3),sprintf('=csvread(''Data/Inputs/e%d/',ep),filenames{i},''');']);
end

trunc=@(data) (data.x(data.x>theta)-theta); %anonymous function for left-truncating and re-zeroing data to theta
CensorPoint = csvread(sprintf('Data/Inputs/e%d/censorpoints.csv',ep),1,1)-theta; %right-censor points shifted by theta to match re-zeroed data

%% get site metadata/statistics
for s=1:numsites
    for r=1:3 %number of epochs 
        % Store raw experimental data and metadata in rockdrop.data structure
        rockdrop{s,r}.data.SiteName = [sites{s},'_',rockstats(r).RockSize];
        rockdrop{s,r}.data.SlopeDeg=str2num(sites{s}(2:3));
        rockdrop{s,r}.data.Slope=tand(rockdrop{s,r}.data.SlopeDeg);
        rockdrop{s,r}.data.RockSize=rockstats(r).RockSize;
        rockdrop{s,r}.data.IntermediateAxis=rockstats(r).IntermediateAxis.mean;
        rockdrop{s,r}.data.Units='meters';
        rockdrop{s,r}.data.x=eval([sites{s},'(:,r)']); %Raw experimental travel distances
       

        % Make and store empirical distributions in rockdrop.distributions structure
        [pd.X,pd.PDF,pd.CDF,pd.R,pd.P,pd.Xemp,pd.CDFemp,pd.CensorPoint] = distributions(trunc(rockdrop{s,r}.data),'dX',0.001,'CensorPoint',CensorPoint(s,r));
        pd.DistName='Empirical';
        pd.Method='distributions';
        rockdrop{s,r}.distributions=pd;
        rockdrop{s,r}.distributions.theta=theta;
        
    end
end


%deal with epoch 1, variable rockstats, overwrite previously defined int. axis
i=1;        
if ep==1
    for s=1:numsites
        for r=1:3 
            rockdrop{s,r}.data.IntermediateAxis=rockstats(i).IntermediateAxis.mean;
            i=i+1;
        end
    end
end

save(sprintf('Data/Results/rockdrop%d.mat',ep));
disp('Particle travel distance data and empirical distributions saved');