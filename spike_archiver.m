%load thresholds_rand_symm
for r=10.^linspace(-2,2,10) %r_idx=13:15
    %sW=thresholds(r_idx,1)
    %threshold=thresholds(r_idx,2);
    %run('grid_cells_rand_symm.m');
    run('chaotic_randomnet.m');
    %save(sprintf('binnedspikes_rand_symm/sW %.4f %d.mat',[sW iter]),'binnedspikes','-v7.3');
    save(sprintf('data_chaotic_net_sparse/r %.2f.mat',r),'h','-v7.3');
end
