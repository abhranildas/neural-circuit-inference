function [Relative_phase] = project_obliq(Displacement, Param)
if size(Displacement,2) == 1,
    Displacement = Displacement';
end

lambda1 = Param(1);
lambda2 = Param(2);
psi1 = Param(3);
psi2 = Param(4);

e1 = [cos(psi1) sin(psi1)];
e2 = [cos(psi2) sin(psi2)];

t = Displacement - (Displacement*e2')*e2;
% if any(t*e1' == 0) %sum(t == [0 0]) == 2
%     phase1(t*e1' == 0) = 0;
% else
    phase1 = sum(t.^2,2) ./ (t*e1') ./ lambda1;
    phase1(t*e1' == 0) = 0;
% end

t = Displacement - (Displacement*e1')*e1;
% if t*e2' == 0 %sum(t == [0 0]) == 2
%     phase2 = 0;
% else
    phase2 = sum(t.^2,2) ./ (t*e2') ./ lambda2;
    phase2(t*e2' == 0) = 0;
% end
Relative_phase = [phase1,phase2];