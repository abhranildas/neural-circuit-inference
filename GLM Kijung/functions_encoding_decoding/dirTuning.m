function [dir_tuning_curve,dir_bin_centers] = dirTuning(hdir,nspk)
dir_bin_size = deg2rad(1); % unit:[rad]
dir_bin_centers = -pi+dir_bin_size:dir_bin_size:pi;
% Compute the animal's visit frequency at each directional bin
visit_freq = hist(hdir,dir_bin_centers);
% Compute the frequency of spikes at the same bin
spike_freq = hist(hdir(nspk==1),dir_bin_centers);
% Normalize the spike frequency
visit_freq( visit_freq==0 ) = 1;
normalized_spike_freq = spike_freq./visit_freq;
% Compute the rate map
sig = 10;
Gkernel = 1/sqrt(2*pi)/sig*exp(-0.5*(-4*sig:4*sig).^2/sig^2);
dir_tuning_curve = conv(normalized_spike_freq, Gkernel,'same');
%polar(dir_bin_centers,dir_tuning_curve);