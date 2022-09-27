function [coherence] = compute_coherence(FrateA,FrateB,Lzeropad)
frNormA = FrateA - mean(FrateA);
frNormB = FrateB - mean(FrateB);

YA = fft(frNormA,Lzeropad)/Lzeropad;
YB = fft(frNormB,Lzeropad)/Lzeropad;

coherence = mean(YA.*conj(YB))*mean(YB.*conj(YA))/mean(YA.*conj(YA))/mean(YB.*conj(YB));
