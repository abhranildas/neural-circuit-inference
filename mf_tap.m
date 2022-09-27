function J=mf_tap(spikes)
N=size(spikes,2);
m=mean(spikes);
C=cov(spikes);
Cinv=inv(C);
J=zeros(N);
for i=1:N
    for j=1:N
        J(i,j)=(sqrt(1-8*m(i)*m(j)*Cinv(i,j))-1)/(4*m(i)*m(j));
        if ~isreal(J(i,j))
            J(i,j)=abs(J(i,j));
        end
    end
end
end