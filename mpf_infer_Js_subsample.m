addpath(genpath('MPF Mine'));

load('W100.mat');
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

load thresholds_unpinned.mat
inference_data=struct;
%dataindex=1;
dataindex=size(inference_data,2)+1;
N0=100; % network size
N=50; % sub-network size

subindex=randsample(N0,N)';

for temp=1:11
    sW=thresholds(temp,1);
    load(sprintf('binnedspikes_unpinned/sW %.4f.mat',sW));
    binnedspikes0=binnedspikes(:,subindex);
    maxdatasize=size(binnedspikes0,1);    
    for datasize=round(maxdatasize*10.^(-4:.5:0))
        binnedspikecountlist=[];
        Jnewlist=[];
        errlist=[];
        for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
            fprintf('sW: %.4f, data fraction: %.1e, startpoint: %.1f', [sW,datasize/maxdatasize,startpoint/(maxdatasize-datasize+1)])
            binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
            binnedspikecount=sum(binnedspikes(:));
            binnedspikecountlist=[binnedspikecountlist,binnedspikecount];            
            evalc('runme_ising_from_simulation');
            
            Jnewexpanded=NaN(N0);
            Jnewexpanded(subindex,subindex)=Jnew;
            Jnewexpanded(logical(eye(N0))) = NaN;
            
%             figure;
%             subplot(1,2,1)
%             imagesc(W); axis square; colorbar
%             subplot(1,2,2)
%             imagesc(Jnewexpanded); axis square; colorbar
            
            Jnewlist=cat(3,Jnewlist,Jnewexpanded);
            %Least-squares matching and error
            [err,alph]=finderror_lsq(100,W,Jnewexpanded,'full',2);
            errlist=[errlist,err];            
        end
        inference_data(dataindex).sW=sW;
        inference_data(dataindex).meanspikecount=mean(binnedspikecountlist);
        inference_data(dataindex).spikecounts=binnedspikecountlist;  
        inference_data(dataindex).Jnewlist=Jnewlist;
        inference_data(dataindex).errlist=errlist;
        inference_data(dataindex).errmean=mean(errlist);
        inference_data(dataindex).errse=std(errlist)/sqrt(numel(errlist)); 
        dataindex=dataindex+1;
        save inference_data_ising_subsample.mat inference_data
    end 
end