L=100;
nbasis=10;
peakloc=L;

ihbasprs.ncols = nbasis;
ihbasprs.hpeaks = [1 peakloc];
ihbasprs.b = 1;
dt = 1; % For computing purpose
[iht,ihbasOrthog,basis] = makeBasis_PostSpike(ihbasprs,dt);

[base_w,~] = fminunc(@(base_w)a_gap(a,basis,base_w,L),zeros(nbasis,1),options);
a_basis=basis*base_w;
a_basis=a_basis(1:L);
figure(1)
plot(a)
hold on
plot(a_basis)
hold off
% figure(2)
% hold on
% stem(base_w)
% hold off