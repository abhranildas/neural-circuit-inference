set(0,'DefaultFigureWindowStyle','docked');
addpath(genpath('L1GeneralExamples'));
N=100;

load('W100.mat');
Wclip=W(2:N,2:N);
Wclip(logical(eye(size(Wclip)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
Wclip=(Wclip-min(Wclip(:)))./(max(Wclip(:))-min(Wclip(:)))-1; %rescaling W between -1 and 0

load('thresholds.mat');
%inference_data=struct;
%dataindex=1;
dataindex=size(inference_data,2)+1;

alph0=100;
for temp=12
    load(sprintf('binnedspikes100_1e8/sW %.3f.mat',thresholds(temp,1)));
    sW=thresholds(temp,1);
    binnedspikes0=binnedspikes;
    maxdatasize=size(binnedspikes0,1);    
    for datapower=0
        datasize=round(maxdatasize*10.^datapower);
        lambda=optimal_lambdas(optimal_lambdas(:,1)==sW & optimal_lambdas(:,2)==datapower, 3)
        err2list=[];
        binnedspikecountlist=[];
        for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
            binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
            binnedspikecount=sum(binnedspikes(:));
            binnedspikecountlist=[binnedspikecountlist,binnedspikecount];
            Jnew=logreg_fullJ(standardizeCols(binnedspikes),lambda);
            Jnewclip=Jnew;
            Jnewclip(logical(eye(size(Jnewclip)))) = NaN;
            %run('finderror.m');
            %err1list=[err1list,err1];
            err2=finderror_lsq(alph0,Wclip,Jnewclip,'full',2);
            err2list=[err2list,err2];
        end
        inference_data(dataindex).sW=sW;
        inference_data(dataindex).binnedspikecount=mean(binnedspikecountlist);
        %inference_data(dataindex).err1=mean(err1list);
        inference_data(dataindex).err2=mean(err2list);
        inference_data(dataindex).Jnew=Jnew;                 
        dataindex=dataindex+1;
        save logreg_inference_data.mat inference_data
    end 
end

%lambdas=[sweep_values.lambdas];
%lambdas([sweep_values.sW]==.001 & [sweep_values.count]==-.25)