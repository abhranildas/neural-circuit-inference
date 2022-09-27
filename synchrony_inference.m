load thresholds_rand_sparse
max_lag=100;
lags_binned=(-max_lag:max_lag)*3/100;
for sW_idx=[7 2 1 6 3 4 5]
    sW_idx    
    sW=thresholds(sW_idx,1);
    load(sprintf('binnedspikes_rand_sparse/sW %.3f.mat',sW));
    binnedspikes=cast(binnedspikes,'single');
    binnedspikes=bin(binnedspikes,3,0,0);
    %binnedspikes=binnedspikes(1:6e7,:);
    R=spike_correlations(binnedspikes,max_lag);
    save(sprintf('synchrony_inference_rand_sparse/spike_correlations_bin_3/sW %.3f.mat',sW),'R');
end

lags=(-max_lag:max_lag)/100;

[R_mat, I_mat]=max(abs(R),[],3);

lags_mat=lags(I_mat);

bin=abs(lags(I_mat))<1;

R_max=zeros(100);
for i=1:100
    for j=1:100
        R_max(i,j)=R_smooth(i,j,I_mat(i,j));
        [i j]
    end
end

% smoothen CCG's using moving average
R_smooth=zeros(100,100,2*max_lag+1);
for i=1:100
    for j=1:100
        R_smooth(i,j,:)=movmean(R(i,j,:),10);
        [i j]
    end
end

[R_mat, I_mat]=max(abs(R_smooth),[],3);

lags_mat=lags(I_mat);

bin=abs(lags(I_mat))<1;