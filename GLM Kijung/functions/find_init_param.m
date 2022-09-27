%%% find_init_param %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Find out the initial grid parameters of template lattice
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Init_param] = find_init_param(Lpeak,Center)

[gx,gy] = ginput(1);
[~, ind] = sort(sqrt(sum((repmat([gx gy],size(Lpeak,1),1) - Lpeak).^2,2)));
p1 = Lpeak(ind(1),:);
plot(p1(1),p1(2),'r*');

[gx,gy] = ginput(1);
[~, ind] = sort(sqrt(sum((repmat([gx gy],size(Lpeak,1),1) - Lpeak).^2,2)));
p2 = Lpeak(ind(1),:);
plot(p2(1),p2(2),'r*'); drawnow;

del = p2 - Center;
[theta1,lambda1] = cart2pol(del(1),del(2));

del = p1 - Center;
[theta4,lambda4] = cart2pol(del(1),del(2));
Init_param = [lambda1 lambda4 theta1 theta4];

