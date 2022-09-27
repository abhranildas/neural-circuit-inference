function [dataOut] = reconst_ratemap_from_psd(dataIn)

Ratemap = dataIn.Ratemap;
Lzeropad = dataIn.Lzeropad;
%threshold = dataIn.threshold;
Nfreq = dataIn.Nfreq;

[fftpsd,phase_angle] = compute_psd_2d(Ratemap,Lzeropad);

[Ly,Lx] = size(Ratemap);
%[fy_sig,fx_sig] = find(fftpsd >= threshold*max(fftpsd(:)));
[~,idx] = sort(fftpsd(:),'descend');
[fy_sig,fx_sig] = ind2sub(size(fftpsd),idx(1:Nfreq));

% temp = sort(fftpsd(:),'descend');
% temp = unique(temp(1:6));
% fy_sig = [];
% fx_sig = [];
% for ii = 1:numel(temp)
%     [y,x] = find(fftpsd==temp(ii));
%     fy_sig = [fy_sig; y];
%     fx_sig = [fx_sig; x];
% end
% temp = unique([fy_sig fx_sig],'rows');
% fy_sig = temp(:,1);
% fx_sig = temp(:,2);

fftpsd_sig = fftpsd(sub2ind(size(phase_angle),fy_sig,fx_sig));
phase_sig = phase_angle(sub2ind(size(phase_angle),fy_sig,fx_sig));
%phase_sig = roundAt(phase_sig,-1);
fcentre = round(Lzeropad/2);
fy_sig = (fy_sig - fcentre)/Lzeropad;
fx_sig = (fx_sig - fcentre)/Lzeropad;
%% For further reducing the number of basis functions
id = fy_sig<0;
fftpsd_sig(id) = [];
phase_sig(id) = [];
fx_sig(id) = [];
fy_sig(id) = [];

id = (fy_sig==0)&(fx_sig<=0);
fftpsd_sig(id) = [];
phase_sig(id) = [];
fx_sig(id) = [];
fy_sig(id) = [];
%%
[X,Y] = meshgrid(1:Ly,1:Lx);
XY = [X(:) Y(:)];
ratemap_reconst = repmat(sqrt(fftpsd_sig),1,Lx*Ly) .* cos(2*pi*[fx_sig fy_sig]*XY' + repmat(phase_sig,1,Lx*Ly));
ratemap_reconst = sum(ratemap_reconst,1);
ratemap_reconst = reshape(ratemap_reconst',Ly,Lx);

dataOut.fftpsd = fftpsd;
dataOut.phAngle = phase_angle;
dataOut.ratemap_reconst = ratemap_reconst;

