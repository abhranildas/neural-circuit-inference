set(0,'DefaultFigureWindowStyle','docked');
load('ising_inference_data_full_flat.mat');
[xData, yData, zData] = prepareSurfaceData(data(:,1),data(:,2),data(:,6));
sf = fit( [xData, yData], zData, 'thinplateinterp', 'Normalize', 'on' );
%Or use Thin-plate spline interpolant with centering and scaling from the
%curve fitting toolbox. This code is doing the same thing.
[xq,yq] = meshgrid(.001:.001:.05, 4.4:.3:8);

zq = sf(xq,yq);

figure(1);
surf(xq,yq,zq);
alpha 0.8
hold on
plot3(data(:,1),data(:,2),data(:,6),'.','MarkerSize',10,'MarkerEdgeColor','black','MarkerFaceColor','black');
hold off
xlim([0 .05]);
ylim([4.4 8.1]);
set(gca,'Xdir','reverse');
view([193 29]);
%zlim([0.7 2.7]);
%ax=gca;
%ax.XTick = [1 49];
% gca.YTickLabel = {'1', '50'};
xlabel('Weight strength \omega');
ylabel('log_{10} (Total spike count)');
zlabel('log_{10} (Inference error)');
%title('Accuracy of Inverse Ising');
%% Contours of data
figure(2);
contourf(xq,zq,yq,10);
%zlim([0 .05]);
%set(gca,'CLim',[8 10])
xlabel('Weight strength \omega');
ylabel('log_{10} (Inference error)');
c=colorbar;
c.Label.String = 'log_{10} (Total spike count)';
%title('Accuracy of Inverse Ising');

% ax1 = gca;
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XTick',[],...
%     'YAxisLocation','right',...
%     'Color','none',...
%     'YColor','r');
% line(patterncurve(:,1),patterncurve(:,2),'Parent',ax2,'Color','r','MarkerEdgeColor','r','MarkerFaceColor','r')
% ylabel(ax2,'Autocorrelation');
%% %% Contours of weight strength
figure(3);
contour(yq,zq,xq,40);
hidden on;
hold on
contour(yq,zq,xq,[.005 .02],'LineWidth',4);
hold off
xlabel('log_{10} (spike count)');
ylabel('log_{10} (Reconstruction error)');
c=colorbar;
c.Label.String = 'Weight strength \omega';
%% %% Contours of weight strength modified
figure(3);
sens_trend=data(data(:,1)==.001,[2 6]);
mem_trend=data(data(:,1)==.05,[2 6]);
plot(sens_trend(:,1),sens_trend(:,2), 'Marker', '.', 'LineWidth',2, 'MarkerSize', 30, 'Color',[112 173 71]/255);
hold on
plot(mem_trend(:,1),mem_trend(:,2), 'Marker', '.', 'LineWidth',2, 'MarkerSize', 30, 'Color',[68 114 196]/255);
hold off
xlim([4.4 8.1]);
xlabel('log_{10} (Total spike count)');
%ylabel('log_{10} (Reconstruction error)');
legend('Sensory (\omega=.001)', 'Memory (\omega=.05)','location','northeast');
box off
%% Contours of Reconstruction Error
f=figure(4);
contourf(xq,yq,zq,10);
hold on
load('data_demand_points.mat');
p1=polyfit(log10(data_demand_sens(:,1)),data_demand_sens(:,2),1);
fit1x=.001:.001:.035;
fit1y=p1(1)*log10(fit1x)+p1(2);
plot(fit1x,fit1y,'LineWidth',2,'Color','k');
plot(data_demand_sens(:,1),data_demand_sens(:,2),'o','MarkerSize',7,'MarkerFaceColor',[112 173 71]/255,'MarkerEdgeColor','k');

p2=polyfit(log10(data_demand_mem(:,1)),data_demand_mem(:,2),1);
fit2x=.001:.001:.035;
fit2y=p2(1)*log10(fit2x)+p2(2);
plot(fit2x,fit2y,'LineWidth',2,'Color','k');
plot(data_demand_mem(:,1),data_demand_mem(:,2),'o','MarkerSize',7,'MarkerFaceColor',[68 114 196]/255,'MarkerEdgeColor','k');

hold off
%xlim([0.001 .035]);
ylim([5.5 8]);
%set(gca,'xscale','linear');
%set(gca,'CLim',[7 13]);
xlabel('Weight strength \omega');
ylabel('log_{10} (Total spike count)');
c=colorbar;
c.Label.String = 'log_{10} (Inference error)';
%title('Accuracy of Inverse Ising');

%set(f, 'WindowButtonMotionFcn', @(obj, event)cursorLocation(obj, event, 'BottomLeft', ' X: %.3f\n Y: %.3f', 'r'))