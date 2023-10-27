function [Ase,Bse,xrse] = lomaxbootstrap2(A_opt,B_opt,CensorPoint,Precision,varargin)

% Calculates bootstrapped standard error for Lomax model parameters A, B and B/|A| by
% generating 100 random values from a Lomax distribution with input A and B
% parameters left-truncating/re-zeroing at input theta value and
% right-censoring with input CensorPoint, then optimizing parameters A and B
% individually while holding the other at its known value.
% 
%  Required Inputs:
%      A_opt, B_opt : optimized values for A and B Lomax parameters
%      CensorPoint : right-censor value 
%      Precision : precision (number of decimal places) for bootstrap sample values
%               randomly generated from lomax distribution with paremeters A_opt and B_opt
% 
%  Optional Inputs:
%      'theta' : left-truncation (x-shift) value (used to optimize A_opt and B_opt)
%      'FitMethod' : 'linear' or 'log' (default = 'linear')
%      'Conditions' : additional parameter conditions (will blow up error if met)
%                (e.g., ssepareto(v,X,R,'Condition',{'A>0' 'P<0'}] will NOT allow A>0 or P<0)
%      'Display' : 'on' or 'off' display iterations for fit (default = 'off')
%      'iboot' : number of bootstrap iterations (default = 10000) 
%      'MaxIter' : maximum positive integer number of iterations allowed in fminsearch (default = 100000)
%      'MaxFunEvals' : maximum positive integer number of function evaluations allowed in fminsearch (default = 1000000)
%     
%  Outputs:
%      Ase, Bse, xrse : bootstrapped standard error value for A, B and xr=B/|A| parameters, respectively
%       
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%
% Written by Danica Roth, Colorado School of Mines, May 2019.
% Modified by Hayden Jacobson, Colorado School of Mines, September 2023
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%% Parse variable input arguments
okargs={'FitMethod' 'Conditions' 'Display' 'iboot' 'MaxIter' 'MaxFunEvals' 'method' 'theta'};
defaults={'linear' [] 'off' 1000 100000 1000000 0}; 
[fitmethod, conditions, display, iboot, maxiter, maxfunevals,theta]=internal.stats.parseArgs(okargs, defaults, varargin{:});

%% Define anonymous functions
col = @(x) reshape(x,[numel(x),1]); %anonymous function to reshape data into single column
DA=@(A,r,c) A(r,c); %select specific elements of array (doesn't require deal) 
trunc=@(x) (x(x>theta)-theta); %anonymous function to left-truncate and re-zero data 


%% Run bootstrap procedure
options = optimset('MaxIter',maxiter, 'MaxFunEvals',maxfunevals,'Display',display); % increase iterations so GP converges
A_se=zeros(length(iboot));
B_se=zeros(length(iboot));
xr_se=zeros(length(iboot));
for i=1:iboot
    %Generate 100 values from a Lomax distribution...
    %...with theta=0 (input theta value has been truncated, shifted and re-zeroed)
    Xrand = round(random('Generalized Pareto',A_opt, B_opt, 0,[100,1]).*10.^(Precision))./10.^(Precision);
    while any(Xrand<0)
        Xrand(Xrand<0) = round(random('Generalized Pareto',A_opt, B_opt, 0,[size(find(Xrand<0)),1]).*10.^(Precision))./10.^(Precision);
    end
    
    % Calculate empirical distributions for bootstrapped data - is this not
    % done already and stored in lomax optimization or rockdrops? I guess a
    % tiny bit different 
    [Xse,~,~,Rse,Pse,~,~] = distributions(trunc(Xrand),'dX',0.001,'CensorPoint',CensorPoint);  
    
    % Optimize lomax parameters for bootstrapped data
    SEcens = Xse>=CensorPoint; 
    [fitresulttest,~,~,~]=createfit(Xse,Rse,'(1+x./lambda).^(-alpha)','fitmethod',fitmethod,'censoring',SEcens, 'Lower',[0 0],'Upper',[inf inf],'Start',[0 0.0001]);
    A_bs_pre0=1./fitresulttest.alpha;
    B_bs_pre= fitresulttest.lambda./fitresulttest.alpha;
    
    [fitresulttestA,~,~,~]=createfit(Xse,Rse,eval(['''(1+A.*x./',num2str(B_bs_pre),').^-(1./A)''']), 'fitmethod',fitmethod,'censoring',SEcens,'upper',[inf],'start',A_bs_pre0,'lower',[-B_bs_pre/max(Xse(~SEcens))],'plot','off');
    A_bs_pre=fitresulttestA.A;

        %theta set to 0 here because distributions already shifted w/ trunc()
        fA = @(v) ssepareto(v,Xse,Rse,'censoring',SEcens, 'fitmethod',fitmethod, 'B',B_opt,'theta',0, 'Conditions',conditions, 'AddVar',{'P' Pse});
        A_se(i)=fminsearch(fA,A_bs_pre.*2,options);
        fB = @(v) ssepareto(v,Xse,Rse, 'censoring',SEcens, 'fitmethod',fitmethod, 'A',A_opt,'theta',0, 'Conditions',conditions, 'AddVar',{'P' Pse});
        B_se(i)=fminsearch(fB,B_bs_pre.*2,options);      
% elseif method ==1
%         fA = @(v) M1(Xse,Rse,v,thetain,'B',B_opt);
%         A_se(i)=fminsearch(fA,A_bs_pre,options);
%         fB = @(v) M1(Xse,Rse,v,thetain,'A',A_opt);
%         B_se(i)=fminsearch(fB,B_bs_pre,options);
% elseif method ==2
%         fA = @(v) M2(Xse,Rse,v,thetain,'B',B_opt);
%         A_se(i)=fminsearch(fA,A_bs_pre,options);
%         fB = @(v) M2(Xse,Rse,v,thetain,'A',A_opt);
%         B_se(i)=fminsearch(fB,B_bs_pre,options);
% end

end    

% Calculate final standard error for A, B and B/|A|
%Remember this is Bootstrap SE NOT tranditional SE
Ase=std(A_se);
Bse=std(B_se);
covAB=DA(cov(col(A_se),col(B_se)),1,2);
xrse=sqrt((B_opt*Ase/A_opt^2)^2 + (Bse/A_opt)^2 - 2*B_opt*covAB/A_opt^3); %Method of moments, std dev B/|A| calculated
