function J=mf_ip(spikes)
    %% Preprocessing
%     addpath(genpath('L1GeneralExamples'));
%     spikes=standardizeCols(binnedspikes(:,2:end));
    m=mean(spikes);
    spikes=spikes-repmat(m, [size(spikes,1) 1]);
    N=size(spikes,2);
    %spikes(spikes==0)=-1;
    m=mean(spikes);
    C=cov(spikes); %Is it covariance matrix or something else?
    %% Calculate J
    J=zeros(N);
    for i=1:N
        for j=1:N
            J(i,j)=1/4*log(((1+m(i))*(1+m(j))+C(i,j))*((1-m(i))*(1-m(j))+C(i,j)))/...
                   (((1+m(i))*(1-m(j))-C(i,j))*((1-m(i))*(1+m(j))-C(i,j)));
        end
    end
    %J(logical(eye(size(J)))) = NaN;
end