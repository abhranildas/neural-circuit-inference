function y = dxi(beta,K)
%
% y = dxi(beta,K)
%
%	Derivative of 'xi' function with respec to beta
%
%	Copyright (c) 2009 - 2011, Christian B. Mendl

y = K*psi(1,1+K*beta) - psi(1,1+beta);
