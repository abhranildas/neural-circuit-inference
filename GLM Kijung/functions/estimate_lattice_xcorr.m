function [Xcorr,Lpeak,Lattice,Param_cross,Relative_phase,center,center_lattice] = estimate_lattice_xcorr(Ratemap_c1,Ratemap_c2,Init_param,is_fixed_grid_param)
[my,mx] = size(Ratemap_c1);
% Compute the cross-correlation
Xcorr = normxcorr2(Ratemap_c1,Ratemap_c2);
% Search for local peaks
lp = imregionalmax(Xcorr);
[r,c] = find(lp == 1);
% Remove local peaks whose height is lower than 1% 
% of the height of the global peak
Lpeak1D = sub2ind(size(Xcorr),r,c);
thrshold = max(Xcorr(:))/100;
ind = find(Xcorr(Lpeak1D)<thrshold);
Lpeak1D(ind) = [];
[I,J] = ind2sub(size(Xcorr),Lpeak1D);
Lpeak = [J I];
% center of the Xcorrelogram
center = [mx my];
% maximum/minimum XY border of the Xcorrelogram
maxXY = [2*mx-1 2*my-1];
minXY = [0 0];

[~, ind] = sort(sqrt(sum((repmat(center,size(Lpeak,1),1) - Lpeak).^2,2)));
center_xcorr = Lpeak(ind(1),:);

% Find out initial grid parameters x0
if nargin == 3
    x0 = [Init_param center_xcorr];
    [Param_cross, Lattice] = fit_lattice(x0,Xcorr+abs(min(Xcorr(:))),Lpeak,maxXY);
    
elseif nargin == 4
    x0 = center_xcorr;
    fixed_grid_param = Init_param;
    [Param_cross, Lattice] = fit_lattice(x0,Xcorr+abs(min(Xcorr(:))),Lpeak,maxXY,[],fixed_grid_param);
else
    tmp = sprintf('Please check the number of input arguments!\n'); disp(tmp);
end

center_xcorr = Param_cross(5:6);
center_lattice = [center_xcorr(1) 2*my-center_xcorr(2)];
Param_cross = [Param_cross(2),Param_cross(1),-Param_cross(4),-Param_cross(3)];

Relative_phase = project_obliq(center_lattice-center, Param_cross);



