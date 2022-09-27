function logp=glm2_logp(x,xrest,coeffs,L,N)
w=coeffs(1:N-1);
a=coeffs(N:end-1);
b=coeffs(end);

temp=zeros(1,L);
for l=1:L
    temp(l)=dot(w,dot(repmat(x(L+1:end),[1 size(xrest,2)]),xrest(L+1-l:end-l,:)));
end
logp1=dot(a,temp)+b*sum(x);

logp2=0;
for t=L+1:numel(x)
    s=0;
    for l=1:L
        s=s+a(l)*dot(w,xrest(t-l,:));
    end
    logp2=logp2-exp(s+b);
end
logp=logp1+logp2;
    