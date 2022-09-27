function [coeff,dBs] = encode_gridcells(Data,Params)
position_x = Data.position_x;
position_y = Data.position_y;
Y = Data.Y;
Dxy = Data.Dxy;

modelName = Params.modelName;
isLasso = Params.isLasso;
Nfreq = Params.Nfreq;
Ncell = Params.Ncell;
dt = Params.dt;
Tinit = Params.Tinit;
Tend = Params.Tend;
spkTrain = full(Y);

dataIn.position_x = position_x(Tinit:Tend);
dataIn.position_y = position_y(Tinit:Tend);
dataIn.dt = dt;
dataIn.Nfreq = Nfreq;

for gcell = 1:Ncell
    dataIn.nspk = spkTrain(Tinit:Tend,gcell);
    [dataIn,~] = plot_rmap_psd_prmap_data(dataIn);
    Ratemap{gcell,1} = dataIn.Ratemap;
%     fftpsd{gcell,1} = dataOut.fftpsd;
%     phAngle{gcell,1} = dataOut.phAngle;
%     ratemap_reconst{gcell,1} = dataOut.ratemap_reconst;
end
dataIn.nspk = spkTrain(Tinit:Tend,1:Ncell);
dataIn.Ratemap = Ratemap;
dataIn.Dxy = Dxy;
% dataOut.fftpsd = fftpsd;
% dataOut.phAngle = phAngle;
% dataOut.ratemap_reconst = ratemap_reconst;

speed = abs(diff(position_x) + 1i*diff(position_y))/dt;
speed = [speed; speed(end)];
hdir = angle(diff(position_x) + 1i*diff(position_y));
hdir = [hdir; hdir(end)];
dataIn.speed = speed(Tinit:Tend);
dataIn.hdir = hdir(Tinit:Tend);
clearvars -except dataIn modelName isLasso Nfreq Ncell dt Tinit Tend Dxy row col
%% Fit GLM

[dBs,output] = MLfit_GLM(modelName,isLasso,dataIn);

%% Show fitting results
if isLasso
    min1pts = find(output(:,FitInfo.Index1SE));
    coeff = zeros(size(output,1),1);
    coeff(min1pts) = output(min1pts,FitInfo.Index1SE);
    coeff = [FitInfo.Intercept(FitInfo.Index1SE); coeff];
else
    coeff = output.Coefficients.Estimate;
    %pvalue = output.Coefficients.pValue;
    %coeff(~(pvalue<=0.01))=0;
end

for gcell = 1:Ncell
%     figure(gcell);
    
    % Spatial Tuning
%     [Ly,Lx] = size(dataIn.Ratemap{1});
%     [X,Y] = meshgrid(1:Ly,1:Lx);
%     XspaceCos = dBs.funcSpaceCos([X(:) Y(:)],dBs.fBasis);
%     XspaceSin = dBs.funcSpaceSin([X(:) Y(:)],dBs.fBasis);
%     Xspace = [XspaceCos XspaceSin];
    if strcmp(modelName,'space') == 1
