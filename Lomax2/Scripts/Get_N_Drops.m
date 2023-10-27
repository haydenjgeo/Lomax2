% Identify number of experimental drops before and after left truncation
% results presented in last column of Table A2 (2) in the appendix 
% Written by Hayden Jacobson, Colorado School of Mines, September 2023.

%load rockdrops and results 
for ci=1:3
load(sprintf('rockdrop0%d.mat',ci)); 
load(sprintf('results0%d.mat',ci)); 
for i=1:size(rockdrop,1)
    for j=1:3   
        ndrops(i,j)=sum(rockdrop{i,j}.data.x>0.01); %number of rockdrops after left truncation
    end
end
ndrop2{ci}=ndrops;
end
