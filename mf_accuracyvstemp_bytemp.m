set(0,'DefaultFigureWindowStyle','docked');

load('W100.mat');
load('thresholds.mat');
inference_data=struct;
%dataindex=1;
dataindex=size(inference_data,2)+1;
N=100;
for temp=5:11
    load(sprintf('binnedspikes100_1e8/sW %.3f.mat',thresholds(temp,1)));
    sW=thresholds(temp,1);
    binnedspikes0=binnedspikes;
    maxdatasize=size(binnedspikes0,1);    
    for datasize=maxdatasize%round(maxdatasize*10.^(0:-.25:-3.5))
        errlist=[];
        binnedspikecountlist=[];
        for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
            binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
            binnedspikecount=sum(binnedspikes(:));
            binnedspikecountlist=[binnedspikecountlist,binnedspikecount];            
            Jnew=mf_tap(binnedspikes);
            run('finderror.m');
            errlist=[errlist,err2];
        end
        inference_data(dataindex).sW=sW;
        inference_data(dataindex).binnedspikecount=mean(binnedspikecountlist);
        inference_data(dataindex).err=mean(errlist);        
        inference_data(dataindex).Jnew=Jnew;                 
        dataindex=dataindex+1;
        save mf_tap_inference_data.mat inference_data
    end 
end
%% Plotting inference data
figure
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerSize',10,'MarkerEdgeColor','black','MarkerFaceColor','black');
view(-170,19);
set(gca,'yscale','log');
set(gca,'zscale','log');
xlabel('Weight strength \omega');
ylabel('Data size (total spike count)');
zlabel('Inference error');
title('Naive Mean Field');