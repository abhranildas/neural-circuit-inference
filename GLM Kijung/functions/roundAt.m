function [y] = roundAt(x,n)
if n >= 0
    y = round(x/10^n)*10^n;
else
    n = abs(n);
    y = round(x*10^n)/10^n;
end