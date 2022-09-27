list=[];
figure
hold on
for i=1:11
    Jnew=GLM_inf_data_full(i).Jnew;
    Jnew(logical(eye(size(Jnew)))) = NaN;
    plot(meancoupling(Jnew),'r');
    plot(meancoupling(W*18.56*thresholds(i,1)/abs(min(W(:)))),'k')
    list=[list;[min(meancoupling(Jnew)),min(meancoupling(W*18.56*thresholds(i,1)/abs(min(W(:)))))]];
end

load thresholds_unpinned.mat
load W100.mat
W(logical(eye(size(W))))=.001;
list=[];
for i=1:11
    sW=thresholds(i,1);
    load(sprintf('binnedspikes_GLM_exp/sW %.4f.mat',sW));
    binnedspikes=bin(binnedspikes,100,0,0);
    J1=W*18.56*sW/abs(min(W(:)));
    %J1=W;
    %J1(logical(eye(size(J1))))=.001;
    J2=GLM_inf_data_full(i).Jnew;
    %J1(logical(eye(size(J1))))=diag(J2);
    list=[list;[sW,GLM_likelihood(binnedspikes,J1),GLM_likelihood(binnedspikes,J2)]];
end