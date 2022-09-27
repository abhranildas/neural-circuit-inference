for reset_time=120:10:190
       
    run('grid_cells_ring_reset_randomize.m');
    save(sprintf('binnedspikes_unbinarized_unpinned_reset_I/reset_%d.mat',reset_time),'binnedspikes','-v7.3');
    
    reset_bins=reset_time/100;
    idx=0:size(binnedspikes,1)-1;
    idx=mod(idx,2*reset_bins)<reset_bins;
    binnedspikes=binnedspikes(idx,:);
    
%     idx=cumsum(sum(binnedspikes,2))<1e8;
%     binnedspikes=binnedspikes(idx,:);
    
    J=glm_inf_binned(binnedspikes);
    save(sprintf('binnedspikes_unbinarized_unpinned_reset_I/J_%d.mat',reset_time),'J');
    
end