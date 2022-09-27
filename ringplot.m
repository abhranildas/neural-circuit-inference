th = (0:N-1)/N*2*pi;
x = cos(th);
y = sin(th);

f = abs(fft(ones(10,1),N));

stem3(x,y,(data(end,N+2:end))','fill')
view([-65 30])
