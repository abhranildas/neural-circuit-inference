set(0,'DefaultFigureWindowStyle','docked');

load('W100.mat');
load('thresholds.mat');
inference_data=struct;
%dataindex=1;
dataindex=size(inference_data,2)+1;
N=100;
for temp=2:12
    temp
    load(sprintf('binnedspikes100_1e8/sW %.3f.mat',thresholds(temp,1)));
    sW=thresholds(temp,1);
    binnedspikes0=binnedspikes;
    maxdatasize=size(binnedspikes0,1);    
    for datasize=round(maxdatasize*10^0)
        binnedspikecountlist=[];
        Jnewlist=[];
        for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
            binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
            binnedspikecount=sum(binnedspikes(:));
            binnedspikecountlist=[binnedspikecountlist,binnedspikecount];            
            Jnew=mf_sm(binnedspikes);
            Jnewlist=cat(3,Jnewlist,Jnew);            
        end
        inference_data(dataindex).sW=sW;
        inference_data(dataindex).meanspikecount=mean(binnedspikecountlist);
        inference_data(dataindex).spikecounts=binnedspikecountlist;
        inference_data(dataindex).Jnewlist=Jnewlist;       
        dataindex=dataindex+1;        
    end 
end
save mf_sm_inferred_Js.mat inference_data