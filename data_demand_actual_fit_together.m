set(0,'DefaultFigureWindowStyle','docked');
load('data_demand_unpinned.mat');
%% Error bars
errbars=zeros(numel(data_demand),1);
for i=1:numel(data_demand)
    errbars(i)=std(data_demand(i).spikecounts)/sqrt(numel(data_demand(i).spikecounts));
end
err_sens=errbars(1:9);
err_mem=errbars(10:end);
%% Whole plot + sensory side fit

sWlist=[data_demand.sW];
sW_sens=sWlist(1:10);
sW_mem=sWlist(10:end);

data_demand_list=[data_demand.meanspikecount];
data_demand_sens=data_demand_list(1:10);
data_demand_mem=data_demand_list(10:end);

figure(1)
plot(sW_sens,data_demand_sens,'.','MarkerSize',20,'Color',[.5 .5 .5]);
hold on

p1=polyfit(log10(sW_sens),log10(data_demand_sens),1);
fit1x=.0004:.0001:sW_mem(1);
fit1y=10^p1(2)*fit1x.^p1(1);
plot(fit1x,fit1y,'LineWidth',2,'Color',[.5 .5 .5]);

plot(sW_mem,data_demand_mem,'.','MarkerSize',20,'Color','k');

%legend('Low weights', sprintf('Fit: Data = %.1fw^{%.1f}',[p1.Coefficients(2),p1.Coefficients(1)]), 'High weights');
%xlabel('Weight strength \omega');
ylabel({'data volume','(total spike count)'});
xlim([0 .017]);
ylim([3e5 1e8]);
%set(gca, 'xscale', 'log');
set(gca, 'yscale', 'log');
set(gca, 'FontSize', 13);

%% memory side fit
[xData, yData] = prepareCurveData( sW_mem, data_demand_mem );

% Set up fittype and options.
ft = fittype( 'a*(b-x)^c', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [27.799 0.0166 -1.679];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
h = plot( fitresult, xData, yData );


fit2x=sW_mem(1):.0001:.02;
fit2y=10.^(p2(1)*(fit2x-sW_mem(1))+p2(2))+data_demand_mem(1);
%plot(fit2x,fit2y,'LineWidth',2,'Color','k');
%legend('Low weights', '', 'High weights','');
%legend boxoff
box off
%hold off
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

p2=polyfit(sW_mem_diff,data_demand_mem_diff_log,1);
fit2x=0:1e-3:.006;
fit2y=p2(1)*fit2x +p2(2);

figure(4)
plot(sW_mem_diff,data_demand_mem_diff_log,'.','MarkerSize',25);
hold on
plot(fit2x,fit2y,'LineWidth',1,'Color',[68 114 196]/255);
hold off

legend('Data points',sprintf('Fit: dData=10^{%.1f + %.0f dw} ',[p2.Coefficients(2),p2.Coefficients(1)])); 
xlim([1e-3 5.5e-3]);
ylim([4 8]);
xlabel('\Delta\omega');
ylabel('\DeltaData');
%title('Data demand on the memory side');