dt=.0001;
N=100;
binsize=100;
load('thresholds.mat');

w_spikes=[];
for temp=[2 6 8 9 10 12 17 20 21 22 23]
    sW=thresholds(temp,1);
    load(sprintf('binnedspikes100_1e8/sW %.4f.mat',sW));
    orig_spikecount=size(binnedspikes,1)*(N-1)*binsize*dt/.016;
    w_spikes=[w_spikes;[sW,(orig_spikecount-sum(binnedspikes(:)))/orig_spikecount]];
end

figure
plot(w_spikes(:,1)/2,w_spikes(:,2),'-o');
ylim([0 1]);
set(gca,'YTickLabel',{'0%','50%','100%'})
xlabel('Weight strength \omega');
ylabel('% spikes discarded');