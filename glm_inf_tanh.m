function J=glm_inf_tanh(h,tanh_struct)
    N=size(h,2);
    J=zeros(N);
    %logp=0;
    for node=1:N
        tic
        node
        glm_result = fitglm(h(:,[1:node-1,node+1:end]),h(:,node),'linear','distr','normal','link',tanh_struct);
        coeffs=glm_result.Coefficients.Estimate(1:end);
        J(:,node)=[coeffs(2:node); coeffs(1); coeffs(node+1:end)];
        %logp=logp+GLM_likelihood_node(binnedspikes(:,node),binnedspikes(:,[1:node-1,node+1:end]),coeffs,'log');
        toc
    end
end