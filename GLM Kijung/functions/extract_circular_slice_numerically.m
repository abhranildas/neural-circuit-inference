function [strctPred1D] = extract_circular_slice_numerically(radius,absPhase,strctData)
ratemap = strctData.ratemap;
pnts_rhomb = strctData.pnts_rhomb;
gridparam = strctData.gridparam;
Nrot = strctData.Nrot;

p1_ref = [pnts_rhomb(1,1)+absPhase(1)*gridparam(1)*cos(gridparam(3))...
pnts_rhomb(1,2)+absPhase(1)*gridparam(1)*sin(gridparam(3))];

p2_ref = [pnts_rhomb(1,1)+absPhase(2)*gridparam(2)*cos(gridparam(4))...
pnts_rhomb(1,2)+absPhase(2)*gridparam(2)*sin(gridparam(4))];

center = p1_ref + ( p2_ref-pnts_rhomb(1,:) );

[X,Y] = meshgrid(1:size(ratemap,1));
th = 0:1/radius:Nrot*pi;
xunit = radius * cos(th) + center(1);
yunit = radius * sin(th) + center(2);
circular_slice = interp2(X,Y,ratemap,xunit,yunit);


strctPred1D = struct('circular_slice',circular_slice,'circular_profile',[xunit' yunit'],'center',center);







