function [Relative_phase,Param_avg] = estimate_2d_phasediff(Param_auto,Ratemap)

Ncell = numel(Ratemap);
% lambda = mean(vertcat(Param_auto(:,1),Param_auto(:,2)));
% theta1 = mean(Param_auto(:,3));
% theta2 = theta1 - pi/3;
% Param_avg = [lambda lambda theta1 theta2];
Param_avg = mean(Param_auto,1);
Rel_phase = cell(0);

for gcellA = 1:Ncell-1
    for gcellB = gcellA+1:Ncell       
        [~,relative_phase] = analyze_cross_fixed_grid_param(Ratemap{gcellA},Ratemap{gcellB},Param_avg);
        close all;
        %saveas(gcf,['data_' ratID '/image2D/c' num2str(gcellA) 'c' num2str(gcellB) '_cross'],'fig');close;
        Relative_phase{gcellA,gcellB} = relative_phase;
    end
end
