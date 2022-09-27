load W100
W(logical(eye(size(W))))=nan;
Wmean=meancoupling(W);
Wmean=Wmean(~isnan(Wmean));
load inference_data_dyn_glm_new %unpinned_inf_full 
N=100;
r=[]; var_errs=[]; bias_errs=[];
for i=find([inference_data.meanspikecount]>9e7)
    J=inference_data(i).Jlist;
    r=[r;inference_data(i).sW];
    var_errs=[var_errs; variance_error(J,W)];
    bias_errs=[bias_errs; bias_error(J,W)];
end

%bias_to_var_ratio=atan(bias_errs./var_errs)/(pi/2);
save('variance_bias_errors_dyn_glm.mat','r','var_errs','bias_errs')