set(0,'DefaultFigureWindowStyle','docked');

load('W100.mat');
%load('thresholds.mat');
inference_data=struct;
%dataindex=1;
%dataindex=size(inference_data,2)+1;
N=100;
for sW=[.001]
    load(sprintf('binnedspikes_sb/sW %.3f.mat',sW));
    %sW=thresholds(temp,1);
    %binnedspikes0=binnedspikes;
    %maxdatasize=size(binnedspikes0,1);    
    %for datasize=maxdatasize%round(maxdatasize*10.^(0:-.25:-3.5))
        %errlist=[];
        %binnedspikecountlist=[];
        %for startpoint=1
            %binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
            binnedspikecount=sum(binnedspikes(:));
            %binnedspikecountlist=[binnedspikecountlist,binnedspikecount];            
            run('runme_ising_from_simulation.m');
            %run('finderror.m');
            %errlist=[errlist,err];
        %end
        inference_data(dataindex).sW=sW;
        %inference_data(dataindex).binnedspikecount=binnedspikecount;
        inference_data(dataindex).err=err;        
        inference_data(dataindex).Jnew=Jnew;                 
        dataindex=dataindex+1;
        save inference_data_sb.mat inference_data
    %end 
end