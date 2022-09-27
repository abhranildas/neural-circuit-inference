set(0,'DefaultFigureWindowStyle','docked');
N=50;
load('W.mat');

Wclip=W(2:end,2:end);
Wclip(logical(eye(size(Wclip)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
Wclip=(Wclip-min(Wclip(:)))./(max(Wclip(:))-min(Wclip(:)))-1; %rescaling W between -1 and 0

load('thresholds.mat');
for temp=[8 12]
    sW=thresholds(temp,1);
    load(sprintf('binnedspikes100_1e8/sW %.3f.mat',sW));
    binnedspikes=binnedspikes(1:round(size(binnedspikes,1)/1e2),:);
    run('subsampling.m');    
    subsamplecurves(:,:,temp)=subsamplecurve;
    %save subsamplecurves.mat subsamplecurves    
end
figure
hold on
for temp=size(subsamplecurves,3):-1:1
    plot(subsamplecurves(:,1,temp),subsamplecurves(:,2,temp),'-o','MarkerSize',3);    
end
hold off
xlim([2 49]);
ylim([0 45]);
xlabel('Subsample size n (of population 50)');
ylabel('Inference error');

clear temp