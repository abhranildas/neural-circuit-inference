function [Z] = conv2Dfft(X,Y)

[Ax,Ay] = size(X);
[Bx,By] = size(Y);

if any(any(imag(X))) || any(any(imag(Y)))
    Z = ifft2(fft2(X,Ax+Bx-1,Ay+By-1).*fft2(Y,Ax+Bx-1,Ay+By-1));
else
    Z = real(ifft2(fft2(X,Ax+Bx-1,Ay+By-1).*fft2(Y,Ax+Bx-1,Ay+By-1)));
end

px = ((Bx-1)+mod((Bx-1),2))/2;
py = ((By-1)+mod((By-1),2))/2;

Z = Z(px+Ax:-1:px+1,py+1:py+Ay);
