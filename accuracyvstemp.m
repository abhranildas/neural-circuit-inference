load('thresholds.mat');
subsample=false;
criticalcurve=[];
for temp=1:size(thresholds,1)    
    sW=thresholds(temp,1); threshold=(thresholds(temp,2));
    run('grid_cells_ring.m');
    binnedspikes0=binnedspikes;
    maxdatasize=size(binnedspikes0,1);
    errvsdata=[];
    for datasize=round(maxdatasize/10:maxdatasize/10:maxdatasize)
        datasize
        binnedspikes=binnedspikes0(1:datasize,:);        
        run('runme_ising_from_simulation.m');
        run('postprocess_Jnew.m');
        errvsdata=[errvsdata; [datasize,err]];
    end    
    criticalcurve(:,:,temp)=errvsdata;       
end
figure();
% criticalcurve=sortrows(criticalcurve);
hold on
for i=1:size(thresholds,1) 
    plot(criticalcurve(:,1,i),criticalcurve(:,2,i),'-o');
end
hold off
% xlabel('Strength of Recurrent Connections');
% ylabel('Inference Error (Euclidean Distance');
% title('Inference Accuracy vs Temperature');
% clear sW threshold
figure();
plot(criticalcurve(1,1,:),criticalcurve(1,2,:),'-o');