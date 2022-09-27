function [strctPred1D] = extract_slice_numerically(theta,alpha,absPhase,strctData)
ratemap = strctData.ratemap;
pnts_rhomb = strctData.pnts_rhomb;
gridparam = strctData.gridparam;
mX1D = strctData.mX1D;

p1_ref = [pnts_rhomb(1,1)+absPhase(1)*gridparam(1)*cos(gridparam(3))...
pnts_rhomb(1,2)+absPhase(1)*gridparam(1)*sin(gridparam(3))];

p2_ref = [pnts_rhomb(1,1)+absPhase(2)*gridparam(2)*cos(gridparam(4))...
pnts_rhomb(1,2)+absPhase(2)*gridparam(2)*sin(gridparam(4))];

strpnt = p1_ref + ( p2_ref-pnts_rhomb(1,:) );
endpnt = strpnt + mX1D/alpha*[cos(theta) sin(theta)];

yi = [strpnt(2) endpnt(2)];
xi = [strpnt(1) endpnt(1)];
[cx,cy,cut] = improfile(ratemap,xi,yi,'bilinear');
domain_slice = [0; cumsum(sqrt(diff(cx).^2+diff(cy).^2))];
slice1D = interp1(alpha*domain_slice,cut,0:mX1D-1);

strctPred1D = struct('slice1D',slice1D,'strpnt',strpnt,'endpnt',endpnt);







