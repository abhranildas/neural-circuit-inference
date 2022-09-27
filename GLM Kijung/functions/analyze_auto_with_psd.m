%function [Grid_param_auto,Ratemap] = analyze_auto(TRAJ,SPIKE_INDEX_1,Sigma_kernel,Init_param_c1)
function [Grid_param_auto,Ratemap] = analyze_auto_with_psd(TRAJ,SPIKE_LOC,Sigma_kernel,Init_param_c1)

% Define spatial bin size
spatial_bin_size = 1; % unit:[cm]    
max_boundary_X = ceil(max(TRAJ(:,1))); 
max_boundary_Y = ceil(max(TRAJ(:,2)));
% Generate locations of bin centers
spatial_bin_centers = {spatial_bin_size/2:spatial_bin_size:max_boundary_X-spatial_bin_size/2,...
                       spatial_bin_size/2:spatial_bin_size:max_boundary_Y-spatial_bin_size/2};
% Create 2-D Guassian kernel
Gkernel = fspecial('gaussian', 8*Sigma_kernel/spatial_bin_size, Sigma_kernel/spatial_bin_size);
% Extract spike locations of two cells
%SPIKE_LOC = TRAJ(SPIKE_INDEX_1,:);

% Compute the Ratemap
Ratemap = compute_ratemap(TRAJ,SPIKE_LOC,Gkernel,spatial_bin_centers);

% Compute the autocorrelogram, and estimate grid parameters
if nargin < 3
    tmp = sprintf('The number of input arguments is less than 3!\n'); disp(tmp);
elseif nargin == 3
    % Plot an animal's trajectory superimposed by spike locations
    
    set(figure,'color','white');
    subplot(151);
    plot(TRAJ(:,1),TRAJ(:,2),'color',[192 192 192]/255,'markersize',1); hold on;
    plot(SPIKE_LOC(:,1),SPIKE_LOC(:,2),'r.','markersize',2); 
    axis equal; axis tight; set(gca,'visible','off');
    set(gca,'xtick',[]); set(gca,'ytick',[]);
    
    subplot(152);
    imagesc(Ratemap); 
    axis equal; axis tight; set(gca,'xtick',[]); set(gca,'ytick',[]); set(gca,'visible','off');

    [autocorr,lpeak,lattice,Grid_param_auto] = estimate_lattice_autocorr(Ratemap);

    % Plot autocorrelogram
    subplot(153);
    imagesc(autocorr); hold on; plot(lpeak(:,1),lpeak(:,2),'k*'); axis equal;
    cx = max_boundary_X; cy = max_boundary_Y;
    line([cx cx],[1 2*cy-1],'color','k'); line([1 2*cx-1],[cy cy],'color','k');
    set(gca,'xtick',[]); set(gca,'ytick',[]); set(gca,'visible','off'); axis tight;

    % Plot the best-fit template lattice
    subplot(154);
    plot(lattice(:,1),lattice(:,2),'ro'); hold on;
    lpeak = [lpeak(:,1) 2*max_boundary_Y-lpeak(:,2)];
    plot(lpeak(:,1),lpeak(:,2),'k*');
    line([cx cx],[1 2*cy-1],'color','k'); line([1 2*cx-1],[cy cy],'color','k');
    axis equal; axis tight; set(gca,'xticklabel',[]); set(gca,'yticklabel',[]);
    set(gca,'xtick',[]); set(gca,'ytick',[]);
    title(['(\lambda_1,\lambda_2,\psi_1,\psi_2) = (' sprintf('%.0f,%.0f,', Grid_param_auto(1),Grid_param_auto(2))...
            sprintf('%.0f',rad2deg(Grid_param_auto(3))) '\circ,' sprintf('%.0f',rad2deg(Grid_param_auto(4))) '\circ)']);

    % Plot 2d PSD
    subplot(155);
    psd_2d = compute_psd_2d(Ratemap,2^12);
    imagesc(psd_2d(2^11-500:2^11+500,2^11-500:2^11+500)); axis equal;
    set(gca,'visible','off'); set(gca,'YDir','normal');
    set(gca,'xtick',[]); set(gca,'ytick',[]); axis tight;
    
    set(gcf,'position',[0 0 1300 150]);
    

    
elseif nargin >= 5
    tmp = sprintf('Please check the number of input arguments!\n'); disp(tmp);
else
    init_param = [Init_param_c1(2) Init_param_c1(1) -Init_param_c1(4) -Init_param_c1(3)];
    [autocorr,lpeak,lattice,Grid_param_auto] = estimate_lattice_autocorr(Ratemap,init_param);
end
