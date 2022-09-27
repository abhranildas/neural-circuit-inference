N=100;
load('thresholds_unpinned.mat');
load('W100.mat');
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

alph=100;

s=struct;
for temp=1:10
    load(sprintf('binnedspikes_GLM_exp/sW %.4f.mat',thresholds(temp,1)));
    binnedspikes_history=zeros(size(binnedspikes,1)-99,size(binnedspikes,2));
    for i=1:100
        binnedspikes_history(:,i)=conv(binnedspikes(:,i),ones(100,1),'valid');
    end
    binnedspikes=bin(binnedspikes,100,0,0);
    %binnedspikes=binnedspikes(1:round(size(binnedspikes,1)/10),:);
    Jnew=zeros(N);
    for node=4:N
        node
        g = fitglm(binnedspikes_history(1:end-1,[1:node-1,node+1:end]),binnedspikes(101:end,node),'linear','distr','poisson');
        coeffs=g.Coefficients.Estimate(1:end);
        Jnew(:,node)=[coeffs(2:node); coeffs(1); coeffs(node+1:end)];
    end    
    [err,alph]=finderror_lsq(alph,W,Jnew,'full',2);
    s(temp).sW=thresholds(temp,1);
    s(temp).Jnew=Jnew;
    s(temp).err=err;
    Jnew(logical(eye(size(Jnew)))) = NaN;
    figure;
    imagesc(Jnew); axis square;
    %save GLM_data6.mat s;
    %errlist=[errlist; [thresholds(temp,1),err]];
end