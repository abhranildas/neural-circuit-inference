function [Ratemap] = compute_ratemap(TRAJ,SpikeLoc,Gkernel,Spatial_bin_centers)

% Compute the animal's visit frequency at each spatial bin
visit_freq = hist3(TRAJ,'ctrs',Spatial_bin_centers)';
% Compute the frequency of spikes at the same bin
spike_freq = hist3(SpikeLoc,'ctrs',Spatial_bin_centers)';
% Normalize the spike frequency
visit_freq( visit_freq==0 ) = 1;
normalized_spike_freq = spike_freq./visit_freq;
% Compute the rate map
Ratemap = conv2Dfft(normalized_spike_freq, Gkernel);
