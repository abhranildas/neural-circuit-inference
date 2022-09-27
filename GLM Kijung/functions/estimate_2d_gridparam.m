function [Param_auto,Ratemap,RE_spike_locs] = estimate_2d_gridparam(idAnimal,strctParams,init_params)
eval(['load data_' idAnimal '/T10_' idAnimal]);
pathway = ['data_' idAnimal '/T10*c*.mat'];
files = dir(pathway);
Ncell = length(files);
sd2DKernel = strctParams.sd2DKernel;

for gcell = 1:Ncell
    eval(['load data_' idAnimal '/' files(gcell).name]);
    RE_spike_x = interp1(RE_position_times_microsec,RE_x_cm,RE_spike_times_microsec);
    RE_spike_y = interp1(RE_position_times_microsec,RE_y_cm,RE_spike_times_microsec);
    RE_spike_locs{gcell} = [RE_spike_x,RE_spike_y];
    if nargin == 2
        [grid_param_auto,ratemap] = analyze_auto_with_psd([RE_x_cm,RE_y_cm],RE_spike_locs{gcell},sd2DKernel);
    elseif nargin == 3
        [grid_param_auto,ratemap] = analyze_auto_with_psd([RE_x_cm,RE_y_cm],RE_spike_locs{gcell},sd2DKernel,init_params);        
    else
        tmp = sprintf('Please check the number of input arguments!\n'); disp(tmp);
    end
    Param_auto(gcell,:) = grid_param_auto;
    Ratemap{gcell,1} = ratemap;
    
%     % Graphical purpose only
%     eval(['mkdir data_' idAnimal '/gridparam2D']);
%     eval(['export_fig data_' idAnimal '/gridparam2D/' files(gcell).name(1:end-4) ' -pdf']); close;
    eval(['export_fig data_' idAnimal '/' files(gcell).name(1:end-4) ' -pdf']); close;

end
