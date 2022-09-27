set(0,'DefaultFigureWindowStyle','docked');

load 'data_demand.mat'
load 'nsb_entropies_at_data_demand.mat'
load 'nsb_entropies.mat'

figure
plot(nsb_entropies_at_data_demand(:,2),[data_demand.meanspikecount],'-o');
set(gca, 'yscale', 'log');
xlabel 'NSB entropy'
ylabel 'Data demand (total spike count) for fixed inference error'

figure
plot(nsb_entropies_at_data_demand(:,1),[data_demand.meanspikecount],'-o');
set(gca, 'yscale', 'log');
xlabel 'Weight strength \omega'
ylabel 'Data demand (total spike count) for fixed inference error'

figure
plot(nsb_entropies(:,1),nsb_entropies(:,2),'-o');
hold on
plot(nsb_entropies_at_data_demand(:,1),nsb_entropies_at_data_demand(:,2),'-o');
hold off
xlabel 'Weight strength \omega'
ylabel 'NSB entropy'

