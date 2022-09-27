load('thresholds_unpinned.mat');
load inference_data_up_maxdata.mat
load inference_data_sb.mat
lrlist=[];
for temp=1:11;
    sW=thresholds(temp,1)
    load(sprintf('binnedspikes_unpinned/sW %.4f.mat',sW));
    x=sum(binnedspikes);  
    J1=inference_data(temp).Jnew;
    J2=inference_data_sb(temp).Jnew;
    %l1=x*J1*x';
    %l2=x*J2*x';
    lr=x*(J1-J2)*x';
    %lr=log(ising_prob(x,J1,diag(J1)))-log(ising_prob(x,J2,diag(J2)));
    lrlist=[lrlist;[sW,lr]];
end
figure
plot(lrlist(:,1),lrlist(:,2),'-o');