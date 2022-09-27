function logp=GLM_likelihood(binnedspikes,J)
    logp=0;
    for node=1:100
        coeffs=[J(node,node);J(1:node-1,node);J(node+1:end,node)];
        logp=logp+GLM_likelihood_node(binnedspikes(:,node),binnedspikes(:,[1:node-1,node+1:end]),coeffs,'log');
    end