load Wrand
inference_data=struct;
dataindex=size(inference_data,2)+1;
N=100;

load('binnedspikes_random/binnedspikes_weak.mat')
binnedspikes0=binnedspikes;

maxdatasize=size(binnedspikes0,1);
tic
for datasize=round(maxdatasize*10.^(0:-.25:-5))
    binnedspikecountlist=[];
    Jlist=[];
    err_list=[];
    for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
        fprintf('data fraction: %.1e, startpoint: %.1f\n', [datasize/maxdatasize,startpoint/(maxdatasize-datasize+1)])
        binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
        binnedspikecount=sum(binnedspikes(:));
        binnedspikecountlist=[binnedspikecountlist,binnedspikecount];
        
        J=glm_inf_binned(binnedspikes);
        
        err=inference_error(J,W);
        
        Jlist=cat(3,Jlist,J);        
        err_list=[err_list,err];        
    end
    
    inference_data(dataindex).meanspikecount=mean(binnedspikecountlist);
    inference_data(dataindex).spikecounts=binnedspikecountlist;
    inference_data(dataindex).Jlist=Jlist;
    
    inference_data(dataindex).err_list=err_list;
    inference_data(dataindex).err_mean=mean(err_list);
    inference_data(dataindex).err_sem=std(err_list)/sqrt(numel(err_list));
    
    dataindex=dataindex+1;
    save('inference_data_dyn_glm_random_weak.mat', 'inference_data');
end
toc