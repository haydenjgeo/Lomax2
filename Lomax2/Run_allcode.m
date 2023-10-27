% Run all scripts required to calculate lomax parameters and error at all
% epoch/site/grain size combinations then make figures. 

% Written by Danica Roth, Colorado School of Mines, May 2019
% Edited by Hayden Jacobson, Colorado School of Mines, September 2023

% Use Run_allcode_updated.m to run all code and reproduce plots.
% 
% Must set: epoch (ep=1, 2, or 3), theta (theta=0.01), number of sites (numsites=3 or 7). 
% 	epoch refers to time period (Spring 2021, Summer 2021, Spring 2022)
% 	method refers to fit method (1=orthogonal fitting, 2=orthogonal fitting with higher weighting on low density points in tail) 
% 
% Then run: make_rockdrops, make_rockstats, run_lomaxoptimization, BootstrapTime (in order) 
% 
% To plot figures: Wolmantiles, RplotCondensed, AEvo, Rplot

%% epoch 1
clear 
ep = 1; %epoch
numsites=3; %number of test sites
theta=0.01; %left truncation value
make_rockstats %determine median grain sizes
make_rockdrops %construct empirical distributions from experiments
run_lomaxoptimization %fit lomax distribution and get parameters (lomaxopt, ssepareto called to obtain fits) 
BootstrapTime %bootstrap error estimates for A, B, B/|A|
%Note - BootstrapTime will take a long time to run (hours) for each epoch with 
%'MaxIter','MaxFunEvals', and 'iboot' values left as are in the script. 


%% epoch 2
clear 
ep = 2; 
numsites=7; 
theta=0.01;
method = 0;
make_rockstats 
make_rockdrops
run_lomaxoptimization
BootstrapTime

%% epoch 3
clear 
ep = 3; 
numsites=7; 
theta=0.01;
method = 0;
make_rockstats 
make_rockdrops
run_lomaxoptimization
BootstrapTime

%% create figures  
%note each script closes all existing open figures and prints new figures to png

Wolmantiles %figure 4 in main text(size distributions from Wolman Counts) 
%%
RplotCondensed %figures 5 and 6 in main text (fitted R(x) distributions)
%%
AEvo %figure 7 in main text (Evolution of A)
%%
Rplot %Appendix figures (detailed R(x) plots w/ error and empirical data)

%% update all figures to have 400 dpi resolution!



