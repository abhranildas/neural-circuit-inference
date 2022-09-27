N=100;
addpath(genpath('MPF Mine'));
load('W100.mat');
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

binsweepdata=struct;
ii=1;
sW=.0025;
for binsize=[1 50 100 200 400]
    load(sprintf('binnedspikes_GLM_exp/sW %.4f.mat',sW));
    binnedspikes=bin(binnedspikes,binsize,3e5);
    sum(binnedspikes(:))
    run('runme_ising_from_simulation.m');
    [err,alph]=finderror_lsq(100,W,Jnew,'full',2);
    binsweepdata(ii).binsize=binsize;
    binsweepdata(ii).Jnew=Jnew;
    binsweepdata(ii).err=err;
    ii=ii+1;
end
save GLM_exp_binsweep.mat binsweepdata
figure
plot([binsweepdata.binsize],[binsweepdata.err],'-o')