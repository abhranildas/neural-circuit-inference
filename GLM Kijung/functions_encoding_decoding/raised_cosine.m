%clear all; close all;

ihbasprs.ncols = 10;
ihbasprs.hpeaks = [1 100];
ihbasprs.b = 1;
dt = .1; % For pictorial purpose
%dt = 1; % For computing purpose
[iht,ihbasOrthog,ihbasis] = makeBasis_PostSpike(ihbasprs,dt);
set(figure,'color','white');
plot(iht, ihbasis);axis tight;box off; set(gca,'tickdir','out');
xlabel('Time after spike (ms)','fontsize',20);
title('Pose-spike filter basis','fontsize',20);
z=sum(ihbasis,2);
z(1:10)