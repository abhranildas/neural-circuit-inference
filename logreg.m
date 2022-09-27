function lc=logreg(x,y,lambda)
nVars=size(x,2);
funObj = @(w)LogisticLoss(w,x,y);
w_init = zeros(nVars,1);
lambda_v = lambda*ones(nVars,1);
lc = L1General2_PSSgb(funObj,w_init,lambda_v)';
end