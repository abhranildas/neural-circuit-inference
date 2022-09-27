set(0,'DefaultFigureWindowStyle','docked');
tic

global a1; global a2; global sigma1; global sigma2;

%INPUT PARAMETERS START
dt=.0001;
N=100;
tau=.01;

sigma1 = 6.98; %3.49 for N=50
sigma2 = 7; %3.5 for N=50
a1 = .5; %Height of overall envelope, 1 for N=50
a2 = 1.0005;

b=[0,ones(1,N-1)]*.001; %feedforward pinned at a point to hold bumps fixed.
%b=ones(1,N)*.001;
load('thresholds.mat');

%temp=13;
sW = thresholds(temp,1); %strength of W, .01 ~ critical
threshold = thresholds(temp,3); %threshold for spiking.
noise=.3; %.3 amplitude of noise
noisesparsity=1.5; %higher means sparser noise WAS 1.5 for good inference
binsize=1;
binnedspikelimit=1e6;
chunk=binnedspikelimit/20;

plotstyle='none'; %linear, polar, 3D or none
phasetrack=0;

%INPUT PARAMETERS END


% th = (0:N-1)/N*2*pi;
% if(strcmp(plotstyle,'polar'))    
%     %set up coordinates for 3D ring plot    
%     x = cos(th);
%     y = sin(th);
% end
% 
% if(strcmp(plotstyle,'polar'))    
%     %set up coordinates for 2D ring plot   
%     x1 = .05*cos(th);
%     y1 = .05*sin(th);   
% end

W=zeros(N);
for i=1:N
    for j=1:N
        W(i,j)=hat(min(abs(i-j),N-abs(i-j))); %the min() makes it periodic.
    end
end

s=rand(1, N); %initial value of mean activations

if not(strcmp(plotstyle,'none'))
    figure(1);
    set(gcf,'color','white');
end

