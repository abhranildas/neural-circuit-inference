function ds = ds2nsb(varargin)
%
%	Copyright (c) 2009 - 2011, Christian B. Mendl
%
% ds = ds2nsb(n)
% ds = ds2nsb(nx,kx)
% ds = ds2nsb(nx,kx,tol)
%
%	NSB estimate of entropy variance
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

ds = sqrt(inference_nsb(@s2dirich,nx,kx,tol)-inference_nsb(@s1dirich,nx,kx,tol)^2);
