%Plot evolution of A (mean A value at NFS and SFS for each grain size) through 3 experimental epochs. 
%The evolution of A with values |A|<0.1 filtered is also plotted

%Written by Hayden Jacobson, Colorado School of Mines, September 2023

clear all
close all
%% %make figure
f2=figure;
f2.Position = [0 0 900 500];
t=tiledlayout(2,3);


colors={'k','r'};
linestyles={'-','--'};

 for Afilt = 0:1
  
%mean/median flag - mean @ 1, median @ 2
mmf=1;
method=0;
%desired variables for scaling
A2=[]; B2=[]; S2=[]; D2=[];

%# epochs, organized by column in subplot 
for ci=1:3
    load(sprintf('results%d.mat',ci)); 
    A2=[A2; A_opt]; %A opts sorted by epoch in nsites x nsizes vector 
end

A2(1,3)=NaN; %remove false data from S21 L epoch 1

Asm=A2(:,1); Amd=A2(:,2); Alg=A2(:,3); %isolate different sizes


%prep A for plotting 
%separate by epoch, previously required and may be desireable again
%epoch 1
As1=[NaN(4,1);Asm(1:3)]; %throw in NaNs where no data was collected epoch 1
Am1=[NaN(4,1);Amd(1:3)];
Ag1=[NaN(4,1);Alg(1:3)];%A g one = A large where large=lg. Bad names oops 

%epoch 2
As2=Asm(4:10); 
Am2=Amd(4:10);
Ag2=Alg(4:10);

%epoch 3
As3=Asm(11:17);
Am3=Amd(11:17);
Ag3=Alg(11:17);

%x = [0 112 355]; days since Sp21 fieldwork (3/25/21)
x = [217 329 572];%days since fire (8/20/20)

As=[As1 As2 As3]; %recombine epoch data...
Am=[Am1 Am2 Am3]; %epoch2 
Ag=[Ag1 Ag2 Ag3]; %epoch 3

% %filtering A option
if Afilt==1
    As((As<0.1 & As>-0.1))=NaN;
    Am((Am<0.1 & Am>-0.1))=NaN;
    Ag((Ag<0.1 & Ag>-0.1))=NaN;
end

%resort by aspect 
%in general 1-3 N facing 4-7 S facing, for e1 1-3 S (only S)
%A is already sorted: columns are epochs, rows are sites. 
%In A the sizes are sort of blocks that are 7x3 
AsN = As(1:3,:); AsS = As(4:7,:);
AmN = Am(1:3,:); AmS = Am(4:7,:);
AgN = Ag(1:3,:); AgS = Ag(4:7,:);

set(gca,'fontname','times','fontsize',11);

for slope=1:2 
    
    if slope==1 %NFS on first row 
        As=AsN; Am=AmN; Ag=AgN; q=0; tx=' NFS';
    elseif slope==2 %SFS on second row 
        As=AsS; Am=AmS; Ag=AgS; q=3; tx=' SFS';
    end
    A=[As;Am;Ag];
    nexttile(1+q)

if mmf==1   
    meanp=plot(x,nanmean(As),'linewidth',3,'color',colors{Afilt+1},'linestyle',linestyles{Afilt+1});
elseif mmf==2
    medp=plot(x,nanmedian(As),'linewidth',3,'color',colors{Afilt+1},'linestyle',linestyles{Afilt+1});
end
if Afilt==1
    yline(0,'--')
end
    ylim([-1 1.5])
    xlim([200 600])
    if mmf==1 && method==2 && q==0
         legend('M1 mean','M2 mean','fontsize',12,'Location','northwest');
    elseif mmf==2 && method==2 && q==0
         legend('Median','fontsize',12,'Location','northwest');
    end

    set(gca,'fontname','times','fontsize',11)
    title(strcat('Small',tx),'fontsize',14);
    ylabel('A','fontsize',14,'fontweight','bold')
    hold on
    
nexttile(2+q)
if mmf==1   
    meanp=plot(x,nanmean(Am),'linewidth',3,'color',colors{Afilt+1},'linestyle',linestyles{Afilt+1});
elseif mmf==2
    medp=plot(x,nanmedian(Am),'linewidth',3,'color',colors{Afilt+1},'linestyle',linestyles{Afilt+1});
end
if Afilt==1
    yline(0,'--')
end
    ylim([-1 1.5])
    xlim([200 600])
    set(gca,'fontname','times','fontsize',11)
        title(strcat('Medium',tx),'fontsize',14);
    if q==3
        xlabel('Days Since Fire','fontsize',14,'fontweight','bold')
    end
    hold on
    
nexttile(3+q)
if mmf==1   
    meanp=plot(x,nanmean(Ag),'linewidth',3,'color',colors{Afilt+1},'linestyle',linestyles{Afilt+1});
elseif mmf==2
    medp=plot(x,nanmedian(Ag),'linewidth',3,'color',colors{Afilt+1},'linestyle',linestyles{Afilt+1});
end
if Afilt==1
    yline(0,'--')
end
    ylim([-1 1.5])
    xlim([200 600])
    set(gca,'fontname','times','fontsize',11)
    title(strcat('Large',tx),'fontsize',14);
    hold on
end
end
nexttile(1)
if mmf==2
    leg=legend('Median: All A','Median: |A|>0.1','fontsize',12,'fontname','times');
elseif mmf==1
    leg=legend('Mean: All A','Mean: |A|>0.1','fontsize',12,'fontname','times');
end
  print('Evolution_Of_A' ,'-dpng', '-r400')