if (strcmp(plotstyle,'polar'))
    x2 = (.05+s).*cos(th);
    y2 = (.05+s).*sin(th);
    fake=polar(0,2); hold on %this is just a hack to set the radial axis limit
    lh=line([ x1' x2' ]',[ y1' y2' ]', 'color','k', 'LineWidth',1); %draw the lines first so that circles occlude the ends
    empty=plot(x1,y1,'o'); %initializes all the empty circles
    set(empty, 'MarkerEdgeColor','k','MarkerFaceColor','white','MarkerSize',5);
    filled=plot(x1,y1,'o'); hold off %initializes all the filled circles
    set(filled, 'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5);
end

% writerObj = VideoWriter('grid-cell-sparse-noise','MPEG-4');
% writerObj.FrameRate=15;
% open(writerObj);


binnedspikes=zeros(chunk,N,'double');
spikebin=zeros(binsize,N,'double');
binnedspikecount=0;
i=1;
j=1;
burnedin=false;

if phasetrack
%     s_corrcheck=s; %activation array to check correlation against
%     corr1=mycxcorr(s_corrcheck,s_corrcheck);
    phase_traj=[];
    %pkshift_traj=[];
    m = N;          % Window length
    f = (0:m-1)*(1/(m));     % Frequency range for FFT
end

t=0;

while binnedspikecount<binnedspikelimit
%     set(gcf, 'visible', 'off');

    %DYNAMICS START
    I=sW*s*W+(b.*(1+noise*randn(1,N).*(randn(1,N)>noisesparsity))); %neuron inputs. The weight part is a simple matrix multiplication
    spike=I>threshold;  %neuron spike values 0/1
    sdot=(-s/tau); %array of sdots
    s=s+spike+sdot*dt;
    %DYNAMICS END    
  
    if not(burnedin)
        if sum(spike)
            burnedin=true;
        end
    end
    
    if burnedin
        if binsize==1
            binnedspikes(j,:)= spike;
            binnedspikecount = binnedspikecount+sum(spike);
            j=j+1;
        else
            spikebin(i,:) = spike;
            if i==binsize
                binnedspikes(j,:)=(sum(spikebin,1)~=0);
                binnedspikecount = binnedspikecount+sum(binnedspikes(j,:));
                spikebin=zeros(binsize,N,'double');
                i=0;
                j=j+1;                
            end
            i=i+1;
        end
        if j>size(binnedspikes,1)
            binnedspikes=[binnedspikes; zeros(chunk,N,'double')];
        end
        if phasetrack
            y = fft(I,m);           % DFT
            power = y.*conj(y)/m;   % Power of the DFT
    %         figure(2);
    %         plot(f,power);
    %         [~, pkidxs]=findpeaks(power);
    %         pkflocs=f(pkidxs);
    %         [~,pkidx]=min(abs(pkflocs-.04));
    %         pkf=pkflocs(pkidx);
            %pkf=pkflocs(pkflocs>.02 & pkflocs<.05);
            %pkf=min(f(pkidx(1)),1-f(pkidx(1)));
    %         pkwl=1./pkf;        
            phases = angle(y);
            pattern_phase=phases(5);
%             pkshift_traj=[pkshift_traj; pkshift];
            phase_traj=[phase_traj; pattern_phase];
        end
   end

    %PLOTTING START
    if (strcmp(plotstyle,'linear'))
        figure(1);
        subplot('Position',[.05 .55 .9 .4]);  
        stem(I,'Marker','.','LineWidth',1);
        xlim([1 N]);
        ylim([-.002 .002]);
        refline(0,threshold);
        
        if phasetrack && burnedin
            hold on
            plot(mod(pattern_phase*N/(8*pi),N),0,'r^','MarkerFaceColor','r');
            hold off
        end
        
        title('Inputs');
        subplot('Position',[.05 .08 .9 .35]);
        %plot(imag(fft(I)));
        plot(f,power);
        %xlim([.02 .05]);
        %plot(s,'LineWidth',1);
        %xlim([.9 1]);

%         set(gca,'XTick',[]);
%         title('Activations and spikes');
%         subplot('Position',[.04 .05 .92 .02])
%         image(spike,'CDataMapping','scaled');
%         colormap([1 1 1; .5 .7 1 ]);
%         set(gca,'XGrid','on','XTick',0.5+1:N,'ticklength',[.01 .05],'YTick',[],'XTickLabel',[]);
        drawnow
    end
    if (strcmp(plotstyle,'3D')) 
        stem3(x,y,s,'Marker','.','MarkerSize',15,'LineWidth',2);
        zlim([0 1]);
        view([-26 42]);
    end
    if (strcmp(plotstyle,'polar'))
        set(filled, 'XData', x1(spike),'YData',y1(spike)); %x(spike) uses clever logical indexing. Even polar plots just have xdata and ydata
        x2 = (.05+s).*cos(th);
        y2 = (.05+s).*sin(th);
        for i = 1:numel(lh)
            lh(i).XData = [x1(i) x2(i)];
            lh(i).YData = [y1(i) y2(i)];
        end              
    end
%     frame = getframe(gcf);
%     close(gcf);
%     writeVideo(writerObj,frame);
    %PLOTTING END
    t=t+1;
end
binnedspikes(j:end,:)=[];

%DELETE BURN-IN
% [col,row]=find(spikelist',1,'first');
% spikelist(1:row-1,:)=[];

clear a1 a2 b i j I noise noisesparsity nsamp plotstyle s sdot sigma1 sigma2 spike t T tau threshold
% close(writerObj);

%Export animation of spikes and activations

% writerObj = VideoWriter('grid-cell-animation-zero-T','MPEG-4');
% writerObj.FrameRate=15;
% open(writerObj);
% figure('position', [0, 0, 1500, 800]);
% figure('position', [500, 100, 600, 550]);
% set(gcf,'color','white');
% for i=1:size(data,1)   
%     set(gcf, 'visible', 'off');
%     subplot('Position',[.05 .9 .9 .02]) % first subplot
%     image(data(i,2:N+1),'CDataMapping','scaled');
%     colormap([1 1 1; .5 .5 .5 ]);
%     set(gca,'XGrid','on','XTick',0.5+1:N,'ticklength',[.01 .05],'YTick',[],'XTickLabel',[]);
%     subplot('Position',[.05 .1 .9 .7]) % second subplot    
%     stem(data(i,N+2:end),'Marker','.','MarkerSize',25,'LineWidth',3);
%     set(gca,'YTick',[]);
%     ylim([0 5.1]);
%     frame = getframe(gcf);
%     close(gcf);
%     writeVideo(writerObj,frame);
%     stem3(x,y,(data(i,N+2:end))','Marker','.','MarkerSize',10,'LineWidth',1);
%     zlim([0 5.1]);
%     view([-16 70]);
%     pause(0.001);
% end
% close(writerObj);

clear chunk spike spikebin s sdot i j burnedin a1 a2 sigma1 sigma2 b
%save binnedspikes.mat binnedspikes
toc