%         ratemap_reconst = Xspace*coeff(dBs.n_totalb*(gcell-1)+gcell+1:...
%                                        dBs.n_totalb*(gcell-1)+gcell+dBs.n_fb);
    else
        cff_gcell = coeff(2:dBs.n_fb+1);
        cff_gcell = reshape(cff_gcell,dBs.n_fb/2,2); % n_fb/2 by 2

        phi = atan2(-cff_gcell(:,2),cff_gcell(:,1)); % n_fb/2 by 1
        amp = sqrt(sum(cff_gcell.^2,2));

        phi_new = (2*pi*(-Dxy(gcell,:))*dBs.fBasis')' + phi;
        cff_new{gcell,1} = [amp.*cos(phi_new); -amp.*sin(phi_new)];

%         ratemap_reconst = Xspace*cff_new{gcell,1};
    end
%     ratemap_reconst = reshape(ratemap_reconst,Ly,Lx);

%     subplot(3,5,12);
%     [row, col] = ind2sub(size(ratemap_reconst),(1:length(ratemap_reconst)^2)');
%     ratemap_reconst_figure = ratemap_reconst;
%     ratemap_reconst_figure(sub2ind(size(ratemap_reconst_figure),...
%                            row(dataOut.Iblank),col(dataOut.Iblank))) = nan;
%     imagesc(ratemap_reconst_figure,'AlphaData',~isnan(ratemap_reconst_figure));
%     axis equal; axis tight; box off; hold on;
%     set(gca,'tickdir','out','YDir','normal');
%     title('Spatial tuning','fontsize',12);
%     % colordata = colormap;
%     % colordata(end,:) = [1 1 1];
%     % colormap(colordata);
    
    if strcmp(modelName,'space_shared') == 1 && gcell == Ncell
        temp = [];
        for gc = 1:Ncell
            temp = [temp; coeff(1); cff_new{gc}];
        end
        coeff = temp;
    end
    
    if strcmp(modelName,'stimAll')==1 || strcmp(modelName,'history')==1
        % Speed Tuning
%         subplot(3,5,8);
%         [speed_tuning,speed_bin_centers] = speedTuning(dataIn.speed,dataIn.nspk(:,gcell));
%         plot(speed_bin_centers,speed_tuning,'ko'); 
%         box off; axis tight; hold on; set(gca,'tickdir','out');
%         X = [speed_bin_centers' ones(length(speed_bin_centers),1)];
%         linreg = (X'*X)\X'*speed_tuning';
%         line([0 max(dataIn.speed)],[linreg(2) linreg(2)+linreg(1)*max(dataIn.speed)],'color','k','linewidth',2);
%         xlabel('Speed (cm/s)','fontsize',12); ylabel('Firing rate (Hz)','fontsize',12);
%         title(['Speed tuning' 10 'slope = ' num2str(linreg(1))],'fontsize',12);
%         ylim([0 max(speed_tuning)]);
%         
%         subplot(3,5,13);
%         line([0,max(dataIn.speed)],[linreg(2) linreg(2)+coeff(1+dBs.n_fb+dBs.n_sb)*max(dataIn.speed)],'linewidth',2);
%         hold on; axis tight; set(gca,'tickdir','out');
%         line([0 max(dataIn.speed)],[linreg(2) linreg(2)+linreg(1)*max(dataIn.speed)],'color','k','linewidth',2);
%         ylim([0 max(speed_tuning)]);
%         title(['slope = ' num2str(coeff(1+dBs.n_fb+dBs.n_sb))],'fontsize',12);
%         xlabel('Speed (cm/s)','fontsize',12); ylabel('Intensity','fontsize',12);
        
        % Directional Tuning
%         subplot(3,5,9);
%         [dir_tuning_curve,dir_bin_centers] = dirTuning(dataIn.hdir,dataIn.nspk(:,gcell));
%         polar(dir_bin_centers,dir_tuning_curve,'k');
%         title('Directional tuning','fontsize',12);
%         xlabel('Orientation (deg)','fontsize',12); ylabel('Intensity','fontsize',12);
        
%         subplot(3,5,14);
%         hdir = (-pi+pi/180:pi/180:pi)';
%         Xhdir = makeBasis_Direction(hdir);
        cfdir_new{gcell,1} = coeff(1+dBs.n_fb+dBs.n_sb+(gcell-1)*dBs.n_db+1:1+dBs.n_fb+dBs.n_sb+gcell*dBs.n_db);
%         dir_tuning = Xhdir*cfdir_new{gcell,1};
% 
%         polar(hdir,dir_tuning-min(dir_tuning));
%         box off; axis tight; set(gca,'tickdir','out');
%         xlabel('Orientation (deg)','fontsize',12); ylabel('Intensity','fontsize',12);
    end
    
    if strcmp(modelName,'stimAll') == 1 && gcell == Ncell
        temp = [];
        for gc = 1:Ncell
            temp = [temp; coeff(1); cff_new{gc}; coeff(1+dBs.n_fb+dBs.n_sb); cfdir_new{gc}];
        end
        coeff = temp;
    end
    
    % Post-spike effect
    if strcmp(modelName,'history')==1
%         subplot(3,5,10);
%         [autocorr,lags] = xcov(dataIn.nspk(:,gcell),200,'coef');
%         plot(0:(numel(lags)-1)/2,autocorr(ceil(numel(lags)/2):end),'k'); box off; set(gca,'tickdir','out');
%         xlim([-10 numel(lags)/2]);
%         title('Autocorrelation','fontsize',12);
% 
%         subplot(3,5,15);
        cfhistory = coeff(1+dBs.n_fb+dBs.n_sb+Ncell*dBs.n_db+1:1+dBs.n_fb+dBs.n_sb+Ncell*dBs.n_db+dBs.n_hb);
%         refractory = dBs.historyBasis*cfhistory;
%         
%         plot(1:numel(refractory)-1,refractory(2:end)); box off; axis tight; hold on;
%         plot(1:(numel(lags)-1)/2,autocorr(ceil(numel(lags)/2)+1:end),'k');
%         ylim([min(refractory)-0.2 max(refractory)+1]); xlim([-10 length(refractory)]);
%         set(gca,'tickdir','out');
%         title('Post-spike effect','fontsize',12);
%         xlabel('Time after spike (ms)','fontsize',12); ylabel('Intensity','fontsize',12);
    end
    
    if strcmp(modelName,'history') == 1 && gcell == Ncell
        temp = [];
        for gc = 1:Ncell
            temp = [temp; coeff(1); cff_new{gc}; coeff(1+dBs.n_fb+dBs.n_sb); cfdir_new{gc}; cfhistory];
        end
        coeff = temp;
    end

    %set(figure(gcell),'position',[0 0 2300 800]);
    %eval(['export_fig cell' num2str(gcell) '_' modelName '_lasso' num2str(isLasso) '_nfreq' num2str(Nfreq) ' -pdf']);
    close;
    % if isLasso
    %     eval(['save data_' modelName '_lasso' num2str(isLasso) '_thrsh' num2str(dataIn.threshold) '.mat -append dataIn dBs']);
    % else
    %     eval(['save data_' modelName '_lasso' num2str(isLasso) '_thrsh' num2str(dataIn.threshold) '.mat -append output dataIn dBs']);
    % end
end