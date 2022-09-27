load('thresholds.mat');
patterncurve=[];
for temp=1:size(thresholds,1)
    load(sprintf('binnedspikes/sW %.3f.mat',thresholds(temp,1)));
    run('autocorrelation.m');
    patterncurve=[patterncurve; [thresholds(temp,1), corr]];
end
figure
plot(patterncurve(:,1),patterncurve(:,2),'-o');