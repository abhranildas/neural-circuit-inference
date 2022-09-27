set(0,'DefaultFigureWindowStyle','docked');
%addpath(genpath('L1GeneralExamples'));

load('W100.mat');
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

load('thresholds_unpinned.mat');
%inference_data=struct;
%dataindex=1;
%dataindex=size(inference_data,2)+1;
N=100;
errlist=[];
for temp=1:11
    temp
    sW=thresholds(temp,1);
    %load(sprintf('binnedspikes_unpinned/sW %.4f.mat',sW));
    load(sprintf('binnedspikes_dyn_glm/sW %.4f.mat',sW));
    %spikes=binnedspikes;%standardizeCols(binnedspikes);
    Jnew=mf_nmf(binnedspikes);
%     figure
%     imagesc(Jnew); axis square
    [err,alph]=finderror_lsq(100,W,Jnew,'full',2);
    %Jnew=Jnew*alph;
    %Jnew=(Jnew-min(Jnew(:)))./(max(Jnew(:))-min(Jnew(:)))-1; %rescaling W between -1 and 0
    %err=error_lsq(1,W,Jnew,'full',2);
%     couplings=Jnew(N/2,:);
    %actualcouplings=W(N/2,:);
    figure
    plot(meancoupling(Jnew));
    %hold on;
%     plot(couplings,'-o');    
    %plot(actualcouplings,'-o');
    %hold off;
    errlist=[errlist;[sW,err]];  
end

figure
plot(errlist(:,1),errlist(:,2),'-o');
%save mf_sm_inferred_Js.mat inference_data