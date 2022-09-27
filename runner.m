criticalcurve=[];
for sW=[.0001 .0005 .001 .01 .1]
    run('grid_cells_ring.m');
    run('runme_ising_me.m');
    run('post_process.m');
    criticalcurve=[criticalcurve; [sW, err]];
end