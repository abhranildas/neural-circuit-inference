function [power_spectral_density,phase_angle] = compute_psd_1d(Frate,Lzeropad)
if size(Frate,1) == 1, Frate = Frate'; end

% PSD
frNorm = bsxfun(@minus,Frate,mean(Frate,1));
Y = fft(frNorm,Lzeropad)/Lzeropad;
power_spectral_density = Y.*conj(Y);
%power_spectral_density = bsxfun(@times,power_spectral_density,1./max(power_spectral_density,[],1));

%Phase Angle
phase_angle = angle(Y);
%phase_angle(phase_angle<0) = 2*pi + phase_angle(phase_angle<0);
