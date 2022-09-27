function [SpeedBasis] = makeBasis_Speed(speed)
if size(speed,2) ~= 1
    speed = speed'; % T by 1
end
%T = size(speed,1);
%SpeedBasis = [ones(T,1) speed]; % T by 2
SpeedBasis = speed; % T by 1

