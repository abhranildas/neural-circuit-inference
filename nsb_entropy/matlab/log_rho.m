function y = log_rho(beta,nx,kx)
%
% y = log_rho(beta,nx,kx)
%
%	Calculate -log(rho) from equation (13) of "Entropy and Inference, Revisited"
%
%	Copyright (c) 2009 - 2011, Christian B. Mendl

K = sum(kx);
M = kx*nx';
kappa = K*beta;

if nx(1)==0
	% number of bins with non-zero n_i
	K1 = K - kx(1);
	% only need non-zero n_i
	nx = nx(2:end);
	kx = kx(2:end);
else
	K1 = K;
end


y = zeros(size(beta));
for j=1:numel(beta)
	if beta(j)==0, continue; end
	% use gammaln to avoid overflow
	y(j) = (K1*gammaln(beta(j))-kx*gammaln(nx+beta(j))') + (gammaln(M+kappa(j))-gammaln(kappa(j)));
end
