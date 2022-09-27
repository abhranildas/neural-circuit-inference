for reset_time=110:10:190
    run('grid_cells_ring_reset.m');
    save(sprintf('binnedspikes_unbinarized_unpinned_reset/reset_%d.mat',reset_time),'binnedspikes','-v7.3');
    J=glm_inf_binned(binnedspikes);
    save(sprintf('binnedspikes_unbinarized_unpinned_reset/J_%d.mat',reset_time),'J');
end