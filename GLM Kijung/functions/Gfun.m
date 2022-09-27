function [ F ] = Gfun( x,xdata )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    F = x(1)*exp(-(xdata{1}.^2+xdata{2}.^2)/(2*x(2)^2)) + x(3);

end

