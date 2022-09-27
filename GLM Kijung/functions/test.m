clear all; %close all;
idAnimal = '20101022';
eval(['load T10_' idAnimal]);
circumf_Encoder = 2.54*8*pi;

load data1022.mat;


%%
% % Identify outliers & replace them by interpolated values (Position)
% VR_pos = y;
% VR_pos_times = double(y_times);
% 
% VR_pos(VR_pos > 1e4) = nan;
% VR_pos_times_nan_excluded = VR_pos_times;
% VR_pos_times_nan_excluded(isnan(VR_pos)) = [];
% VR_pos(isnan(VR_pos)) = [];
% VR_pos = interp1(VR_pos_times_nan_excluded,VR_pos,VR_pos_times);
% 
% % Identify outliers & replace them by interpolated values (Angular encoder)
% ang_pos = double(angular_encoder);
% ang_pos_times = double(angular_encoder_times);
% 
% ang_pos(ang_pos > 460) = nan;
% ang_pos_times_nan_excluded = ang_pos_times;
% ang_pos_times_nan_excluded(isnan(ang_pos)) = [];
% ang_pos(isnan(ang_pos)) = [];
% ang_pos = interp1(ang_pos_times_nan_excluded,ang_pos,ang_pos_times);
% % Identify jitters & replace them by interpolated values (Angular encoder)
% vel = circumf_Encoder/360*diff(ang_pos)./diff(ang_pos_times)*1e6; % cm/s
% idOutlier = find(vel < -360);
% for ii = 1:numel(idOutlier)
%     set(figure,'color','white'); subplot(121);
%     plot(ang_pos_times(idOutlier(ii)-100:idOutlier(ii)+100),...
%                  ang_pos(idOutlier(ii)-100:idOutlier(ii)+100),'k'); hold on;
%     plot(ang_pos_times(idOutlier(ii):idOutlier(ii)+1),...
%          ang_pos(idOutlier(ii):idOutlier(ii)+1),'r');
%     
%     q1 = input(['Choose one of the following pre-processings:' 10 ...
%            '1. Interpolation (jitter)' 10 ...
%            '2. Translocation (backward-step)' 10 ...
%            '-> ']);
%     tmp = sprintf('\n'); disp(tmp);
%     
%     if q1 == 1
%         ang_pos_wo_outlier = ang_pos;
%         ang_pos_wo_outlier(idOutlier(ii)) = [];
%         t_interp = ang_pos_times(idOutlier(ii));
%         ang_pos_times_wo_outlier = ang_pos_times;
%         ang_pos_times_wo_outlier(idOutlier(ii)) = [];
%         pos_interp = interp1(ang_pos_times_wo_outlier,ang_pos_wo_outlier,t_interp);
%         ang_pos(idOutlier(ii)) = pos_interp;
%     else
%         for n_transloc = 1:1e4
%             if ang_pos(idOutlier(ii)+n_transloc) > 280, break; end
%         end
%         ang_pos(idOutlier(ii)+1:idOutlier(ii)+n_transloc-1) =...
%         ang_pos(idOutlier(ii)+1:idOutlier(ii)+n_transloc-1)-100+460;
%     end
%     subplot(122);
%     plot(ang_pos_times(idOutlier(ii)-100:idOutlier(ii)+100),...
%          ang_pos(idOutlier(ii)-100:idOutlier(ii)+100),'k');
%     pause;
%     close;
% end

% Make the periodic ang_pos non-periodic
revolve_ind = find(diff(ang_pos) > 180);
revolve_ind = [0; revolve_ind; length(ang_pos)];
ang_pos_continuous(1) = ang_pos(1);
for rv = 1:numel(revolve_ind)-1
    ang_pos_1rev = ang_pos( revolve_ind(rv)+1 : revolve_ind(rv+1) );
    ang_pos_continuous = [ang_pos_continuous; ang_pos_continuous(end)+cumsum(diff(ang_pos_1rev))];
    
    if rv < numel(revolve_ind)-1
        ang_pod_diff_btw_revs = ang_pos(revolve_ind(rv+1)+1) - ang_pos(revolve_ind(rv+1));
        ang_pod_diff_btw_revs = ang_pod_diff_btw_revs - 360;
        ang_pos_continuous = [ang_pos_continuous; ang_pos_continuous(end)+ang_pod_diff_btw_revs];
    end
end

% Convert ang_pos into cm
VR_pos_in_ang_pos = interp1(ang_pos_times,ang_pos_continuous,VR_pos_times);

lap_ind = find(diff(VR_pos) < -0.5*(max(VR_pos)-min(VR_pos)));
lap_ind = [0; lap_ind; length(VR_pos)];
for lap = 1:numel(lap_ind)-1
    VR_pos_1Lap_in_ang_pos = VR_pos_in_ang_pos( lap_ind(lap)+1 : lap_ind(lap+1) );
    VR_pos_in_cm{lap,1} = [VR_pos(lap_ind(lap)+1); VR_pos(lap_ind(lap)+1)+cumsum(-diff(VR_pos_1Lap_in_ang_pos)/360*circumf_Encoder)];
    VR_pos_time_cell{lap,1} = VR_pos_times( lap_ind(lap)+1 : lap_ind(lap+1) );
end

%%
pos_cm = cell2mat(VR_pos_in_cm);
pos_cm = pos_cm - min(pos_cm);
plot(VR_pos_times,pos_cm); hold on;

pos_quake = VR_pos - min(VR_pos);
pos_quake = pos_quake/max(pos_quake)*max(pos_cm);
plot(VR_pos_times,pos_quake,'r');







