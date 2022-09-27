T=150; dt=1; tau=10; p=.1;
data=[];
s=0;
for t=0:dt:T
    sigma=rand()<p;
    sdot=sigma-s/tau;
    s=s+sdot*dt;
    data =[data; [t 4*sigma s]];
end

stem(data(:,1),data(:,2),'Marker','none')
%ylim([0 1.3]);
hold on
plot(data(:,1),data(:,3))
hold off
title('Spiking Neuron');
xlabel('t (ms)');
ylabel('\sigma, s');
legend('\sigma (fast spikes)','s (slow activation)');
