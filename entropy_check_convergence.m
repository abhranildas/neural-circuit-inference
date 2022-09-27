sW=.05;
load(sprintf('binnedspikes100_1e8/sW %.3f.mat',sW));
SubLength=99;%round(log2(size(States,1)))
totsamp=size(binnedspikes,1);
entlist=[];
for nsamp=round(totsamp/10):round(totsamp/10):totsamp
    nsamp
    States=logical(binnedspikes(1:nsamp,2:end));
    shannon_list=[];
    for i=1
        %SubStates=datasample(States,SubLength,2,'Replace',false);
        StartCol=1;%:10:size(States,2)
        SubStates=States(:,mod(StartCol-1:StartCol+SubLength-2,size(States,2))+1);
        [UniqueSubStates, ~, idx]=unique(SubStates,'rows');
        counts=histc(idx,1:size(UniqueSubStates,1));
        shannon_list=[shannon_list; shannon_entropy(counts)];
    end
    entlist=[entlist; [nsamp,nanmean(shannon_list),nanstd(shannon_list)]];
end
figure
%errorbar(entlist(:,1),entlist(:,2),entlist(:,3),'-o');
plot(entlist(:,1),entlist(:,2),'-o');