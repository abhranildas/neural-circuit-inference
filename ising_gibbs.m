load('W100.mat');
W=0*W;
b=[0,ones(1,N-1)]*0;
N=100;
p_flip=.1; %probability of flip
x=randi([0 1],1,N);
xl=[];
al=[];
for i=1:1000
    xnew=x;
    flip=unifrnd(0,1,1,N)<p_flip;
    for j=1:N
    %i=randi([1 numel(xnew)]);
        if flip(j)
            xnew(j)=~xnew(j);
        end
    end
    a=ising_prob(xnew,W,b)/ising_prob(x,W,b);
    al=[al;a];
    if unifrnd(0,1)<a
        x=xnew;
    end
    xl=[xl; x];
%     stem(x);
%     drawnow
end
figure(1)
plot(mean(xl))
ylim([0 1]);
figure(2)
plot(mean(xl,2));
ylim([0 1]);