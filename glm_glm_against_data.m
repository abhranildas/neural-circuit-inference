set(0,'DefaultFigureWindowStyle','docked');

load('W100.mat');
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

load('thresholds_unpinned.mat');
inference_data=struct;
dataindex=1;
%dataindex=size(inference_data,2)+1;
N=100;

for temp=1:11    
    sW=thresholds(temp,1);
    load(sprintf('binnedspikes_GLM_exp/sW %.4f.mat',thresholds(temp,1)));
    binnedspikes0=bin(binnedspikes,100,0,0);
    maxdatasize=size(binnedspikes0,1);    
    for datasize=round(maxdatasize*10.^(0:-.25:-1.5))
        binnedspikecountlist=[];
        Jnewlist=[];
        errlist=[];
        for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
            binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
            binnedspikecount=sum(binnedspikes(:));
            binnedspikecountlist=[binnedspikecountlist,binnedspikecount];
            Jnew=zeros(N);
            for node=1:N
                node
                g = fitglm(binnedspikes(:,[1:node-1,node+1:end]),binnedspikes(:,node),'linear','distr','poisson');
                coeffs=g.Coefficients.Estimate(1:end);
                Jnew(:,node)=[coeffs(2:node); coeffs(1); coeffs(node+1:end)];
            end
            Jnewlist=cat(3,Jnewlist,Jnew);
            [err,alph]=finderror_lsq(100,W,Jnew,'full',2);
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
        save inference_data_dyn_glm.mat inference_data
    end 
end
