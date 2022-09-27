function logp_full=glm_logp_full(binnedspikes,coeffs)
    N=size(binnedspikes,2);
    bs=coeffs(1:N);
    w_u=triu(squareform(coeffs(N+1:end)));
    wmat=w_u+w_u';
    logp_full=0;
    for node=1:N
        coeffs=[bs(node),wmat(node,[1:node-1,node+1:end])];
        logp_full=logp_full+glm_logp(binnedspikes(:,node),binnedspikes(:,[1:node-1,node+1:end]),coeffs);
    end
