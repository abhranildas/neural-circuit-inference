% global a1; global a2; global sigma1; global sigma2;

%INPUT PARAMETERS START
dt=.0001;
N=100;
tau=.01;

% sigma1 = 6.98; %3.49 for N=50
% sigma2 = 7; %3.5 for N=50
% a1 = 1; %Height of overall envelope, 1 for N=50
% a2 = 1.0005;

%b=[0,ones(1,N-1)]*.001; %feedforward pinned at a point to hold bumps fixed. default .001
b=ones(1,N)*.001;
load thresholds_rand_sparse

temp=7;
sW=thresholds(temp,1); %strength of W, .01 ~ critical
%sW=0.07;
%threshold=thresholds(temp,2); %threshold for spiking.
%threshold=(thresholds(temp,3)+thresholds(temp,8))/2 %threshold for spiking.
threshold=1.81e-3;

noise=.3; %.3 amplitude of noise
noisesparsity=1.5; %higher means sparser noise, was 1.5 for good inference
binsize=1;
binnedspikelimit=5e6;
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

% W=zeros(N);
% for i=1:N
%     for j=1:N
%         W(i,j)=hat(min(abs(i-j),N-abs(i-j))); %the min() makes it periodic.
%     end
% end

%load W_rand_sparse

s=rand(1, N); %initial value of mean activations
%s=sin((1:N)*8*pi/N-pi/2)+1;

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


binnedspikes=zeros(chunk,N,'logical');
spikebin=zeros(binsize,N,'logical');
binnedspikecount=0;
i=1;
j=1;
burnedin=false;

if phasetrack
    s_corrcheck=s; %activation array to check correlation against
    corr1=mycxcorr(s_corrcheck,s_corrcheck);
    phase=1;
    phase_traj=[phase];
    pkshift_traj=[];
end

t=0;

tic
while binnedspikecount<binnedspikelimit
%     set(gcf, 'visible', 'off');

    %DYNAMICS START
    I=sW*s*W+(b.*(1+noise*randn(1,N).*(randn(1,N)>noisesparsity))); %neuron inputs. The weight part is a simple matrix multiplication
    spike=I>threshold;  %neuron spike values 0/1
    sdot=(-s/tau); %array of sdots
    s=s+spike+sdot*dt;
    %DYNAMICS END
    
    %Phase tracking start
    if phasetrack
        corr2=mycxcorr(s_corrcheck,s);
        corr=mycxcorr(corr1,corr2);
        [corrmax,ind]=max(corr);
        
        %Find peaks of nested correlation
        %(shift to one side and then another, otherwise matlab cannot find end
        %peaks).
        [~,pklocs1]=findpeaks(corr);
        [~,pklocs2]=findpeaks(circshift(corr,[0,1]));
        pklocs2=pklocs2-1;
        [~,pklocs3]=findpeaks(circshift(corr,[0,-1]));
        pklocs3=pklocs3+1;
        pklocs=union(union(pklocs1,pklocs2),pklocs3);
        
        %Find the peak nearest to start
        [~,pkstartloc]=min(min(pklocs-1,N+1-pklocs));
        %pklocs(pkstartloc)
        if pklocs(pkstartloc)<=25
            pkshift=pklocs(pkstartloc)-1;
        else            
            pkshift=pklocs(pkstartloc)-1-N;
        end
    %     if min(pkshift,N+1-pkshift)>1
    %         pkshift        
        if pkshift
            %pkshift
            phase=phase+pkshift/2;
    %         if phase==0
    %             phase=N;
    %         end
            s_corrcheck=s;
            corr1=mycxcorr(s_corrcheck,s_corrcheck);
        end
%         if t==500
%             'update'
%             s_corrcheck=s;
%             corr1=mycxcorr(s_corrcheck,s_corrcheck);
%         end
    end
    %Phase tracking end
    
    
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
                %binnedspikes(j,:)=(sum(spikebin,1)~=0); %Binarize
                binnedspikes(j,:)=sum(spikebin,1); %Don't binarize
                binnedspikecount = binnedspikecount+sum(binnedspikes(j,:));
                spikebin=zeros(binsize,N,'logical');
                i=0;
                j=j+1;                
            end
            i=i+1;
        end
        if j>size(binnedspikes,1)
            binnedspikes=[binnedspikes; zeros(chunk,N,'logical')];
        end
        if phasetrack
            pkshift_traj=[pkshift_traj; pkshift];
            phase_traj=[phase_traj; phase];
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
        title('Inputs');
        subplot('Position',[.05 .08 .9 .35]);

        %plot(imag(fft(I)));
        
        plot(s,'LineWidth',1);
        title(binnedspikecount);
        xlim([0 N]);
        if phasetrack
            hold on
            plot(s_corrcheck,'LineWidth',1);
            %plot(10*corr1);
            %plot(10*corr2);
            plot(10*corr);
            plot(mod(phase,N),0,'r^','MarkerFaceColor','r');
            hold off
        end

%         set(gca,'XTick',[]);
%         title('Activations and spikes');
        subplot('Position',[.04 .05 .92 .02])
        image(spike,'CDataMapping','scaled');
        colormap([1 1 1; .5 .7 1 ]);
        set(gca,'XGrid','on','XTick',0.5+1:N,'ticklength',[.01 .05],'YTick',[],'XTickLabel',[]);
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
toc
binnedspikes(j:end,:)=[];

%save(sprintf('binnedspikes100_1e8/sW %.4f.mat',sW),'binnedspikes');

%DELETE BURN-IN
% [col,row]=find(spikelist',1,'first');
% spikelist(1:row-1,:)=[];

clear a1 a2 b i j I noise noisesparsity nsamp plotstyle sdot sigma1 sigma2 spike t T tau
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
N*size(binnedspikes,1)*dt*1000/sum(binnedspikes(:))
%plot(sum(binnedspikes)/(size(binnedspikes,1)*dt));
clear chunk spike spikebin sdot i j burnedin a1 a2 sigma1 sigma2 b phasetrack
%save(sprintf('binsize_1_up_1e8/sW %.4f.mat',sW),'binnedspikes','-v7.3');



