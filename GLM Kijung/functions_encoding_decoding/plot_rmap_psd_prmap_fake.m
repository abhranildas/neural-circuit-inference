clear all; close all; setpath;

gridparam = [20 20 pi/3 0]; % lambda1 lambda2 psi1 psi2
sd_2dKernel = 3;
size_frate_2d = 2.6*gridparam(1);
Lzeropad = 2^7+1;
structParams = struct('gridparam',gridparam,'sd_2dKernel',sd_2dKernel,'size_frate_2d',size_frate_2d);
[ratemap_2d,~,pnts_rhomb] = make_ratemap_2d(structParams);
Ly = size(ratemap_2d,1);
Lx = size(ratemap_2d,2);
structData = struct('ratemap',ratemap_2d,'pnts_rhomb',pnts_rhomb,'gridparam',gridparam);

subplot(141);
imagesc(ratemap_2d);axis equal;axis tight;
set(gca,'YDir','normal');%'xtick',[],'ytick',[],
title('Ratemap','fontsize',12);
%%
% pos = 10*rand(1e4,2);
% [SpaceBasis] = makeBasis_Space(pos,ratemap_2d,Lzeropad);
%%
[fftpsd,phase_angle] = compute_psd_2d(ratemap_2d,Lzeropad);
subplot(142);
imagesc(fftpsd);axis equal;axis tight; set(gca,'YDir','normal'); hold on;
fcentre = round(Lzeropad/2);
line([1 Lzeropad],[fcentre fcentre],'color','k');
line([fcentre fcentre],[1 Lzeropad],'color','k');
title('PSD','fontsize',12);
subplot(143);
imagesc(phase_angle);axis equal;axis tight; set(gca,'YDir','normal'); hold on;
line([1 Lzeropad],[fcentre fcentre],'color','k');
line([fcentre fcentre],[1 Lzeropad],'color','k');
title('Phase angle','fontsize',12);

subplot(144);
[fy_sig,fx_sig] = find(fftpsd >= 0.01*max(fftpsd(:)));
fftpsd_sig = fftpsd(sub2ind(size(phase_angle),fy_sig,fx_sig));
phase_sig = phase_angle(sub2ind(size(phase_angle),fy_sig,fx_sig));
%phase_sig = roundAt(phase_sig,-1);
fy_sig = (fy_sig - fcentre)/Lzeropad;
fx_sig = (fx_sig - fcentre)/Lzeropad;

% For further reducing the number of basis functions
% fftpsd_sig(fy_sig<0) = [];
% phase_sig(fy_sig<0) = [];
% fx_sig(fy_sig<0) = [];
% fy_sig(fy_sig<0) = [];

[X,Y] = meshgrid(1:Ly,1:Lx);
XY = [X(:) Y(:)];
ratemap_reconst = repmat(sqrt(fftpsd_sig),1,Lx*Ly) .* cos(2*pi*[fx_sig fy_sig]*XY' + repmat(phase_sig,1,Lx*Ly));
ratemap_reconst = sum(ratemap_reconst,1);
ratemap_reconst = reshape(ratemap_reconst',Ly,Lx);
imagesc(ratemap_reconst);axis equal;axis tight;
set(gca,'YDir','normal');%'xtick',[],'ytick',[],
title('Reconstructed ratemap','fontsize',12);


set(gcf,'color','white','position',[0 0 1000 700]);
% eval(['export_fig R' num2str(radius) '_Ph' num2str(absPhase(1)) ' -pdf']); close;


