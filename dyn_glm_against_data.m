load W100
load thresholds_unpinned
%inference_data=struct;
dataindex=size(inference_data,2)+1;
N=100;

% for data demand
%load dyn_glm_data_demand_points_new

% for 50% subsampling
load inference_data_dyn_glm_subsampling_50pc % load subindex
% Nsub=50; subindex=randsample(N,Nsub)';

for i=1:11    
    sW=thresholds(i,1);
    %sW=data_demand_points(i,1); % for data demand
    
    load(sprintf('binnedspikes_dyn_glm/sW %.4f.mat',sW));
    
    %binnedspikes0=binnedspikes;
    binnedspikes0=binnedspikes(:,subindex); % for 50% subsampling
    
    maxdatasize=size(binnedspikes0,1);    
    for datasize=round(maxdatasize*10.^(0:-.25:-5))
        binnedspikecountlist=[];
        Jlist=[];
        err_list=[];
        %var_err_list=[];
        %bias_err_list=[];
        for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
            fprintf('sW: %.4f, data fraction: %.1e, startpoint: %.1f\n', [sW,datasize/maxdatasize,startpoint/(maxdatasize-datasize+1)])
            binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
            binnedspikecount=sum(binnedspikes(:));
            binnedspikecountlist=[binnedspikecountlist,binnedspikecount];
            J=glm_inf_binned(binnedspikes);
            
            % for 50% subsampling
            J_expanded=nan(N);
            J_expanded(subindex,subindex)=J;
            J=J_expanded;
            err=finderror_lsq(100,W,J,'full',2);
            
            Jlist=cat(3,Jlist,J);            
            %[err,var_err,bias_err,alph]=inference_error(J,W);
            err_list=[err_list,err];
            %var_err_list=[var_err_list,var_err];
            %bias_err_list=[bias_err_list,bias_err]; 
        end
        inference_data(dataindex).sW=sW;
        inference_data(dataindex).meanspikecount=mean(binnedspikecountlist);
        inference_data(dataindex).spikecounts=binnedspikecountlist;  
        inference_data(dataindex).Jlist=Jlist;
        
        inference_data(dataindex).err_list=err_list;
        inference_data(dataindex).err_mean=mean(err_list);
        inference_data(dataindex).err_sem=std(err_list)/sqrt(numel(err_list));
        
%         inference_data(dataindex).var_err_list=var_err_list;
%         inference_data(dataindex).var_err_mean=mean(var_err_list);
%         inference_data(dataindex).var_err_sem=std(var_err_list)/sqrt(numel(var_err_list));
%         
%         inference_data(dataindex).bias_err_list=bias_err_list;
%         inference_data(dataindex).bias_err_mean=mean(bias_err_list);
%         inference_data(dataindex).bias_err_sem=std(bias_err_list)/sqrt(numel(bias_err_list));
        
        dataindex=dataindex+1;
        save('inference_data_dyn_glm_subsampling_50pc.mat', 'inference_data', 'subindex');
    end 
end