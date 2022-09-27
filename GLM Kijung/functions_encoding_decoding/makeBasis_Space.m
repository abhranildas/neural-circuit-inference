function [fBasis,funcSpaceCos,funcSpaceSin] = makeBasis_Space(dataIn)
Ncell = length(dataIn.Ratemap);
ratemap_2d = dataIn.Ratemap;
Lzeropad = dataIn.Lzeropad;
Nfreq = dataIn.Nfreq;

fftpsd_sum = 0;
for gcell = 1:Ncell
    [fftpsd,~] = compute_psd_2d(ratemap_2d{gcell},Lzeropad);
    fftpsd_sum = fftpsd_sum + fftpsd;
end
fftpsd = fftpsd_sum/Ncell;
[~,idx] = sort(fftpsd(:),'descend');
[fy_sig,fx_sig] = ind2sub(size(fftpsd),idx(1:Nfreq));

fcentre = round(Lzeropad/2);
fy_sig = (fy_sig - fcentre)/Lzeropad;
fx_sig = (fx_sig - fcentre)/Lzeropad;
%% For further reducing the number of basis functions
id = fy_sig < 0;
fx_sig(id) = [];
fy_sig(id) = [];

id = (fy_sig==0)&(fx_sig<=0);
fx_sig(id) = [];
fy_sig(id) = [];
%%
fBasis = [fx_sig fy_sig]; % Nfreq by 2

% pos: T by 2
% fBasis: N by 2
funcSpaceCos = @(pos,fBasis) cos(2*pi*repmat(pos*fBasis',1,1));
funcSpaceSin = @(pos,fBasis) sin(2*pi*repmat(pos*fBasis',1,1));

