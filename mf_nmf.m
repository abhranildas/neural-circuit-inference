function J=mf_nmf(spikes)
    %% Preprocessing
%     addpath(genpath('L1GeneralExamples'));
%     spikes=standardizeCols(binnedspikes(:,2:end));
    %N=size(spikes,2);
    %spikes(spikes==0)=-1;
    %m=mean(spikes);
    C=cov(spikes);
    J=-inv(C);%eye(N)./(1-repmat(m,N,1).^2)-Cinv;
end