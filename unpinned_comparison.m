oad W100.mat
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

for sW=[.001 .01 .05]
    load(sprintf('binnedspikes_unpinned/J_%0.3f.mat',sW))
    figure
    plot(diag(Jnew))
    Jnew(logical(eye(size(Jnew))))=NaN;
    figure
    imagesc(Jnew)
    axis square
    [err,~]=finderror_lsq(100,W,Jnew,'full',2)
end

Jnew=inference_data_full(31).Jnewlist(:,:,1);
Jnew=Jnew(2:end,2:end);
Jnew(logical(eye(size(Jnew))))=NaN;
figure
imagesc(Jnew); axis square