for reset_time=110:10:190
    reset_bins=reset_time/100;
    
    run('grid_cells_ring_reset_ff_0.m');
    save(sprintf('binnedspikes_ub_up_reset_ff_0/reset_%d.mat',reset_time),'binnedspikes','-v7.3');
    
    idx=0:size(binnedspikes,1)-1;
    idx=mod(idx,2*reset_bins)<reset_bins;
    binnedspikes=binnedspikes(idx,:);
    
%     idx=cumsum(sum(binnedspikes,2))<1e8;
%     binnedspikes=binnedspikes(idx,:);
    
    J=glm_inf_binned(binnedspikes);
    save(sprintf('binnedspikes_ub_up_reset_ff_0/J_%d.mat',reset_time),'J');
    
end