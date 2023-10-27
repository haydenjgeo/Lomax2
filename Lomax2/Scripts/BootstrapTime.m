% Calculate bootstrapped standard error of optimized lomax parameters A, B,
% and B/|A| for all sites and particle sizes. 
%
% Written by Danica Roth, Colorado School of Mines, May 2019.
% Edited by Hayden Jacobson, Colorado School of Mines, September 2023. 

 load(sprintf('results%d.mat',ep));
      
    for s=1:numsites %slope identifier    numsites
        for r=1:3 %rock size identifier 3
            
            disp(['[',datestr(datetime),'] Site ',site{s},' starting...']);
            
            % Get precision (number of decimal places) of travel distance X measurements
            [~,ca]=find(num2str(X{s,r})=='.');
            prec=max(size(num2str(X{s,r}),2)-ca);

            % Run bootstrap error calculation algorithm
            [Ase(s,r),Bse(s,r),xrse(s,r)] = lomaxbootstrap2(A_opt(s,r),B_opt(s,r),CensorPoint(s,r),prec,'fitmethod',fitmethod, 'conditions',conditions,'theta',...
                theta,'MaxIter',100000,'MaxFunEvals',1000000,'iboot',10000); %100000,1000000,10000
         end
    end 

    save(sprintf('Data/Results/bootstrap%d.mat',ep));
    disp('Bootstrapped standard error arrays saved');