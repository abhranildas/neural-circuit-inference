function [normalized_spike_freq,speed_bin_centers] = speedTuning(speed,nspk)
speed_bin_size = 5; % unit:[cm/s]
speed_bin_centers = 0:speed_bin_size:ceil(max(speed));
% Compute the animal's visit frequency at each directional bin
visit_freq = hist(speed,speed_bin_centers);
% Compute the frequency of spikes at the same bin
spike_freq = hist(speed(nspk==1),speed_bin_centers);
% Normalize the spike frequency
visit_freq( visit_freq==0 ) = 1;
normalized_spike_freq = spike_freq./visit_freq;
% Compute the rate map
