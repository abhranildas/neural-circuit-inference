N=100;
max_lag=100;
lags_binned=(-max_lag:max_lag)*3/100;

load W_rand_sparse
load thresholds_rand_sparse
%load inference_data_rand_sparse_glm
inference_data=struct;
dataindex=size(inference_data,2)+1;

% for data demand
%load dyn_glm_data_demand_points_new

% for 50% subsampling
%load inference_data_dyn_glm_subsampling_50pc % load subindex
% Nsub=50; subindex=randsample(N,Nsub)';

for i=1:7    
    sW=thresholds(i,1);    
    load(sprintf('binnedspikes_rand_sparse/sW %.3f.mat',sW));
    binnedspikes0=cast(bin(binnedspikes,3,0,0),'single');
    
    maxdatasize=size(binnedspikes0,1);    
    for datasize=round(maxdatasize*10.^(-.25:-.25:-5))
        binnedspikecountlist=[];
        Rlist=[];
        Zlist=[];
        Blist=[];
        %Jlist=[];
        %err_list=[];
        %var_err_list=[];
        %bias_err_list=[];
        for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
            fprintf('sW: %.4f, data fraction: %.1e, startpoint: %.1f\n', [sW,datasize/maxdatasize,startpoint/(maxdatasize-datasize+1)])
            binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
            binnedspikecount=sum(binnedspikes(:));
            binnedspikecountlist=[binnedspikecountlist,binnedspikecount];
            
            R=spike_ccg(binnedspikes,max_lag);
            [Z,B]=ccg_graph(R);
            
            % for 50% subsampling
            %J_expanded=nan(N);
            %J_expanded(subindex,subindex)=J;
            %J=J_expanded;
            %err=finderror_lsq(100,W,J,'full',2);
            
            Rlist=cat(4,Rlist,R);
            Zlist=cat(3,Zlist,Z);
            Blist=cat(3,Blist,B);
            %Jlist=cat(3,Jlist,J);            
            %[err,var_err,bias_err,alph]=inference_error(J,W);
            %err_list=[err_list,err];
            %var_err_list=[var_err_list,var_err];
            %bias_err_list=[bias_err_list,bias_err]; 
        end
        
        inference_data(dataindex).sW=sW;
        inference_data(dataindex).meanspikecount=mean(binnedspikecountlist);
        inference_data(dataindex).spikecounts=binnedspikecountlist;
        inference_data(dataindex).Rlist=Rlist;
        inference_data(dataindex).Zlist=Zlist;
        inference_data(dataindex).Blist=Blist;
        
%         inference_data_sync(dataindex).err_list=err_list;
%         inference_data_sync(dataindex).err_mean=mean(err_list);
%         inference_data_sync(dataindex).err_sem=std(err_list)/sqrt(numel(err_list));
        
%         inference_data(dataindex).var_err_list=var_err_list;
%         inference_data(dataindex).var_err_mean=mean(var_err_list);
%         inference_data(dataindex).var_err_sem=std(var_err_list)/sqrt(numel(var_err_list));
%         
%         inference_data(dataindex).bias_err_list=bias_err_list;
%         inference_data(dataindex).bias_err_mean=mean(bias_err_list);
%         inference_data(dataindex).bias_err_sem=std(bias_err_list)/sqrt(numel(bias_err_list));
        
        dataindex=dataindex+1;
        save('inference_data_rand_sparse_sync.mat', 'inference_data', 'lags_binned','-v7.3');
    end 
end