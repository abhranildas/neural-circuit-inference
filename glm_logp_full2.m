function logp_full=glm_logp_full2(binnedspikes,coeffs)
    N=size(binnedspikes,2);
    bs=coeffs(1:N);
    w_u=triu(squareform(coeffs(N+1:end)));
    wmat=w_u+w_u';
    logp_full=0;
    for node=1:N
        coeffs_node=[bs(node),wmat(node,[1:node-1,node+1:end])];
        x=binnedspikes(:,node);
        xrest=binnedspikes(:,[1:node-1,node+1:end]);
        lambda=exp(coeffs_node(2:end)*xrest'+coeffs_node(1));
        p_list=poisspdf(x',lambda);
        logp_full=logp_full-sum(log(p_list));
    end
