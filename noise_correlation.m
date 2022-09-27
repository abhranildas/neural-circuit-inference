 load('thresholds_unpinned.mat');
for temp=1:11
    sW=thresholds(temp,1)
    load(sprintf('binnedspikes_pinned/sW %.4f.mat',sW));
    binnedspikes=binnedspikes(:,2:end);
    binnedspikes=standardizeCols(binnedspikes);
    figure
    C=corrcoef(binnedspikes);
    r_sc=mean(C(~tril(ones(size(C)))))
end

%% Noise correlation of similarly-tuned neurons (unpinned)
load('thresholds_unpinned.mat');
noise_corr=[];
for temp=1:11
    sW=thresholds(temp,1)
    load(sprintf('binnedspikes_unpinned/sW %.4f.mat',sW));
    binnedspikes=standardizeCols(binnedspikes);    
    C=corrcoef(binnedspikes);
    C(logical(eye(size(C))))=NaN;
    r_sc_list=meancoupling(C);
    figure;
    plot(r_sc_list);
    r_sc=mean(r_sc_list([1 26 76]));
    noise_corr=[noise_corr;[sW,r_sc]];
end
figure
plot(noise_corr(:,1),noise_corr(:,2),'-o')

%% Noise correlation of similarly-tuned neurons (pinned)
load('thresholds_unpinned.mat');
noise_corr=[];
for temp=1:11
    sW=thresholds(temp,1)
    load(sprintf('binnedspikes_unbinarized_pinned/sW %.4f.mat',sW));
    binnedspikes=binnedspikes(:,2:end);
    %binnedspikes=standardizeCols(binnedspikes);    
    C=corrcoef(binnedspikes);
    C(logical(eye(size(C))))=NaN;
    r_sc_list=meancoupling(C);
    figure;
    plot(-50:48,r_sc_list);
    set(gca,'Fontsize',13);
    xlabel 'Neuron spacing'
    %ylabel('Avg. noise correlation');
    r_sc=mean(r_sc_list([1 26 76]));
    noise_corr=[noise_corr;[sW,r_sc]];
end
figure
plot(noise_corr(:,1),noise_corr(:,2),'-o')
%% Avg. abs noise correlation of all neuron pairs (pinned)
set(0,'DefaultFigureWindowStyle','docked');
load('thresholds_unpinned.mat');
noise_corr=[];
for temp=1:11
    sW=thresholds(temp,1)
    load(sprintf('binnedspikes_unbinarized_pinned/sW %.4f.mat',sW));
    binnedspikes=binnedspikes(:,2:end);
    %binnedspikes=standardizeCols(binnedspikes);    
    C=corrcoef(binnedspikes);
    abs_noise_corr_list=abs(C(~tril(ones(size(C)))));
    figure;
    h=histogram(abs_noise_corr_list,100,'FaceColor',[.5 .5 .5],'FaceAlpha',1,'EdgeColor',[.5 .5 .5], 'LineWidth',1);
    xlim([0 .6]);
    ylim([0 max(h.Values)*1.5]);
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(gca,'Visible','off');    
    ax = gca;
    outerpos = ax.OuterPosition;
    ti = ax.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4) - ti(2) - ti(4);
    ax.Position = [left bottom ax_width ax_height];
    r_sc=mean(abs_noise_corr_list);
    noise_corr=[noise_corr;[sW,r_sc]];
end
figure
plot(noise_corr(:,1),noise_corr(:,2),'Marker', '.','Color','k','LineWidth',2,'MarkerSize',25);
xlim([-.0025 .025]);
ylim([0 .6]);
ylabel 'Noise correlation'
set(gca,'Fontsize',13);
box off

%% Noise correlation of example neuron pairs against observation duration (pinned)
load('thresholds_unpinned.mat');
for temp=7
    noise_corr=[];
    sW=thresholds(temp,1);
    for datapart=10.^(-3.5:.1:0)
        load(sprintf('binnedspikes_unbinarized_pinned/sW %.4f.mat',sW));
        binnedspikes=binnedspikes(1:round(size(binnedspikes,1)*datapart),2:end);
        %binnedspikes=standardizeCols(binnedspikes);    
        C=corrcoef(binnedspikes(:,25),binnedspikes(:,40));
        r_sc=C(1,2);
        noise_corr=[noise_corr;[round(size(binnedspikes,1)*datapart)*10,r_sc]];
    end
    figure
    plot(noise_corr(:,1),noise_corr(:,2),'-o')
    set(gca, 'xscale', 'log');
    set(gca,'Fontsize',13);
    ylabel('Noise correlation');
    xlabel('Duration')
end