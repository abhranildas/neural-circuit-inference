function logp=glm_logp(x,xrest,coeffs)
%     ws=coeffs(1:end-1);
%     b=coeffs(end);    
    %g=zeros(size(x));    
%     p_list=zeros(size(x));    
    lambda=exp(coeffs(2:end)*xrest'+coeffs(1));
    p_list=poisspdf(x',lambda);
%     for t=1:numel(x)
%         %g(t)=sum(ws.*xrest(t,:))+b;
%         %lambda(t)=exp(g(t));
%         p_list(t)=poisspdf(x(t),lambda(t));
%     end 
    logp=-sum(log(p_list));