load W100
load thresholds_unpinned
inference_data=struct;
for i=1:11
    sW=thresholds(i,1)
    load(sprintf('binnedspikes_dyn_glm/sW %.4f.mat',sW));
    J=mf_ba(binnedspikes);
    [err,var_err,bias_err]=inference_error(J,W);
    
    inference_data(i).sW=sW;
    inference_data(i).spike_count=sum(binnedspikes(:));
    inference_data(i).J=J;
    inference_data(i).err=err;
    inference_data(i).var_err=var_err;
    inference_data(i).bias_err=bias_err;
end