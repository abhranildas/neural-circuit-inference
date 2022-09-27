function J=mf_bas(spikes)
    %% Preprocessing
%     addpath(genpath('L1GeneralExamples'));
%     spikes=standardizeCols(binnedspikes(:,2:end));
    %N=size(spikes,2);
    %spikes(spikes==0)=-1;
    %m=mean(spikes);
    C=cov(spikes); %Is it covariance matrix or something else?
    Cinv=inv(C);    
    %% Calculate J
    J=-asinh(2*Cinv)/2;
    J(logical(eye(size(J)))) = NaN;
end