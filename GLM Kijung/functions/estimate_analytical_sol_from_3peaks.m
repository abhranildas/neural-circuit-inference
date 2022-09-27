function [Lambda_Theta_Phase] = estimate_analytical_sol_from_3peaks(peakLocs,phase_ang,Lzeropad)
k1 = peakLocs(1)/Lzeropad;
k2 = peakLocs(2)/Lzeropad;
k3 = peakLocs(3)/Lzeropad;
phi1 = phase_ang(1);
phi2 = phase_ang(2);
phi3 = phase_ang(3);

% pks1 vs pks2
lambda = sqrt(1/(k1^2+k1*k2+k2^2));
theta = asin(sqrt(3)*lambda*k1/2);
freqD = [0         2/sqrt(3)/lambda;
         1/lambda -1/sqrt(3)/lambda];
phaseShift = freqD\[phi1; phi2]/(2*pi);
absPhase = project_obliq(phaseShift, [lambda lambda pi/3 0]);
absPhase = mod(absPhase,1);
Lambda_Theta_Phase(1,:) = [lambda theta absPhase];
% % pks1 vs pks3
% lambda = sqrt(1/(k1^2-k1*k3+k3^2));
% theta = asin(sqrt(3)*lambda*k1/2);
% freqD = [0         2/ sqrt(3)/lambda;
%          1/lambda  1/sqrt(3)/lambda];
% phaseShift = freqD\[phi1; phi3]/(2*pi);
% absPhase = project_obliq(phaseShift, [lambda lambda pi/6 0]);
% absPhase = mod(absPhase,1);
% Lambda_Theta_Phase(2,:) = [lambda theta absPhase];
% % pks2 vs pks3
% theta = atan((k3+k2)/(k3-k2)/sqrt(3));
% theta = pi/2 - theta;
% lambda = (cos(theta)-sin(theta)/sqrt(3))/k2;
% freqD = [1/lambda -1/sqrt(3)/lambda;
%          1/lambda  1/sqrt(3)/lambda];
% phaseShift = freqD\[phi2; phi3]/(2*pi);
% absPhase = project_obliq(phaseShift, [lambda lambda pi/6 0]);
% absPhase = mod(absPhase,1);
% Lambda_Theta_Phase(3,:) = [lambda theta absPhase];


