function [Lattice] = generate_larger_lattice(Ratemap,Init_param,newBnd)

[my,mx] = size(Ratemap);
% Search for local peaks
lp = imregionalmax(Ratemap);
[r,c] = find(lp == 1);

Lpeak1D = sub2ind(size(Ratemap),r,c);
thrshold = max(Ratemap(:))/100;
ind = find(Ratemap(Lpeak1D)<thrshold);
Lpeak1D(ind) = [];
[I,J] = ind2sub(size(Ratemap),Lpeak1D);
Lpeak = [J I];

for ii = 1:size(Lpeak,1)
    fr(ii,1) = Ratemap(Lpeak(ii,1),Lpeak(ii,2));
end
center = Lpeak(fr==max(fr),:);
maxXY = [mx my];

% Estimate the grid parameters
x0 = [Init_param(2) Init_param(1) -Init_param(4) -Init_param(3) center];
center = fit_lattice_ratemap(x0,Ratemap,Lpeak,maxXY);

p1 = [ Init_param(1)*cos(Init_param(3)) Init_param(1)*sin(Init_param(3)) ];
p2 = [ Init_param(2)*cos(Init_param(4)) Init_param(2)*sin(Init_param(4)) ];
Lattice = generate_lattice(p1,p2,[center(1) maxXY(2)-center(2)],[0 0],newBnd);

% figure;
% imagesc(Ratemap); hold on; axis equal;
% plot(Lpeak(:,1),Lpeak(:,2),'k*');
% figure;
% plot(Lattice(:,1),Lattice(:,2),'ro'); hold on; axis equal;
% plot(Lpeak(:,1),maxXY(2)-Lpeak(:,2),'k*');
