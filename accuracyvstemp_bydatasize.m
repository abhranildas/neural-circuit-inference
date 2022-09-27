load('thresholds.mat');
criticalcurve=[];
for temp=1:size(thresholds,1)    
    sW=thresholds(temp,1);
    threshold=(thresholds(temp,3));
    run('grid_cells_ring.m');    
    run('runme_ising_from_simulation.m');
    run('postprocess_Jnew.m');
    criticalcurve=[criticalcurve; [sW, binnedspikelimit,err]];      
end
figure();
plot(criticalcurve(:,1),criticalcurve(:,3),'-o');