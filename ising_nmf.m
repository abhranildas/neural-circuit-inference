load('W100.mat');
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0
sW_err=[];
for sW=10:10:80
    load(sprintf('binnedspikes_ising/sW %d.mat',sW));
    J=mf_nmf(binnedspikes);
    figure;
    imagesc(J); axis square;
    [err,alph]=finderror_lsq(100,W,J,'full',2);
    sW_err=[sW_err;[sW,err]];
end
figure
plot(sW_err(:,1),sW_err(:,2),'-o');