function s = s1nsb(varargin)
%
% s = s1nsb(n)
% s = s1nsb(nx,kx)
% s = s1nsb(nx,kx,tol)
%
%	NSB entropy estimate
%
%	Copyright (c) 2009 - 2011, Christian B. Mendl

switch length(varargin)
	case 0
		error('Expecting at least a vector of counts.');
	case 1
		% interpret first argument as raw counts
		[nx,kx] = count_rates(varargin{1});
		tol = 1e-8;
	case 2
		nx = varargin{1};
		kx = varargin{2};
		tol = 1e-8;
	case 3
		nx  = varargin{1};
		kx  = varargin{2};
		tol = varargin{3};
	otherwise
		error('Invalid number of input arguments.');
end

s = inference_nsb(@s1dirich,nx,kx,tol);
