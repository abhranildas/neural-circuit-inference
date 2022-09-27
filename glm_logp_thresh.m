function logp=glm_logp_thresh(x,xrest,basis,coeffs)
    b=coeffs(1);
    ws=coeffs(2:2+size(xrest,2)-1)';
    base_w=coeffs(end-size(basis,2)+1:end)';
    a=basis*base_w;
    %a=a(1:L);
    %a=coeffs(end-L+1:end);
    xw=xrest*ws;
%     g=repmat(b,[numel(x)-L,1]);
%     for l=1:L
%         g=g+(xrest(L+1-l:end-l,:)*ws)*a(l);        
%     end
    
%     for t=1:numel(g)
%         g(t)=g(t)+dot(flip(a),temp(t:t+L-1));
%     end
    g=conv(xw,a,'valid')+b;
    lambda=max(g,0);
    %g=zeros(size(x));    
%     p_list=zeros(size(x));    
    %lambda=exp(g);
    %p_list=poisspdf(x(L+1:end),exp(g));
%     for t=1:numel(x)
%         %g(t)=sum(ws.*xrest(t,:))+b;
%         %lambda(t)=exp(g(t));
%         p_list(t)=poisspdf(x(t),lambda(t));
%     end 
    %logp=-sum(log(poisspdf(x(L+1:end),exp(g))));
    %logp=-sum(x.*g-exp(g));
    logp=-sum(log(poisspdf(x,lambda)));
    %logp=-dot(x,g)+sum(exp(g)); %faster
    %logp=-dot(g(ind),x)+sum(exp(g));
    