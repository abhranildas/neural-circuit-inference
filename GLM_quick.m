N=100;
load('thresholds_unpinned.mat');
load('W100.mat');
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0
alph=100;

binning=1; % 1 means binned by tau, 0 means exponentially decaying time kernel

if ~binning
    t_max=1000; tau=100;
    t=1:t_max; a=exp(-t/tau)';
end

s=struct;
for temp=11
    temp
    %load(sprintf('binnedspikes_GLM_exp/sW %.4f.mat',thresholds(temp,1)));
    %load(sprintf('binnedspikes_LNP_unpinned/sW %.4f.mat',thresholds(temp,1)));
    load(sprintf('binsize_1_unbinarized_up_1e7/sW %.4f.mat',thresholds(temp,1)));
    %load(sprintf('binnedspikes_dyn_glm/sW %.4f.mat',thresholds(temp,1)));
    if binning
        binnedspikes=bin(binnedspikes,100,0,0);
        %binnedspikes=binnedspikes(1:round(size(binnedspikes,1)/10),:);
    else
        % compute temporally filtered spikes (inputs):
        g=zeros(size(binnedspikes,1)-t_max,N);
        for col=1:N
            g(:,col)=conv(binnedspikes(1:end-1,col),a,'valid');
        end
    end
    
    Jnew=glm_inf_binned(binnedspikes);
    [err,alph]=finderror_lsq(alph,W,Jnew,'full',2);
    s(temp).sW=thresholds(temp,1);
    s(temp).Jnew=Jnew;
    %s(temp).logp=logp;
    s(temp).err=err;
    Jnew(logical(eye(size(Jnew)))) = NaN;
%     figure;
%     imagesc(Jnew); axis square;
    figure;
    plot(meancoupling(Jnew));
    %save GLM_data.mat s;
    %errlist=[errlist; [thresholds(temp,1),err]];
end
figure
plot([s.sW],[s.err],'-o');