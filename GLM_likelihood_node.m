function logp=GLM_likelihood_node(x,xrest,coeffs,link)
    g=xrest*coeffs(2:end)+coeffs(1);
    if (strcmp(link,'log'))
        lambda=exp(g);
    elseif (strcmp(link,'id'))
        lambda=g;
    elseif (strcmp(link,'3'))
        lambda=g.^3;
    end
    p_list=poisspdf(x,lambda);
    logp=-sum(log(p_list));