max_lag=100;
lags_binned=(-max_lag:max_lag)*3/100;

load W100
load thresholds_unpinned
%inference_data=struct;
dataindex=size(inference_data,2)+1;

for i=3:11    
    sW=thresholds(i,1);    
    load(sprintf('binsize_1_up_1e8/sW %.4f.mat',sW));
    binnedspikes=cast(bin(binnedspikes,3,0,0),'single');
    
    maxdatasize=size(binnedspikes,1);    
    for datasize=maxdatasize %round(maxdatasize*10.^(-.25:-.25:-5))
        binnedspikecountlist=[];
        Rlist=[];
        Blist=logical([]);
        for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
            fprintf('sW: %.4f, data fraction: %.1e, startpoint: %.1f\n', [sW,datasize/maxdatasize,startpoint/(maxdatasize-datasize+1)])
            binnedspikes=binnedspikes(startpoint:startpoint+datasize-1,:);
            binnedspikecount=sum(binnedspikes(:));
            binnedspikecountlist=[binnedspikecountlist,binnedspikecount];
            
            R=spike_ccg(binnedspikes,max_lag);
            B=ccg_graph_symm(R,lags_binned);
            
            Rlist=cat(4,Rlist,R);
            Blist=cat(3,Blist,B);
        end
        
        inference_data(dataindex).sW=sW;
        inference_data(dataindex).meanspikecount=mean(binnedspikecountlist);
        inference_data(dataindex).spikecounts=binnedspikecountlist;
        inference_data(dataindex).Rlist=Rlist;
        inference_data(dataindex).Blist=Blist;
        
        dataindex=dataindex+1;
        save('inference_data_ring_sync.mat', 'inference_data', 'lags_binned','-v7.3');
    end 
end

%% Combine CCG graph with GLM weights
for i=1:11
    %inference_data_sync(i).Blist=logical(inference_data_sync(i).Blist);
    %inference_data_sync(i).Jlist=inference_data_sync(i).Jlist.*inference_data_sync(i).Blist;
    J=inference_data_sync(i).Jlist;
    [err,var_err,bias_err]=inference_error(J,W,'full',2,2);
    inference_data_sync(i).errlist=[err];
    inference_data_sync(i).var_err_list=[var_err];
    inference_data_sync(i).bias_err_list=[bias_err];
end
    
    