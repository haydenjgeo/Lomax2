% Identify median error value of A for all sites/sizes
% Threshold used to determine appropriate filtering value for |A| 
% Written by Hayden Jacobson, Colorado School of Mines, September 2023

m=0;
%load all boostrapped error arrays
r1=load(sprintf('bootstrap%d%d.mat',m,1));
r2=load(sprintf('bootstrap%d%d.mat',m,2));
r3=load(sprintf('bootstrap%d%d.mat',m,3));

%concatenate error in A
Aer=[r1.Ase ; r2.Ase ; r3.Ase];

%calculate median
Aerm=median(Aer, 'all')
