set(0,'DefaultFigureWindowStyle','docked');

N=100;
load('thresholds_unpinned.mat');
load('W100.mat');
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

alph=100;

s=struct;
for temp=1:11
    load(sprintf('binnedspikes_GLM_exp/sW %.4f.mat',thresholds(temp,1)));
    binnedspikes=bin(binnedspikes,100,0,0);
    %binnedspikes=binnedspikes(1:round(size(binnedspikes,1)/10),:);
    Jnew=zeros(N);
    logp=0;
    for node=1:N
        node
        %g = fitglm(binnedspikes(:,[1:node-1,node+1:end]),binnedspikes(:,node),'linear','distr','poisson');
        g = fitglm(binnedspikes(:,[1:node-1,node+1:end]),binnedspikes(:,node),'linear','distr','poisson');
        coeffs=g.Coefficients.Estimate(1:end);
        Jnew(:,node)=[coeffs(2:node); coeffs(1); coeffs(node+1:end)];
        logp=logp+GLM_likelihood(binnedspikes(:,node),binnedspikes(:,[1:node-1,node+1:end]),coeffs,'log')
    end
    [err,alph]=finderror_lsq(alph,W,Jnew,'full',2);
    s(temp).sW=thresholds(temp,1);
    s(temp).Jnew=Jnew;
    s(temp).logp=logp;
    s(temp).err=err;
    Jnew(logical(eye(size(Jnew)))) = NaN;
%     figure;
%     imagesc(Jnew); axis square;
    figure;
    plot(meancoupling(Jnew));
    %save GLM_data6.mat s;
    %errlist=[errlist; [thresholds(temp,1),err]];
end
figure
plot([s.sW],[s.err],'-o');