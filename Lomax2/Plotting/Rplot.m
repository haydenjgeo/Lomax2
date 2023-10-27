%plot empirical and fitted R(x) with annotations showing A, B, B/|A| and
%all estimated error values. Each plot corresponds to 1/7 sites. 

%Written by Hayden Jacobson, Colorado School of Mines, September 2023
%Utilizes portions of code written by Danica Roth, Colorado School of Mines, May 2019

clear all
close all

%% define anon. functions and set options
col = @(x) reshape(x,[numel(x),1]); %anonymous function to reshape into columns
DC=@(C) deal(C{:});

ns=7; %number of sites
nr=3; %number of grain sizes

Xfit=@(xmax) 0.001:0.001:xmax;
Rfitopt=@(x,s,r)(1+(A_opt(s,r).*(x-0.01)./B_opt(s,r))).^(-1./A_opt(s,r));

m=0; %method 

for scs=1:7%manual numsites, 7 figures
    sc=scs;
    if sc>4 %S sites are 5,6,7
        ci=3;
        f=figure(sc);
        f.Position = [0 0 900,900];
    else
        ci=2;
        f=figure(sc);
        f.Position = [0 0 900,600];
        %add anything specific to the 2x3 subplots here if you want
    end
    
    for eps=1:ci %make this loop more efficient, reduce counter in loop 
        if eps==1 
                load(sprintf('results%d.mat',3));%-eps+1)); %spring 2022 on top 
                load(sprintf('bootstrap%d.mat',3));
            elseif eps==2           
                load(sprintf('results%d.mat',2));  %then summer 2021
                load(sprintf('bootstrap%d.mat',2));
            elseif eps==3 && ci==3         
                load(sprintf('results%d.mat',1));  %spring 2021 if data avail
                load(sprintf('bootstrap%d.mat',1));
        end
        
        if scs>4 && eps==3
            sc=scs-4;
        end

    for r=1:3 %number of rock sizes counter 
        idk = subplot(ci,nr,r+nr*(eps-1));
        box on 
        hold on
        pos = get(idk, 'position');
       
        %format annotation positions 
        if ci==2
            if (r+nr*(eps-1))<4
              dim = pos+[0 .2 0 0];
            else
              dim = pos+[0 .22 0 0]; 
            end
        elseif ci==3
            if (r+nr*(eps-1))<4
               dim = pos+[0 .12 0 0]; %top row 
            elseif (r+nr*(eps-1))>6 
              dim = pos+[0 .137 0 0]; %bottom row (oldest)
            else
               dim = pos+[0 .127 0 0]; %middle row 
            end
        end
        if scs==7 && ((r+nr*(eps-1))==3 || (r+nr*(eps-1))==6|| (r+nr*(eps-1))==9)%manual override for site S39 
            dim = pos+[0 (r+nr*(eps-1))/200 0 0]; %just happens to work out 
        end
            

        %plot empirical and fitted R(x)
        scatter(X{sc,r},R{sc,r},40,'k','o');
        semilogy(Xfit(max(X{sc,r}(X{sc,r}<CensorPoint(sc,r)))),Rfitopt(Xfit(max(X{sc,r}(X{sc,r}<CensorPoint(sc,r)))),sc,r),'r','linewidth',1.5);     
        set(gca,'yscale','log','xscale','linear','ylim',[.004 1],'xlim',[0 CensorPoint(sc,1)*1.1],'fontsize',11);
        fitparamsopt{sc,r}=['A = ',num2str(A_opt(sc,r),'%.2f'),'\pm',num2str(Ase(sc,r),'%.2f'),newline,'B = ',num2str(B_opt(sc,r),'%.2f'),'\pm',num2str(Bse(sc,r),'%.2f'),...
        newline,'B/|A| = ',num2str(abs(xr(sc,r)),'%.2f'),'\pm',num2str(xrse(sc,r),'%.2f'),];       
            if (r+nr*(eps-1))==9 && scs==5 %delete sp21 S21 L (placeholder)
                delete(idk);
                fitparamsopt{sc,r}=[];
            end
        annotation('textbox','String',fitparamsopt{sc,r},'Position',dim,'vert','bottom','horiz','right','fitboxtotext','on','linestyle','none','fontname','times','fontsize',11);


        fs=14; %x and y label font size
        fs2=20; %title size 
        if r+nr*(eps-1)==1
            ylabel('Spring 2022 R(x)','fontsize',fs)
            title('Small','fontsize',fs)
        end
        if r+nr*(eps-1)==2
            title('Medium','fontsize',fs)
        end
        if r+nr*(eps-1)==3
            title('Large','fontsize',fs)
        end
        
        if r+nr*(eps-1)==4 
            ylabel('Summer 2021 R(x)','fontsize',fs)
        end
        if r+nr*(eps-1)==5 && ci==2
            xlabel('Travel Distance (m)','fontsize',fs)
        end
        if r+nr*(eps-1)==7 
            ylabel('Spring 2021 R(x)','fontsize',fs)
        end
        if r+nr*(eps-1)==8 && ci==3
            xlabel('Travel Distance (m)','fontsize',fs)
        end
        
        if sc == 4
            sgtext=('S30: R(x) vs. Distance (m)');
        else
            sgtext=(convertCharsToStrings(site{sc}) + ': R(x) vs. Distance (m)');
        end
        sgtitle(sgtext,'fontname','Times','fontweight','bold','fontsize',fs2)
        set(gca,'fontname','times')%,'fontsize',12)
    end
end
txt = (convertCharsToStrings(site{sc}) + '_R(x)');
set(gcf, 'PaperSize', [8.5 11]);
print(txt,'-dpng', '-r400') 
    
end
