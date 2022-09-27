function y = inference_nsb(F,nx,kx,tol)
%
% y = inference_nsb(F,nx,kx,tol)
%
%	Copyright (c) 2009 - 2011, Christian B. Mendl

%%
K = sum(kx);
M = kx*nx';
if nx(1)==0
	% number of bins with non-zero n_i
	K1 = K - kx(1);
else
	K1 = K;
end

%%
% estimate extremum of log(rho)

kappa0 = fzero(@(kappa)dlogrho(kappa,K1,M),1);

L0 = log_rho(kappa0/K,nx,kx);

%%

% map [0,1) to [0,infinity)
beta = @(w) (w./(1-w)).^2;
dbeta = @(w) 2*w./(1-w).^3;

g = @(w) exp(-log_rho(beta(w),nx,kx)+L0).*dxi(beta(w),K).*dbeta(w);
gF = @(w) F(beta(w),nx,kx).*g(w);
y = quadgk(gF,0,1,'RelTol',tol,'AbsTol',0) / quadgk(g,0,1,'RelTol',tol,'AbsTol',0);


%%
% Approximation of d log(rho(beta,n)/d beta:
% equation (15) in "Inference of entropies of discrete random variables with unknown cardinalities"
%
function y = dlogrho(kappa,K1,M)

y = 1+kappa.^2;

% ensure that all arguments of psi are positive
IX = kappa>0;
kappa = kappa(IX);
y(IX) = K1./kappa+psi(kappa)-psi(M+kappa);
