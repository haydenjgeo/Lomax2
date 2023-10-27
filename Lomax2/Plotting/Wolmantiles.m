% plots all Wolman Count data for epcohs 1-3

% Written by Hayden Jacobson, Colorado School of Mines, September 2023

close all
clear all

w{1}=[csvread('WolmanCounts/e1.csv') NaN(111,1)]; %add one empty columns for channel 
w{2}=csvread('WolmanCounts/e2.csv');
w{3}=csvread('WolmanCounts/e3.csv');

for i=1:3
    w{i}(w{i}==0)=NaN; %fill 0s with NaNs
end

%% get matrix with: median, min, max, std dev, N for all Wolman counts
ww=w;
tb=[]; %initialize matrix 

for position=0:6 % (0 m to 50 m + channel, 10 m increments) 
    for epoch=1:3 % some counts not conducted in e1, just fill w NaNs
        tb((position*3+epoch),1) = median(ww{1,epoch}(:,position+1),'omitnan');
        tb((position*3+epoch),2) = min(ww{1,epoch}(:,position+1));
        tb((position*3+epoch),3) = max(ww{1,epoch}(:,position+1));
        tb((position*3+epoch),4) = std(ww{1,epoch}(:,position+1),'omitnan');
        tb((position*3+epoch),5) = length(ww{1,epoch}(:,position+1))-sum(isnan(ww{1,epoch}(:,position+1)));
    end
end
    
%adjust table to respect precision 
%SP 21 0 and 20 m - 1mm (rows 1 and 7)
%SP 21 50 m - 5 mm (row 16)
%all others - 0.01 mm
tb = round(tb,2); %two decimal digits for all values max 
tb([1 7],1:4) = round(tb([1 7],1:4)); % 1 mm precision
tb(16,1:4) = round(tb(16,1:4)/5)*5; % 5 mm precision

%convert bulk statistic values to cm (but not counts in column 5) 
tb(:,1:4)=tb(:,1:4)/10;

% save table to csv file 
writematrix(tb, 'wolmantable.csv')
%% plot
labs={'0 m','10 m','20 m','30 m','40 m','50 m','Channel S','D50 (S, M, L)'};

ti={'Spring 2021','Summer 2021','Spring 2022'};
cr=gray(9);
cr=flip(cr(2:8,:),1);%get rid of white/black and make long distances darker

f=figure;
f.Position = [0 0 900,500];
t = tiledlayout('flow','TileSpacing','compact');
xmaxval=[40 60 40];

for s=1:3 %one subplot for each epoch 
    nexttile

    for c=1:7
        if sum(isnan(w{s}(:,c)))~=length(w{s}(:,c))
            [y,x]=ecdf(w{s}(:,c));
            if c<=6
            plot(x,y,'linewidth',(1.4),'color',cr(c+1,:)) %old width - 1+0.1*c
            else
            plot(x,y,':','linewidth',(1.4),'color',cr(c,:))  
            end
        end
        hold on
    end
    [y2{s},x2{s}]=ecdf(reshape(w{s}(:,1:c), [1, prod(size(w{s}))]));
    set(gca,'fontname','times','fontsize',11) 
    xlabel('Intermediate diameter (mm)','fontsize',14)
    ylabel('% finer','fontsize',14)
    xlim([0 xmaxval(s)])
    ylim([0 1])
    if s==1
        xline(5,'--')
        xline(13,'--')
        xline(27,'--')   
    else
        xline(6,'--')
        xline(13,'--')
        xline(28,'--')
    end
end
%% add legend tile 
ax = nexttile;
p_ax=ax.Position;
hold on
plot(NaN,NaN)

delete(ax)
ax=axes('Position',[p_ax(1:2) 0 0]);
hold on
for c=1:6
    plot(NaN,NaN,'linewidth',(1.4),'color',cr(c+1,:))
end
plot(NaN,NaN,':','linewidth',(1.4),'color',cr(c,:))
 xline(-2,'--')
leg = legend(labs);
% leg.Location = 'none';
leg.FontName = 'times';
leg.FontSize = 13;
ax.Visible = false;
leg.Position=[0.642111109722986,0.109166671435038,0.173111113887363,0.334999990463257]; 

%% annotations (subplot labels) 
annotation('textbox',...
    [0.447666666666667 0.608 0.0267777777777778 0.052],'String','A',...
    'FontSize',12,...
    'FitBoxToText','off');

annotation('textbox',...
    [0.872111111111111 0.608000000000002 0.0267777777777779 0.052],'String','B',...
    'FontSize',12,...
    'FitBoxToText','off');

annotation('textbox',...
    [0.447666666666667 0.128000000000002 0.026777777777778 0.052],'String','C',...
    'FontSize',12,...
    'FitBoxToText','off');

%% print figure 
txt = ('WolmanCounts');
set(gcf, 'PaperSize', [8.5 11]);
print(txt,'-dpng', '-r400')