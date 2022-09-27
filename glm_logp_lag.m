function logp=glm_logp_lag(x,xrest,L,coeffs)
    b=coeffs(1);
    ws=coeffs(2:end-L)';
    %a=coeffs(end-L+1:end);
    a=ones(1,L);
    xw=xrest*ws;
%     g=repmat(b,[numel(x)-L,1]);
    
%     for l=1:L
%         g=g+xw(L+1-l:end-l)*a(l);        
%     end
    
%     for t=1:numel(g)
%         g(t)=g(t)+dot(flip(a),temp(t:t+L-1));
%     end
    g=conv(xw,a,'valid')+b;
    logp=-dot(x,g)+sum(exp(g)); %faster
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