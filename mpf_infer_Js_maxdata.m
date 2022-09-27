set(0,'DefaultFigureWindowStyle','docked');
addpath(genpath('MPF Mine'));
sublength=10;

load('W100.mat');
%W=W(2:2+sublength-1,2:2+sublength-1);
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

load('thresholds_unpinned.mat');
inference_data=struct;
%dataindex=1;
dataindex=size(inference_data,2)+1;
N=sublength;
for sW=100:-10:10
    %temp
    %sW=thresholds(temp,1);
    load(sprintf('binnedspikes_ising_new/sW %d.mat',sW));
    %binnedspikes=binnedspikes(:,2:2+sublength-1);
    %binnedspikes0=binnedspikes;
    %maxdatasize=size(binnedspikes0,1);    
    %for datasize=round(maxdatasize*10.^(0:-.25:-3.5))
%         binnedspikecountlist=[];
%         Jnewlist=[];
%         errlist=[];
%         for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
%             binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
%             binnedspikecount=sum(binnedspikes(:));
%             binnedspikecountlist=[binnedspikecountlist,binnedspikecount];            
            run('runme_ising_from_simulation.m');
%             Jnewlist=cat(3,Jnewlist,Jnew);
            [err,alph]=finderror_lsq(100,W,Jnew,'full',2);
%             errlist=[errlist,err];            
%         end
        inference_data(dataindex).sW=sW;
%         inference_data(dataindex).meanspikecount=mean(binnedspikecountlist);
%         inference_data(dataindex).spikecounts=binnedspikecountlist;  
%         inference_data(dataindex).Jnewlist=Jnewlist;
        inference_data(dataindex).Jnew=Jnew;
%         inference_data(dataindex).errlist=errlist;
        inference_data(dataindex).err=err;
%         inference_data(dataindex).errmean=mean(errlist);
%         inference_data(dataindex).errse=std(errlist)/sqrt(numel(errlist)); 
        dataindex=dataindex+1;
        save inference_data_ising_new.mat inference_data
%     end 
end