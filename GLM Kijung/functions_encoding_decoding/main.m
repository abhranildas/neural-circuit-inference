function [] = main(modelName,isLasso,threshold)
close all;
setpath;
load data.mat
dt = 5e-4;

dataIn.position_x = position_x;
dataIn.position_y = position_y;
dataIn.nspk = c64;
dataIn.dt = dt;
%dataIn.threshold = 0.5; % 2d freq to be considered
dataIn.threshold = threshold;
dataIn = plot_rmap_psd_prmap_data(dataIn);

speed = abs(diff(position_x) + 1i*diff(position_y))/dt;
speed = [speed; speed(end)];
hdir = angle(diff(position_x) + 1i*diff(position_y));
hdir = [hdir; hdir(end)];
dataIn.speed = speed;
dataIn.hdir = hdir;
clearvars -except dataIn modelName isLasso threshold
%eval(['export_fig input_' modelName '_lasso' num2str(isLasso) '_thrsh' num2str(dataIn.threshold) ' -pdf']);
%% Fit GLM
%modelName = 'history';
%isLasso = false;
dBs = MLfit_GLM(modelName,isLasso,dataIn);
%% Show fitting results
eval(['load data_' modelName '_lasso' num2str(isLasso) '_thrsh' num2str(threshold) '.mat']);

if isLasso
    min1pts = find(B(:,FitInfo.Index1SE));
    beta = zeros(size(B,1),1);
    beta(min1pts) = B(min1pts,FitInfo.Index1SE);
    beta = [FitInfo.Intercept(FitInfo.Index1SE); beta];
else
    beta = output.Coefficients.Estimate;
    %pvalue = output.Coefficients.pValue;
    %beta(~(pvalue<=0.01))=0;
end

Nf = 2*size(dBs.fBasis,1);
[Ly,Lx] = size(dataIn.Ratemap);
[X,Y] = meshgrid(1:Ly,1:Lx);
XspaceCos = dBs.funcSpaceCos([X(:) Y(:)],dBs.fBasis);
XspaceSin = dBs.funcSpaceSin([X(:) Y(:)],dBs.fBasis);
Xspace = [XspaceCos XspaceSin];
ratemap_reconst = [ones(size(Xspace,1),1) Xspace]*beta(1:Nf+1);
ratemap_reconst = reshape(ratemap_reconst,Ly,Lx);

subplot(3,5,12);
imagesc(ratemap_reconst); axis equal; box off; hold on;
set(gca,'tickdir','out','YDir','normal'); axis tight;
title('Spatial tuning','fontsize',12);
cntr = [Lx,Ly]/2; r = max(Lx,Ly)/2;
bx = r*cos(0:pi/180:2*pi);
by = r*sin(0:pi/180:2*pi);
plot(cntr(1)+bx,cntr(2)+by,'k');
% colordata = colormap;
% colordata(end,:) = [1 1 1];
% colormap(colordata);
if strcmp(modelName,'stimAll')==1 || strcmp(modelName,'history')==1
    % Speed Tuning
    subplot(3,5,8);
    [speed_tuning,speed_bin_centers] = speedTuning(dataIn.speed,dataIn.nspk);
    plot(speed_bin_centers,speed_tuning,'ko'); box off; axis tight; hold on; set(gca,'tickdir','out');
    X = [speed_bin_centers' ones(length(speed_bin_centers),1)];
    linreg = (X'*X)\X'*speed_tuning';
    line([0 max(dataIn.speed)],[linreg(2) linreg(2)+linreg(1)*max(dataIn.speed)],'color','k','linewidth',2);
    xlabel('Speed (cm/s)','fontsize',12); ylabel('Firing rate (Hz)','fontsize',12);
    title(['Speed tuning' 10 'slope = ' num2str(linreg(1))],'fontsize',12);
    ylim([0 max(speed_tuning)]);
    subplot(3,5,13);
    line([0,max(dataIn.speed)],[linreg(2) linreg(2)+beta(Nf+2)*max(dataIn.speed)],'linewidth',2); axis tight; hold on;
    line([0 max(dataIn.speed)],[linreg(2) linreg(2)+linreg(1)*max(dataIn.speed)],'color','k','linewidth',2);
    ylim([0 max(speed_tuning)]);set(gca,'tickdir','out');
    title(['slope = ' num2str(beta(Nf+2))],'fontsize',12);
    xlabel('Speed (cm/s)','fontsize',12); ylabel('Intensity','fontsize',12);
    % Directional Tuning
    subplot(3,5,9);
    [dir_tuning_curve,dir_bin_centers] = dirTuning(dataIn.hdir,dataIn.nspk);
    polar(dir_bin_centers,dir_tuning_curve,'k');
    title('Directional tuning','fontsize',12);
    xlabel('Orientation (deg)','fontsize',12); ylabel('Intensity','fontsize',12);
    subplot(3,5,14);
    hdir = (-pi+pi/180:pi/180:pi)';
    Xhdir = makeBasis_Direction(hdir);
    Ndir = size(Xhdir,2);
    dir_tuning = Xhdir*beta(Nf+3:Nf+Ndir+2);
    polar(hdir,dir_tuning-min(dir_tuning)); box off; axis tight;
    set(gca,'tickdir','out');
    xlabel('Orientation (deg)','fontsize',12); ylabel('Intensity','fontsize',12);
end
% % Post-spike effect
if strcmp(modelName,'history')==1
    subplot(3,5,10);
    [autocorr,lags] = xcov(dataIn.nspk,200,'coef');
    plot(0:(numel(lags)-1)/2,autocorr(ceil(numel(lags)/2):end),'k'); box off; set(gca,'tickdir','out');
    xlim([-10 numel(lags)/2]);
    title('Autocorrelation','fontsize',12);
    
    subplot(3,5,15);
    refractory = dBs.historyBasis*beta(Nf+Ndir+3:end);
    plot(1:numel(refractory)-1,refractory(2:end)); box off; axis tight; hold on;
    plot(1:(numel(lags)-1)/2,autocorr(ceil(numel(lags)/2)+1:end),'k');
    ylim([min(refractory)-0.2 max(refractory)+1]); xlim([-10 length(refractory)]);
    set(gca,'tickdir','out');
    title('Post-spike effect','fontsize',12);
    xlabel('Time after spike (ms)','fontsize',12); ylabel('Intensity','fontsize',12);
end
%
set(gcf,'color','white','position',[0 0 2300 800]);
eval(['export_fig fit_' modelName '_lasso' num2str(isLasso) '_thrsh' num2str(dataIn.threshold) ' -pdf']);close;
if isLasso
    eval(['save data_' modelName '_lasso' num2str(isLasso) '_thrsh' num2str(dataIn.threshold) '.mat -append dataIn dBs']);
else
    eval(['save data_' modelName '_lasso' num2str(isLasso) '_thrsh' num2str(dataIn.threshold) '.mat -append output dataIn dBs']);
end
