function y = xi(beta,K)
%
% y = xi(beta,K)
%
%	Xi function (average entropy for Dirichlet prior with no observations)
%
%	Copyright (c) 2009 - 2011, Christian B. Mendl

y = psi(K*beta+1) - psi(beta+1);
