function [ratemap,lattice,vtx_rhomb] = make_ratemap_2d(structParams)
gridparam = structParams.gridparam;
sd_2dKernel = structParams.sd_2dKernel;
L = structParams.size_frate_2d;

% Define spatial bin size
spatial_bin_size = 1; % unit:[cm]    
% Generate locations of bin centers
spatial_bin_centers = {spatial_bin_size/2:spatial_bin_size:L-spatial_bin_size/2,...
                       spatial_bin_size/2:spatial_bin_size:L-spatial_bin_size/2};

v1 = [ gridparam(1)*cos(gridparam(3)) gridparam(1)*sin(gridparam(3)) ];
v2 = [ gridparam(2)*cos(gridparam(4)) gridparam(2)*sin(gridparam(4)) ];
lattice = generate_lattice(v1,v2,[0 0],[0 0],[L L]);

Gkernel = fspecial('gaussian', ceil(8*sd_2dKernel/spatial_bin_size), sd_2dKernel/spatial_bin_size);
vertex_map = hist3(lattice,'ctrs',spatial_bin_centers)';
ratemap = conv2Dfft(vertex_map, Gkernel);
ratemap = ratemap/max(ratemap(:));

Lpeak = find_local_peaks(ratemap,50);
[~,I] = min((Lpeak(:,1)-L/2).^2 + (Lpeak(:,2)-L/2).^2);
vtx_rhomb(1,:) = Lpeak(I(1),:);
vtx_rhomb(2,:) = [vtx_rhomb(1,1)+gridparam(1)*cos(gridparam(3)) vtx_rhomb(1,2)+gridparam(1)*sin(gridparam(3))];
vtx_rhomb(3,:) = [vtx_rhomb(1,1)+gridparam(2)*cos(gridparam(4)) vtx_rhomb(1,2)+gridparam(2)*sin(gridparam(4))];
vtx_rhomb(4,:) = vtx_rhomb(2,:)+vtx_rhomb(3,:)-vtx_rhomb(1,:);

% set(figure,'color','white');
% imagesc(ratemap); axis equal; hold on;
% set(gca,'ydir','normal');
% line([vtx_rhomb(1,1) vtx_rhomb(2,1)],[vtx_rhomb(1,2) vtx_rhomb(2,2)],'color','k','linewidth',2);
% line([vtx_rhomb(1,1) vtx_rhomb(3,1)],[vtx_rhomb(1,2) vtx_rhomb(3,2)],'color','k','linewidth',2);
% line([vtx_rhomb(2,1) vtx_rhomb(4,1)],[vtx_rhomb(2,2) vtx_rhomb(4,2)],'color','k','linewidth',2);
% line([vtx_rhomb(3,1) vtx_rhomb(4,1)],[vtx_rhomb(3,2) vtx_rhomb(4,2)],'color','k','linewidth',2);

