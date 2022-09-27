function [Template_ratemap,Lattice,vtx_rhomb] = generate_template_ratemap(Ratemap,gridparam,mX1D)

Ncell = length(Ratemap);
% Define spatial bin size
spatial_bin_size = 1; % unit:[cm]    
% Generate locations of bin centers
spatial_bin_centers = {spatial_bin_size/2:spatial_bin_size:mX1D-spatial_bin_size/2,...
                       spatial_bin_size/2:spatial_bin_size:mX1D-spatial_bin_size/2};

v1 = [ gridparam(1)*cos(gridparam(3)) gridparam(1)*sin(gridparam(3)) ];
v2 = [ gridparam(2)*cos(gridparam(4)) gridparam(2)*sin(gridparam(4)) ];
Lattice = generate_lattice(v1,v2,[0 0],[0 0],[mX1D mX1D]);

for gcell = 1:Ncell
    [my,mx] = size(Ratemap{gcell});
    autocorr = normxcorr2(Ratemap{gcell},Ratemap{gcell});

    ydata = autocorr(my-10:my+10,mx-10:mx+10);
    [tmp1,tmp2] = meshgrid(-10:10);
    xdata{1} = tmp1;
    xdata{2} = tmp2;
    z = lsqcurvefit(@Gfun,[1 1 0],xdata,ydata);
    sd_autocorr = z(2);
    sd_ratemap(gcell) = sqrt(sd_autocorr^2/2);
end
sd_avg_ratemap = sqrt(mean(sd_ratemap.^2));
Gkernel = fspecial('gaussian', ceil(8*sd_avg_ratemap/spatial_bin_size), sd_avg_ratemap/spatial_bin_size);
vertex_map = hist3(Lattice,'ctrs',spatial_bin_centers)';
Template_ratemap = conv2Dfft(vertex_map, Gkernel);
Template_ratemap = Template_ratemap/max(Template_ratemap(:));

% Plot ratemap with a unit cell 
set(figure,'color','white');
imagesc(Template_ratemap); axis equal; hold on;
set(gca,'ydir','normal');
Lpeak = find_local_peaks(Template_ratemap,50);

[~,I] = min(sum((Lpeak - repmat(mX1D/2*[1 1],size(Lpeak,1),1)).^2,2));
vtx_rhomb(1,:) = Lpeak(I,:);
vtx_rhomb(2,:) = [vtx_rhomb(1,1)+gridparam(1)*cos(gridparam(3)) vtx_rhomb(1,2)+gridparam(1)*sin(gridparam(3))];
vtx_rhomb(3,:) = [vtx_rhomb(1,1)+gridparam(2)*cos(gridparam(4)) vtx_rhomb(1,2)+gridparam(2)*sin(gridparam(4))];
vtx_rhomb(4,:) = vtx_rhomb(2,:)+[vtx_rhomb(3,:)-vtx_rhomb(1,:)];

line([vtx_rhomb(1,1) vtx_rhomb(2,1)],[vtx_rhomb(1,2) vtx_rhomb(2,2)],'color','k','linewidth',2);
line([vtx_rhomb(1,1) vtx_rhomb(3,1)],[vtx_rhomb(1,2) vtx_rhomb(3,2)],'color','k','linewidth',2);
line([vtx_rhomb(2,1) vtx_rhomb(4,1)],[vtx_rhomb(2,2) vtx_rhomb(4,2)],'color','k','linewidth',2);
line([vtx_rhomb(3,1) vtx_rhomb(4,1)],[vtx_rhomb(3,2) vtx_rhomb(4,2)],'color','k','linewidth',2);

