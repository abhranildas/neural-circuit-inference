function logp=glm_logp_lag_simple(x,xrest,L,coeffs)
    ws=coeffs(1:end-2)';
    b=coeffs(end-1);
    a=coeffs(end);
    g=ones(numel(x)-L,1)*b;
    for l=1:L
        g=g+(xrest(L+1-l:end-l,:)*ws)*exp(-a*l);
    end
    %g=zeros(size(x));    
%     p_list=zeros(size(x));    
    lambda=exp(g);
    p_list=poisspdf(x(L+1:end),lambda);
%     for t=1:numel(x)
%         %g(t)=sum(ws.*xrest(t,:))+b;
%         %lambda(t)=exp(g(t));
%         p_list(t)=poisspdf(x(t),lambda(t));
%     end 
    logp=-sum(log(p_list));