%% Whole plot + sensory side fit
set(0,'DefaultFigureWindowStyle','docked');
load('data_demand.mat');

sWlist=[data_demand.sW]/2;
sW_sens=sWlist(1:9);
sW_mem=sWlist(10:end);

data_demand_list=[data_demand.meanspikecount];
data_demand_sens=data_demand_list(1:9);
data_demand_mem=data_demand_list(10:end);

figure(1)
plot(sW_sens,data_demand_sens,'.','MarkerSize',20,'MarkerEdgeColor',[112 173 71]/255);
hold on

p1=polyfitn(log10(sW_sens),log10(data_demand_sens),1);
fit1x=.0005:.001:.0125;
fit1y=10^p1.Coefficients(2)*fit1x.^p1.Coefficients(1);
plot(fit1x,fit1y,'LineWidth',1,'Color',[112 173 71]/255);

plot(sW_mem,data_demand_mem,'.','MarkerSize',20,'MarkerEdgeColor',[68 114 196]/255);

legend('Low weights', sprintf('Fit: Data = %.1fw^{%.1f}',[p1.Coefficients(2),p1.Coefficients(1)]), 'High weights');
xlabel('Weight strength \omega');
ylabel('Data (Total spike count)');
xlim([4e-4 .025]);
ylim([3e5 1e8]);
set(gca, 'xscale', 'log');
set(gca, 'yscale', 'log');
hold off
%title('Data demand at different weights');
%% Sensory side differential plot
sW_sens_diff=.025-sW_sens;
data_demand_sens_diff=data_demand_sens-412032.3;

figure(2)
plot(sW_sens_diff,data_demand_sens_diff,'o');
set(gca, 'yscale', 'log');
set(gca, 'xscale', 'log');
xlim([.001 .03]);
xlabel('\Delta\omega');
ylabel('\DeltaData');

%% Memory side fit
[xData, yData] = prepareCurveData(sW_mem,data_demand_mem);

% Set up fittype and options.
ft = fittype( 'a*x^b+c', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [5e+56 33 0];

% Fit model to data.
[fitresult, gof]=fit(xData,yData,ft,opts);

% Plot fit with data.
figure(3)
h = plot(fitresult,xData,yData);
legend( h, 'Data points', 'untitled fit 1');
xlim([.025 .033]);
xlabel 'Weight strength \omega'
ylabel 'Data volume (total spike count)'
% set(gca, 'yscale', 'log');
% set(gca, 'xscale', 'log');

%% Memory side differential fit
sW_mem_diff=sW_mem-sW_mem(1);
sW_mem_diff=sW_mem_diff(2:end);
data_demand_mem_diff=data_demand_mem-data_demand_mem(1);
data_demand_mem_diff=data_demand_mem_diff(2:end);
data_demand_mem_diff_log=log10(data_demand_mem_diff);

p2=polyfitn(sW_mem_diff,data_demand_mem_diff_log,1);
fit2x=0:1e-3:.006;
fit2y=p2.Coefficients(1)*fit2x +p2.Coefficients(2);

figure(4)
plot(sW_mem_diff,data_demand_mem_diff_log,'.','MarkerSize',25);
hold on
plot(fit2x,fit2y,'LineWidth',1,'Color',[68 114 196]/255);
hold off

legend('Data points',sprintf('Fit: dData=%.1f*10^{%.0f} dw',[p2.Coefficients(2),p2.Coefficients(1)])); 
xlim([1e-3 5.5e-3]);
ylim([4 8]);
xlabel('\Delta\omega');
ylabel('\DeltaData');
%title('Data demand on the memory side');