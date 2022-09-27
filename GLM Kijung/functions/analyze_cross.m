function [Grid_param_cross,Relative_phase] = analyze_cross(Ratemap_c1,Ratemap_c2,Param_auto_c1,Param_auto_c2)
% Compute the crosscorrelogram, and estimate grid parameters
if nargin ~= 4
    tmp = sprintf('The number of input arguments is not 4!\n'); disp(tmp);
elseif nargin == 4
    init_param_c1 = [Param_auto_c1(2) Param_auto_c1(1) -Param_auto_c1(4) -Param_auto_c1(3)];
    init_param_c2 = [Param_auto_c2(2) Param_auto_c2(1) -Param_auto_c2(4) -Param_auto_c2(3)];
    init_param = mean([init_param_c1;init_param_c2]);
    [xcorr,lpeak,lattice,Grid_param_cross,phi,center,center_lattice] = estimate_lattice_xcorr(Ratemap_c1,Ratemap_c2,init_param);
    
    % Plot crosscorrelogram
%     subplot(121);
%     imagesc(xcorr); hold on; plot(lpeak(:,1),lpeak(:,2),'k*');
%     cx = center(1); cy = center(2);
%     line([cx cx],[1 2*cy-1],'color','k'); line([1 2*cx-1],[cy cy],'color','k');
%     axis equal; axis tight; set(gca,'visible','off');
%     % Plot the best-fit template lattice
%     subplot(122);
%     plot(lattice(:,1),lattice(:,2),'ro'); hold on;
%     lpeak = [lpeak(:,1) 2*size(Ratemap_c1,1)-lpeak(:,2)];
%     plot(lpeak(:,1),lpeak(:,2),'k*');
%     plot(center_lattice(1),center_lattice(2),'bo');
%     axis equal; axis tight; set(gca,'xticklabel',[]); set(gca,'yticklabel',[]);
%     set(gca,'xtick',[]); set(gca,'ytick',[]);
%     title({['(\lambda_1,\lambda_2,\psi_1,\psi_2) = (' sprintf('%.0f,%.0f,', Grid_param_cross(1),Grid_param_cross(2))...
%             sprintf('%.0f',rad2deg(Grid_param_cross(3))) '\circ,' sprintf('%.0f',rad2deg(Grid_param_cross(4))) '\circ)']; ...
%             ['(\delta_1,\delta_2) = (' sprintf('%.2f,%.2f',phi(1),phi(2)) ')']});
%     line([cx cx],[1 2*cy-1],'color','k'); line([1 2*cx-1],[cy cy],'color','k');
%     set(gcf,'color','white');
    
end

Relative_phase = phi;