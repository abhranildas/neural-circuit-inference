function [Lpeak] = find_local_peaks(X,threshold)
lp = imregionalmax(X);
[r,c] = find(lp == 1);
Lpeak1D = sub2ind(size(X),r,c);
% Set up threshold
thrshold = max(X(:))*threshold/100;
ind = find(X(Lpeak1D)<thrshold);
Lpeak1D(ind) = [];

[~,idsort] = sort(X(Lpeak1D),'descend');
Lpeak1D = Lpeak1D(idsort);
[I,J] = ind2sub(size(X),Lpeak1D);
Lpeak = [J I];