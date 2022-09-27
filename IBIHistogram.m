%N*size(binnedspikes,1)*dt*1000/sum(binnedspikes(:))

IBIlist=[];
meanIBIlist=zeros(1,N);
for col=2:N
    IBIs=diff(find(binnedspikes(:,col)));
    IBIlist=cat(1, IBIlist, IBIs);
    meanIBIlist(col)= mean(IBIs);
end

%Measure intervals in ms:
IBIlist=IBIlist*dt*1000;
meanIBIlist=meanIBIlist*dt;
figure(1);
subplot(2,1,1);
plot(meanIBIlist.^-1,'-o');
xlabel('Neurons');
ylabel('Mean spiking Frequency (Hz)');
xlim([2 N]);
title('Mean Spiking Frequencies');
subplot(2,1,2);
hist(IBIlist,10000);
xlabel('Interspike interval (ms)');
ylabel('Frequency');
title(sprintf('Interspike interval histogram (over all neurons)\n%d spikes, Min: %.1fms, Max: %.1fms, Mean: %.2fms', [nnz(binnedspikes),min(IBIlist),max(IBIlist),mean(IBIlist)]));
% subplot(3,1,3);
% meanIBIlist(isnan(meanIBIlist))=[];
% [acor,lag]=cxcorr(meanIBIlist);
% plot(lag,acor);
% autoc=acor(61);
clear IBIs IBIlist col