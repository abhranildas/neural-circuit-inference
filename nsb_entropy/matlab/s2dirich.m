function y = s2dirich(beta,nx,kx)
%
% y = s2dirich(beta,nx,kx)
%
%	Entropy squared expectation value for
%	Dirichlet prior specified by beta
%
%	Copyright (c) 2009 - 2011, Christian B. Mendl

K = sum(kx);
kappa = K*beta;
M = kx*nx';

y = zeros(size(beta));
for j=1:numel(beta)
	p = psi(M+kappa(j)+2);
	d = (nx+beta(j)).*((nx+beta(j)+1).*((psi(nx+beta(j)+2)-p).^2+psi(1,nx+beta(j)+2))...
		-(nx+beta(j)).*(psi(nx+beta(j)+1)-p).^2);
	v = (nx+beta(j)).*(psi(nx+beta(j)+1)-p);
	y(j) = (kx*d' + (kx*v')^2)/((M+kappa(j))*(M+kappa(j)+1)) - psi(1,M+kappa(j)+2);
end
