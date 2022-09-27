% motiation: look for temporal oscillation (theta-like) in firing rates
% conclusion: if we look at population firing at an instant, there is a
% spatial oscillation across the pattern. But if we track the firing rate
% of a single neuron vs time, there's no temporal oscillation. 

%clear all; close all;
n=100; %800; 
r=3; %1.6; % go from below 1 to 2 in steps

dt=0.1; % in ms 
tau=10; % in ms
T=1e4; % in ms
niter=T/dt;

% h=normrnd(0,1,niter,n); % neuron rates
h=zeros(niter,n); % neuron rates

% periodic pulse b:
% tOn=1; tOff=5;
% nOn=tOn/dt; nOff=tOff/dt;
% b=(1:niter)';
% b=mod(b,nOn+nOff)<nOn;
% b=repmat(b,[1 n]).*normrnd(0,1,niter,n);

% single pulse b
b = zeros(n,niter);
Tpulse=10; npulse=Tpulse/dt; 
b(:,100/dt:100/dt+npulse)=0.8*ones(n,1)*ones(1,npulse+1);
b=b';

% gaussian b:
% b=normrnd(0,1,niter,n);

% time-varying random b: 
%b=ones(n,1)*normrnd(0,.16,1,niter); 

% generate weights
% w=randn(n)/sqrt(n);

% load weights
load W_chaotic
  
for i=2:niter 
    h(i,:)=h(i-1,:)+dt/tau*(-h(i-1,:) + tanh(h(i-1,:))*W*r + b(i-1,:));    
end

% offset plots of neuron rates: 
offset = ones(niter,1)*(1:1:20); 
roffset = h(:,1:20)+offset; 

time = dt*(1:niter); 
figure(1); plot(time, roffset');
%xlim([0 1e3])

% plot n largest eigenvalues of w
% [v,d]=eigs(w,n); 
% figure(2); plot(real(d),imag(d),'.k'); axis square;

proj1=randn(n,1); 
proj2=randn(n,1); 

traj=[ h*proj1,...
       h*proj2 ];
figure(2); plot(traj(:,1),traj(:,2),'.'); title(r)

% figure(2); hold on
% for i=1:100:niter
%     plot(traj(i,1),traj(i,2),'.r');
%     xlim([-3 7])
%     ylim([-6 6])
%     drawnow
% end

% J=mf_nmf(h);
% figure(3);
% plot(W(~eye(n)),J(~eye(n)),'.')
% 
% corrcoef(W(~eye(n)),J(~eye(n)))
% title(inference_error(J,W,'full',2,2))