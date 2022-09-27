set(0,'DefaultFigureWindowStyle','docked');
load('thresholds.mat');
meanentropylist=[];
for temp=12
    sW=thresholds(temp,1);
    load(sprintf('binnedspikes100_1e8/sW %.3f.mat',thresholds(temp,1)));
    binnedspikes=logical(binnedspikes);
    entropylist=[];
    for col=2:100
        entropylist=[entropylist, entropy(binnedspikes(:,col))];
    end
    meanentropylist=[meanentropylist; [sW, mean(entropylist)]];
end
plot(meanentropylist(:,1),meanentropylist(:,2),'-o');
xlabel('Weight strength \omega');
ylabel('Mean entropy of spike channels');