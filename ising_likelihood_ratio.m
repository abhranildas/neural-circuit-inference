load inference_ising_ising.mat
load thresholds_unpinned.mat
%load inference_data_up_maxdata.mat
load W100.mat
%J=inference_data(3).Jnew;
p_ratio=[];
for sW=10:10:90;%temp=1:11;
    %sW=thresholds(temp,1)
    %J=inference_data(find([inference_data.sW]==sW,1)).Jnewlist;
    %J=inference_data(temp).Jnew;
    J=sW*W;
    load(sprintf('binnedspikes_ising_5e4/sW %.d.mat',sW));
    %load(sprintf('binnedspikes_unpinned/sW %.4f.mat',sW));
    sum1=sum(dot(binnedspikes*J,binnedspikes,2));
    load(sprintf('binnedspikes_ising_5e4_sb/sW %.d.mat',sW));
    %load(sprintf('binnedspikes_up_sb/sW %.4f.mat',sW));
    sum2=sum(dot(binnedspikes*J,binnedspikes,2));
    p_ratio=[p_ratio;[sW,sum1-sum2]];
end
plot(p_ratio(:,1),p_ratio(:,2),'-o');