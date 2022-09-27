% PARAMETERS

dt=.0001;   % time-step in s
N=100;      % # of neurons
tau=.01;    % synaptic time-constant in s

% weight parameters
sig_1=6.98;
sig_2=7;
a1=1;
a2=1.0005;

% create weight matrix
W=zeros(N);
for i=1:N
    for j=1:N
        x=min(abs(i-j),N-abs(i-j)); % distance between neurons i & j
        W(i,j)=a1*(exp(-(x)^2/(2*sig_1^2)) - a2*exp(-(x)^2/(2*sig_2^2)));
    end
end

b=0.001;            % uniform feedforward input
noise_sd=.3;        %.3 amplitude of noise
noise_sparsity=1.5; % noise is injected with the prob that a standard normal exceeds this

r=0.025;            % recurrence strength
threshold=7.35e-4;  % spiking threshold

s=zeros(1, N);      % starting activations
t=0;

while true
    
    % dynamics
    I=r*s*W+(b*(1+noise_sd*randn(1,N).*(randn(1,N)>noise_sparsity))); %neuron inputs. The weight part is a simple matrix multiplication
    spike=I>threshold;  % binary neural spikes
    s=s+spike-s/tau*dt;
    
    % plot
    subplot('Position',[.05 .55 .9 .4]);
    stem(I,'Marker','.','LineWidth',1);
    xlim([1 N]);
    ylim([-.002 .002]);
    refline(0,threshold);
    ylabel 'neural inputs g'
    title(sprintf('t = %.1f ms',t*.1))
    
    subplot('Position',[.05 .15 .9 .3]);
    area(s)
    xlim([1 N]);
    ylabel 'neural activations s'
    
    subplot('Position',[.04 .05 .92 .02])
    image(spike,'CDataMapping','scaled');
    colormap([1 1 1; .5 .7 1 ]);
    set(gca,'XGrid','on','XTick',0.5+1:N,'ticklength',[.01 .05],'YTick',[],'XTickLabel',[]);
    xlabel spikes
    
    drawnow
    t=t+1;
end