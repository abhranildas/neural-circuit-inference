load thresholds_rand_sparse
max_lag=300;
lags=(-max_lag:max_lag)/100;
for sW_idx=[7 2 1 6 3 4 5]
    sW_idx    
    sW=thresholds(sW_idx,1);
    load(sprintf('binnedspikes_rand_sparse/sW %.3f.mat',sW));
    R=spike_ccg(binnedspikes,max_lag);
    save(sprintf('synchrony_inference_rand_sparse/spike_ccg/sW %.3f.mat',sW),'R');
end