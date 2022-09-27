N=100;
load('thresholds_unpinned.mat');
sW_corr=[];
for temp=1:11
    sW=thresholds(temp,1);
    load(sprintf('binnedspikes_pinned/sW %.4f.mat',sW));
    m=mean(binnedspikes(:,2:end));
    figure();
    subplot(2,1,1);
    plot(m);
    xlim([1 N]);
    xlabel('Neuron number');
    ylabel('Fraction of spikes');
    title(sprintf('Activity (mean spiking=%f)',sum(m)));
    %m=m-mean(m);
    [c,x]=mycxcorr(m,m);
    subplot(2,1,2);
    plot(x,c);
    xlim([0 N]);
    xlabel('Shift');
    ylabel('Correlation');
    title('Circular autocorrelation');
    corr=mean([c(25),c(50),c(75)]);
    sW_corr=[sW_corr; [sW,corr]];
end
figure
plot(sW_corr(:,1),sW_corr(:,2),'-o');