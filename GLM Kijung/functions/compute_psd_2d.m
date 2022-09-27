function [power_spectral_density,phase_angle] = compute_psd_2d(Frate,Lzeropad)
frNorm = Frate - mean(Frate(:));
Y = fft2(frNorm,Lzeropad,Lzeropad)/Lzeropad;
Y = fftshift(Y);
power_spectral_density = Y.*conj(Y);
phase_angle = angle(Y);
