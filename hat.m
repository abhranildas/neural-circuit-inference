function y=hat(x)
    global a1; global a2; global sigma1; global sigma2;
    y = a1*(exp(-(x)^2/(2*sigma1^2)) - a2*exp(-(x)^2/(2*sigma2^2))); 
end

%fplot(@hat,[-10,10])
