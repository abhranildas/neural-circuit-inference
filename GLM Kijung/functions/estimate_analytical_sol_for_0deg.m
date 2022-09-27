function [Lambda_Theta_Phase] = estimate_analytical_sol_for_0deg(peakLoc,phase_ang,Lzeropad)

k2 = peakLoc/Lzeropad;
k3 = peakLoc/Lzeropad;
phi2 = phase_ang;
phi3 = phase_ang;

% pks2 vs pks3
theta = 0;
lambda = (cos(theta)-sin(theta)/sqrt(3))/k2;
freqD = [1/lambda -1/sqrt(3)/lambda;
         1/lambda  1/sqrt(3)/lambda];
phaseShift = freqD\[phi2; phi3]/(2*pi);
absPhase = project_obliq(phaseShift, [lambda lambda pi/3 0]);
absPhase = mod(absPhase,1);
Lambda_Theta_Phase = [lambda theta absPhase];


