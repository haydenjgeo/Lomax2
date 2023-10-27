Use Run_allcode.m to run code if desired. Run_allcode.m prepares data for creating plots. Three subsections correspond to three epochs.

In Run_allcode.m: 

Must set: epoch (ep=1, 2, or 3), theta (theta=0.01), method (method=0 results presented in paper, alternate methods not included), number of sites (numsites=3 in epoch 1 or 7 in other epochs). 
	epoch refers to time period (Spring 2021, Summer 2021, Spring 2022)

Then run: make_rockdrops, make_rockstats, run_lomaxoptimization, BootstrapTime (in order) 

To plot figures: Use Rplot ScalingAEvo 

	Rplot() outputs All R(x) figures with both method 1 and method 2 data, annotated with Lomax Params and BSE (error). 
	

Example: 

Rplot() - outputs all R figures
ScalingAEvo(1,1) - outputs method 1 figures, with A values filtered to |A|>0.1
ScalingAEvo(2,0) - outputs method 2 figures, unfiltered
