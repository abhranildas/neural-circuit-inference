N=100;
%load('thresholds_unpinned.mat');
load('W100.mat');
%W=W(2:N,2:N);
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

alph=100;
lag=1;
errlist=[];
tic

binsize=5;
for sW=.025
    %load binnedspikes_GLM.mat
    %binnedspikes=bin(binnedspikes,binsize,1e6);
    %load(sprintf('binnedspikes100_LNP/sW %.3f.mat',sW));
    %binnedspikes=binnedspikes(:,2:end);
    N=size(binnedspikes,2);
    Jnew=zeros(N);
    for node=1:N
        node
        g = fitglm(binnedspikes(1:end-lag,[1:node-1,node+1:end]),binnedspikes(1+lag:end,node),'linear','distr','poisson');
        coeffs=g.Coefficients.Estimate(1:end);
        b=coeffs(1);
        ws=coeffs(2:end);
        Jnew(:,node)=[ws(1:node-1); b; ws(node:end)];
    end
    Jnew(logical(eye(size(Jnew)))) = NaN;
    figure
    imagesc(Jnew); axis square
    title(binsize);
    [err,alph]=finderror_lsq(alph,W,Jnew,'full',2);
    %bin_err=[bin_err;[binsize,err]];
end
toc