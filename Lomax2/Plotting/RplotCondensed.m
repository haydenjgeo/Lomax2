%Plot all optimized travel distance exceedance R(x) fits created with ssepareto

%Written by Hayden Jacobson, Colorado School of Mines, September 2023
%Utilizes portions of code written by Danica Roth, Colorado School of Mines, May 2019

%% set up anon. functions: x-vector for plotting, R(x) fit 
clear all
close all

Xfit=@(xmax) 0.001:0.001:xmax; %produces evenly spaced vector of X values for plotting R(x)
Rfitopt=@(x,a,b)(1+a.*(x-0.01)./b).^(-1./a); %calculated R(x) at Xfit values (x) 

%need A_opt, B_opt, X, censorpoint from results
r1=load(sprintf('results%d.mat',1));
r2=load(sprintf('results%d.mat',2));
r3=load(sprintf('results%d.mat',3));


%plot colors 
%these correspond to dark, moderate, light blue colors 
color1=[1 12 90]/256;
color2=[89 109 156]/256;
color3=[190 205 232]/256;



for s=1:7 %sites 1-4 are 2 epoch, 5-7 are 3 epoch, 1-3 N 4-7 S
%pull site data from each epoch 
%order of sites epoch 1: {'S21','S26','S39'}
%order of sites epoch 2/3: {'N26','N30','N33','R30','S21','S26','S39'}
%need A_opt, B_opt, X, censorpoint from results

if s==1
f=figure;
f.Position = [0 0 700 600];
t=tiledlayout(3,3); 
x1 = xlabel(t,'Travel Distance (m)','fontsize',14,'fontname','times','fontweight','bold');
x1.FontWeight = 'bold';
end
if s==4
f=figure;
f.Position = [0 0 700 750];
t=tiledlayout(4,3);
x2 = xlabel(t,'Travel Distance (m)','fontsize',14,'fontname','times');
x2.FontWeight = 'bold';
end

sizes = {'Small' 'Medium' 'Large'};  

for r=1:3      
    if s<5 %only epochs 2 & 3
        A2=r2.A_opt(s,r);        A3=r3.A_opt(s,r);
        B2=r2.B_opt(s,r);        B3=r3.B_opt(s,r);
        X2=r2.X{s,r};            X3=r3.X{s,r};
        C2=r2.CensorPoint(s,r);  C3=r3.CensorPoint(s,r); 
        X1=0; C1=0.1; %for setting x lim in plotting code 
    else %adjust epoch 1 index to reflect missing sites (4) 
        A1=r1.A_opt(s-4,r);        A2=r2.A_opt(s,r);        A3=r3.A_opt(s,r);
        B1=r1.B_opt(s-4,r);        B2=r2.B_opt(s,r);        B3=r3.B_opt(s,r);
        X1=r1.X{s-4,r};            X2=r2.X{s,r};            X3=r3.X{s,r};
        C1=r1.CensorPoint(s-4,r);  C2=r2.CensorPoint(s,r);  C3=r3.CensorPoint(s,r);
    end    
    
    %assign data to correct tile
    if s<4 %NFS
        nexttile(s*3-3+r); q=s*3-3; %q saves tile location for axes setting later
    elseif s==4 %R30/S30 3rd row
        nexttile((s-1)*3-3+r); q=(s-1)*3;
    elseif s==5 || s==6 %S21 1st row, s26 2nd row
        nexttile((s-4)*3-3+r); q=(s-4)*3-3;
    elseif s==7 %S39
        nexttile((s-3)*3-3+r); q=(s-3)*3-3;
    end
    hold on
    
    
    if q==0 && s==1
        plot(NaN,NaN,'color',color2,'linewidth',2)
        plot(NaN,NaN,'color',color3,'linewidth',2)
    elseif q==0 && s==5   
        plot(NaN,NaN,'color',color1,'linewidth',2)
        plot(NaN,NaN,'color',color2,'linewidth',2)
        plot(NaN,NaN,'color',color3,'linewidth',2)
    end
    
    
    %add x labels and set up axes
    if r==1 && s~=4
        ylabel(strcat("R(x) ",char(r2.sites(s))),'fontsize',14,'fontname','times','fontweight','bold')
    elseif r==1 && s==4
        ylabel("R(x) S30",'fontsize',14,'fontname','times','fontweight','bold');
    end
    
    set(gca,'yscale','log','xscale','linear','ylim',[.004 1],'fontsize',11,'fontname','times');
    
    
    
    %label upper row of plots with S/M/L
    if s==1
        title(sizes{r},'fontsize',14,'fontname','times')
    end   
    if s==5
        title(sizes{r},'fontsize',14,'fontname','times')
    end
    
    
    if s<4
        %do nothing
    elseif s==5 && r==3%don't plot large grains for SP21, S21. False placeholder data. 
         plot(NaN,NaN,'r','linewidth',2);
    elseif s>4
        if A1>0
            plot( Xfit(max(X1(X1<C1))), Rfitopt(Xfit(max(X1(X1<C1))),A1,B1),'color',color1,'linewidth',2);
        elseif A1<0
            plot( Xfit(max(X1(X1<C1))), Rfitopt(Xfit(max(X1(X1<C1))),A1,B1),'color', color1,'linewidth',2,'linestyle','--')
        end
    end
    
    if A2>0
        plot( Xfit(max(X2(X2<C2))), Rfitopt(Xfit(max(X2(X2<C2))),A2,B2), 'color',color2,'linewidth',2)
    elseif A2<0   
        plot( Xfit(max(X2(X2<C2))), Rfitopt(Xfit(max(X2(X2<C2))),A2,B2), 'color', color2,'linewidth',2,'linestyle','--')
    end
    
    if A3>0  
        plot( Xfit(max(X3(X3<C3))), Rfitopt(Xfit(max(X3(X3<C3))),A3,B3), 'color',color3,'linewidth',2)
    elseif A3<0
        plot( Xfit(max(X3(X3<C3))), Rfitopt(Xfit(max(X3(X3<C3))),A3,B3), 'color',color3,'linewidth',2,'linestyle','--')
    end
    

end

if s==1
nexttile(1)
leg=legend('SU 21','SP 22','fontsize',12,'location','northeast','fontname','times');
txt='NFS_Rx';
end

if s==7
nexttile(1)
leg=legend('SP 21','SU 21','SP 22','fontsize',12,'location','northeast','fontname','times');
txt='SFS_Rx';
end

for t=1:3
nexttile(q+t)
xlim([0     max([max(X1(X1<C1)) max(X2(X2<C2)) max(X3(X3<C3))])+0.2]);
end


if s==3 || s==7
    set(gcf, 'PaperSize', [8.5 11]);
    print(txt,'-dpng', '-r400')
end

end





    