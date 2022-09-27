function [nx,kx] = count_rates(n)
%
% [nx,kx] = count_rates(n)
%
%	Copyright (c) 2009 - 2011, Christian B. Mendl

nx = unique(n);

kx = zeros(size(nx));
for j=1:length(nx), kx(j) = nnz(n==nx(j)); end
