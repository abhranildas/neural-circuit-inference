tic

N=2;
load('W100.mat');


sW=100;

J=sW*W;
J(logical(eye(N)))=0;
J=[0 1; 1 0];


b=[0,ones(1,N-1)]*1;
b=[1 1];

nsamp=1e5;

x=datasample([-1 1],N);
xl=[];

for i=1:nsamp
    for j=randperm(N)        
        xnew=x;
        xnew(j)=-xnew(j);
        %a=ising_prob(xnew,W,b)/ising_prob(x,W,b)
        %Acceptance probability (ratio of ising probabilities):
        a=exp(-2*x(j)*(2*sum(J(j,:).*x)+b(j)));
        if unifrnd(0,1)<a
            x=xnew;
        end        
    end
    xl=[xl; x];
%     stem(x);
%     drawnow
end

figure(1)
plot(mean(xl))
ylim([-1 1]);
figure(2)
plot(mean(xl,2));
ylim([-1 1]);

toc

[u,~,idx]=unique(xl,'rows');
counts=histc(idx,1:size(u,1));
counts=counts/sum(counts);
flipud([u, counts])