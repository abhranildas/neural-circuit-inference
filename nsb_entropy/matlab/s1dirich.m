function y = s1dirich(beta,nx,kx)
%
% y = s1dirich(beta,nx,kx)
%
%	Entropy expectation value for
%	Dirichlet prior specified by beta
%
%	Copyright (c) 2009 - 2011, Christian B. Mendl

K = sum(kx);
kappa = K*beta;
M = kx*nx';

y = zeros(size(beta));
for j=1:numel(beta)
	p = psi(M+kappa(j)+1);
	y(j) = -(kx*((nx+beta(j))/(M+kappa(j)).*(psi(nx+beta(j)+1)-p))');
end
