function [DirBasis] = makeBasis_Direction(hdir)
if size(hdir,2) ~= 1
    hdir = hdir'; % T by 1
end
hdir(hdir==-pi) = pi;
T = size(hdir,1);

M = [-0.5  1.5 -1.5  0.5;
        1 -2.5    2 -0.5;
     -0.5    0  0.5    0;
        0    1    0    0];
dth = 30;%(deg)
knots = 0:dth:180;
knots = union(knots,-knots);
knots = [knots(1) knots knots(end)]';
knots = deg2rad(knots);
Nbasis = numel(knots);
[idKnot,~]=find((diff(bsxfun(@le,hdir,knots'),[],2)~=0)');
u = (hdir-knots(idKnot))/deg2rad(dth);
uM = [u.^3 u.^2 u ones(T,1)]*M; % T by 4
DirBasis = zeros(T,Nbasis); % T by Nbasis

colsub = [idKnot-1 idKnot idKnot+1 idKnot+2];
rowsub = repmat((1:T)',1,4);
linearInd = sub2ind([T,Nbasis],rowsub(:),colsub(:));
DirBasis(linearInd) = uM(:);

