function [Lambda_Theta_Phase] = estimate_analytical_sol_for_30deg(peakLoc,phase_ang,Lzeropad)

k1 = peakLoc/Lzeropad;
k2 = peakLoc/Lzeropad;
phi1 = phase_ang;
phi2 = phase_ang;

% pks1 vs pks2
lambda = sqrt(1/(k1^2+k1*k2+k2^2));
theta = pi/6;
freqD = [0         2/sqrt(3)/lambda;
         1/lambda -1/sqrt(3)/lambda];
phaseShift = freqD\[phi1; phi2]/(2*pi);
absPhase = project_obliq(phaseShift, [lambda lambda pi/3 0]);
absPhase = mod(absPhase,1);
Lambda_Theta_Phase = [lambda theta absPhase];



