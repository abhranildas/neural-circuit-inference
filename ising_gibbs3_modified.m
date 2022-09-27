set(0,'DefaultFigureWindowStyle','docked');

tic

sW=100;
noise=1.2; %.3 amplitude of noise
noisesparsity=1.5; %higher means sparser noise WAS 1.5 for good inference
nsamp=5e4;

N=100;
load('W_up_sb.mat');
J=sW*W;
J(logical(eye(N)))=0;
b=[1,ones(1,N-1)]*1;
th=1;

sW/(b(2)*noise)

beta=1;

x=datasample([-1 1],N);
binnedspikes=zeros(nsamp,N);

for i=1:nsamp
    h=b;%.*(1+noise*randn(1,N).*(randn(1,N)>noisesparsity))-th;
    for j=randperm(N)        
%         xnew=x;
%         xnew(j)=-xnew(j);
        %a=ising_prob(xnew,W,b)/ising_prob(x,W,b)
        %Acceptance probability (ratio of ising probabilities):
        a=exp(beta*(-2*x(j)*(2*sum(J(j,:).*x)+h(j))));
        if unifrnd(0,1)<a
            x(j)=-x(j);
        end        
    end
    binnedspikes(i,:)=x;
%     stem(x);
%     %ylim([0 1]);
%     drawnow
end
binnedspikes(binnedspikes==-1)=0;

%figure
plot(sum(binnedspikes)/(size(binnedspikes,1)*.001))
xlim([2 100]);
%ylim([0 1]);
xlabel('Neuron Index');
ylabel('Firing rate (Hz)');
% figure(2)
% plot(mean(samps,2));
% ylim([-1 1]);

toc

% [u,~,idx]=unique(xl,'rows');
% counts=histc(idx,1:size(u,1));
% counts=counts/sum(counts);
% flipud([u, counts]);

N*size(binnedspikes,1)/sum(binnedspikes(:))