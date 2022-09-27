N=100;
load thresholds_unpinned
load W100
load logreg_sweep_lambdas_new %logreg_up_sweep_lambdas
load logreg_sweepdata_new
%load('logisticsweep_data.mat');
addpath(genpath('L1General'));
%logreg_sweepdata=struct;
dataindex=numel(logreg_sweepdata)+1;
for i=11%size(thresholds,1)
    sW=thresholds(i,1);
    load(sprintf('binnedspikes_dyn_glm/sW %.4f.mat',sW));
    %binnedspikes=sign(binnedspikes);
    %binnedspikes=standardizeCols(binnedspikes);
    binnedspikes=binnedspikes-repmat(mean(binnedspikes), [size(binnedspikes,1),1]); %mean-subtract
    for lambda=sweep_lambdas(i).lambdas        
        J=logreg_fullJ(binnedspikes,lambda);        
        [err,var_err,bias_err]=inference_error(J,W);
        logreg_sweepdata(dataindex).sW=sW;
        logreg_sweepdata(dataindex).lambda=lambda;
        logreg_sweepdata(dataindex).J=J;
        logreg_sweepdata(dataindex).err=err;
        logreg_sweepdata(dataindex).var_err=var_err;
        logreg_sweepdata(dataindex).bias_err=bias_err;
        save logreg_sweepdata_new.mat logreg_sweepdata
        dataindex=dataindex+1;
    end
end
