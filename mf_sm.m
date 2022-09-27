function J=mf_sm(spikes)
N=size(spikes,2);
m=mean(spikes);
C=cov(spikes);
J=-inv(C)+mf_ip(spikes);
for i=1:N
    for j=1:N
        J(i,j)=J(i,j)-C(i,j)/((1-m(i)^2)*(1-m(j)^2)-C(i,j)^2);
    end
end
end