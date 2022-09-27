figure
plot(phase_traj);
phase_traj=unwrap(phase_traj);
figure
plot(phase_traj);


figure
phase_traj=unwrap(phase_traj);
difftraj=diff(phase_traj);
hist(difftraj,100);
set(gca, 'yscale', 'log');

difftraj(abs(difftraj)>2)=[];
newphase_traj=cumsum(difftraj);

figure
hold on
plot(phase_traj,'.');
plot(newphase_traj,'.');
hold off




spreads=[];
for t=1:200
    dists=zeros(1,size(phase_traj,1)-t);
    for i=1:size(phase_traj,1)-t
        dists(i)=(phase_traj(i+t)-phase_traj(i))^2;
    end
    spreads=[spreads, mean(dists)];
end
figure
plot(spreads,'.');
xlabel('t(\tau/100)');
ylabel('<[\phi(t_{i+\tau})-\phi(t_i)]^2>_i');

fitparams=polyfit(1:200,spreads,1);
refline((fitparams));

legend('Data points', sprintf('Line fit (slope=%f)',fitparams(1)));
title('Diffusion coefficient (\omega=.05)');

fitparams(1)

%diffusivities(7,2)=fitparams(1);