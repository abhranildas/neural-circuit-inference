set(0,'DefaultFigureWindowStyle','docked');
tic

%INPUT PARAMETERS START
dt=.0001;
N=100;
tau=.01;
L=200;

b=ones(1,N)*.001;
%b=[0,ones(1,N-1)]*.001; %feedforward pinned at a point to hold bumps fixed. default .001

a=flip(exp(-(1:L)*dt/tau));
%load('thresholds_unpinned.mat');
load W_glm_sb.mat
W(logical(eye(size(W))))=0;

binnedspikelimit=1e6;
chunk=binnedspikelimit/20;

plotstyle='none'; %linear, polar, 3D or none
phasetrack=0;


for temp=1:11
    sW=thresholds(temp,1);
    factor=4.5e5;

    s=rand(1, N); %initial value of mean activations

    if not(strcmp(plotstyle,'none'))
        figure(2);
        set(gcf,'color','white');
    end

    binnedspikes=zeros(L,N,'double');
    spikebin=zeros(1,N,'double');
    binnedspikecount=0;
    i=1;
    j=L+1;
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
    rlist=zeros(1e5,1);
    while binnedspikecount<binnedspikelimit
        %DYNAMICS START
        x=binnedspikes(j-L:j-1,:);
        g=a*x*sW*W+b;
        %g=conv(xw,a,'valid')+b;
        %rate=100*max(g-threshold,0); %nonlinearity, r0=32 by default
        rate=exp(1e4*g)/factor;
        %rate=50*g;
        rlist(t+1)=rate(2);
        spike=poissrnd(rate);
        
        %DYNAMICS END    

        if not(burnedin)
            if sum(spike)
                burnedin=true;
            end
        end

        if burnedin
            binnedspikes(j,:)= spike;
            binnedspikecount = binnedspikecount+sum(spike);
            j=j+1;
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
            stem(rate,'Marker','.','LineWidth',1);
            xlim([0 N]);
            %ylim([-.002 .002]);
            %refline(0,threshold);

            if phasetrack && burnedin
                hold on
                plot(mod(pattern_phase*N/(8*pi),N),0,'r^','MarkerFaceColor','r');
                hold off
            end

            title('Inputs');
            subplot('Position',[.05 .08 .9 .35]);
            %plot(imag(fft(I)));
            %plot(f,power);
            %xlim([.02 .05]);
            stem(spike,'LineWidth',1);        
            ylim([0 1]);
            title(binnedspikecount);

%             set(gca,'XTick',[]);
%             title('Activations and spikes');
%             subplot('Position',[.04 .05 .92 .02])
%             image(spike,'CDataMapping','scaled');
%             colormap([1 1 1; .5 .7 1 ]);
%             set(gca,'XGrid','on','XTick',0.5+1:N,'ticklength',[.01 .05],'YTick',[],'XTickLabel',[]);
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

    %clear a1 a2 b i j I noise noisesparsity nsamp plotstyle s sdot sigma1 sigma2 spike t T tau threshold
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
    %clear chunk spike spikebin s sdot i j burnedin a1 a2 sigma1 sigma2 b
    %binnedspikes=bin(binnedspikes,100,0,0);
    save(sprintf('binnedspikes_GLM_exp_sb/sW %.4f.mat',sW),'binnedspikes','-v7.3');
    toc
end

