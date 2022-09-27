set(0,'DefaultFigureWindowStyle','docked');
addpath(genpath('MPF Mine'));

load('W100.mat');
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

%load('thresholds_unpinned.mat');
inference_data=struct;
%dataindex=1;
dataindex=size(inference_data,2)+1;
N=100;
for temp=1:10
    sW=temp*5
    load(sprintf('binnedspikes_ising/sW %d.mat',sW));    
    run('runme_ising_from_simulation.m');
    [err,alph]=finderror_lsq(100,W,Jnew,'full',2);
    inference_data(dataindex).sW=sW;
    inference_data(dataindex).Jnew=Jnew;
    inference_data(dataindex).err=err;
    dataindex=dataindex+1;
end