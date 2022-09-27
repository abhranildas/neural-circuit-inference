function [dataIn,dataOut] = plot_rmap_psd_prmap_data(dataIn)
position_x = dataIn.position_x;
position_y = dataIn.position_y;
nspk = dataIn.nspk;

position_x = position_x - min(position_x); 
position_y = position_y - min(position_y);
dataIn.position_x = position_x;
dataIn.position_y = position_y;
%%
% set(figure,'color','white');
% subplot(351);
% plot(position_x,position_y,'k'); axis equal; box off; axis tight; hold on;
% plot(position_x(nspk==1),position_y(nspk==1),'r.','markersize',7);
% set(gca,'tickdir','out');
% title('Spike map','fontsize',12);
%%
sd_2dKernel = 3;
L = ceil(max(max(position_x),max(position_y)));
% Define spatial bin size
spatial_bin_size = 1; % unit:[cm]    
% Generate locations of bin centers
Spatial_bin_centers = {spatial_bin_size/2:spatial_bin_size:L-spatial_bin_size/2,...
                       spatial_bin_size/2:spatial_bin_size:L-spatial_bin_size/2};
Gkernel = fspecial('gaussian', ceil(8*sd_2dKernel/spatial_bin_size), sd_2dKernel/spatial_bin_size);

Ratemap = compute_ratemap([position_x position_y],[position_x(nspk==1) position_y(nspk==1)],Gkernel,Spatial_bin_centers);
Ratemap = flipud(Ratemap);

cntr = [L,L]/2; r = L/2;
[row, col] = ind2sub(size(Ratemap),(1:length(Ratemap)^2)');
row_prime = row - cntr(2);
col_prime = col - cntr(1);
Iblank = find(row_prime.^2+col_prime.^2-r.^2 > 0);
% Ratemap_figure = Ratemap;
% Ratemap_figure(sub2ind(size(Ratemap),row(Iblank),col(Iblank))) = nan;

% subplot(352);
% imagesc(Ratemap_figure,'AlphaData',~isnan(Ratemap_figure));
% axis equal; axis tight; box off; hold on;
% set(gca,'tickdir','out','YDir','normal');
% title('Rate map','fontsize',12);
%%
Lzeropad = 2^nextpow2(max(size(Ratemap)))+1;
dataIn.Lzeropad = Lzeropad;
dataIn.Ratemap = Ratemap;
dataOut = reconst_ratemap_from_psd(dataIn);
dataOut.Iblank = Iblank;

% subplot(353);
% imagesc(dataOut.fftpsd);
% axis equal; axis tight; box off; hold on;
% set(gca,'tickdir','out','YDir','normal');
% fcentre = round(Lzeropad/2);
% line([1 Lzeropad],[fcentre fcentre],'color','w');
% line([fcentre fcentre],[1 Lzeropad],'color','w');
% title('PSD','fontsize',12);
%%
% subplot(354);
% imagesc(dataOut.phAngle);
% axis equal;axis tight; box off; hold on;
% set(gca,'tickdir','out','YDir','normal');
% line([1 Lzeropad],[fcentre fcentre],'color','w');
% line([fcentre fcentre],[1 Lzeropad],'color','w');
% title('Phase angle','fontsize',12);
%%
% subplot(355);
% ratemap_reconst_figure = dataOut.ratemap_reconst;
% ratemap_reconst_figure(sub2ind(size(Ratemap),row(Iblank),col(Iblank))) = nan;
% imagesc(ratemap_reconst_figure,'AlphaData',~isnan(ratemap_reconst_figure));
% axis equal;axis tight; box off; hold on;
% set(gca,'tickdir','out','YDir','normal');
% title('Reconstructed ratemap','fontsize',12);

