function J=mf_ba(spikes)
    %% Preprocessing
    %addpath(genpath('L1GeneralExamples'));
    %spikes=standardizeCols(spikes(:,2:end));
    N=size(spikes,2);
    %spikes(spikes==0)=-1;
    %m=mean(spikes);
    %spikes=spikes-repmat(m, [size(spikes,1) 1]);
    m=mean(spikes);
    C=cov(spikes); %Is it covariance matrix or something else?
    for i=1:N
        for j=1:N
            C(i,j)=C(i,j)/sqrt(C(i,i)*C(i,j));
        end
    end
    Cinv=inv(C);
    Cinv2=Cinv^2;
    %% Calculate J
    J=zeros(N);
    for i=1:N
        for j=1:N
            J(i,j)=-atanh(1/(2*Cinv(i,j))*sqrt(1+4*(1-m(i)^2)*(1-m(j)^2)*Cinv2(i,j))-m(i)*m(j)...
            -1/(2*Cinv(i,j))*sqrt((sqrt(1+4*(1-m(i)^2)*(1-m(j)^2)*Cinv2(i,j))-2*m(i)*m(j)*Cinv(i,j))^2-4*Cinv2(i,j)));
        end
    end
    %J(logical(eye(size(J)))) = NaN;
end