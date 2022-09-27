%   cd('/media/abhranil/Data/Academics/Neuroscience');
%   cd('~/Desktop/logistic_regression');

load thresholds
load W100
ac=W(51,3:end);
ac=(ac-min(ac(:)))./(max(ac(:))-min(ac(:)))-1; %rescaling actual couplings between -1 and 0

N=100;
logisticsweep=[];
%i=1;

% set(gca, 'ColorOrder', varycolor(21));
% hold all;

for temp=3%1:size(thresholds,1)
    sW=thresholds(temp,1);
    load(sprintf('binnedspikes100/sW %.3f.mat',thresholds(temp,1)));
    %Remove pinned node
    spikes=binnedspikes(:,2:end);
    %Standardize data
    spikes=standardizeCols(spikes);
    node=50;
    y=spikes(:,node);
    x=spikes(:,1:end~=node); 
    for lambda=0:20:100
        lc=logreg(x,y,lambda);
        %scale keeping minimum same
        if min(lc)<0
            lc=lc/abs(min(lc));
        end
        %scale between same limits
%         if max(lc)>min(lc)
%             lc=(lc-min(lc))./(max(lc)-min(lc))-1;
%         end
        err=norm(ac-lc,1);
        figure
        plot(ac);
        hold on
        plot(lc);
        hold off        
        title(sprintf('%.3f %f %f',[sW, lambda, err]));
        %print(sprintf('sweep/sweep%d.png',i),'-dpng');
        logisticsweep=[logisticsweep; [sW, lambda, err]];
        i=i+1;
        %save logisticsweep_data_test.mat logisticsweep
    end
    
end

figure
plot3(logisticsweep(:,1),logisticsweep(:,2),logisticsweep(:,3),'.')
%set(gca, 'yscale', 'log');
