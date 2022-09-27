N=100;
load('thresholds_unpinned.mat');
sW_corr=[];
for sW=10:10:100
    %sW=thresholds(temp,1)
    load(sprintf('binnedspikes_ising/sW %d.mat',sW));
%     c=zeros(1,N);
%     for i=1:1000%size(binnedspikes,1)-1
%         c=c+mycxcorr(binnedspikes(i,:),binnedspikes(i+1,:));
%     end
    m=meancoupling_noshift(corrcoef(binnedspikes));
    m(1)=0;
    %m=[m(2:end),0];
    y=fft(m);
    power = y.*conj(y);
    %power=power(2:end);
    power=power/sum(power);
    patt_power=sum(power(5:4:end));
    %corr=patt_power;
    corr=patt_power-(1-patt_power)*24/(100-24)
    %corr=sum(power(5:4:end))/sum(power)-1/numel(power(5:4:end));
    %corr=(power(5)+power(97))/sum(power)
%     m(1)=NaN;

    figure;
    subplot(2,1,1);
    plot(m);    
    %c=mycxcorr(m,m);
    subplot(2,1,2);
    plot(power/sum(power));
    
%     plot(c)    
%     xlabel('Shift');
%     ylabel('Correlation');
%     title('Circular autocorrelation');
%     corr=mean([c(26),c(51),c(76)])
    %corr=mean([m(26),m(51),m(76)]);
    sW_corr=[sW_corr; [sW,corr]];
end
figure
plot(sW_corr(:,1),sW_corr(:,2),'-o');