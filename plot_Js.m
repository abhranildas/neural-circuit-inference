set(0,'DefaultFigureWindowStyle','docked');
N=100;
alph0=100;
load('W100.mat');
Wclip=W(2:end,2:end);
Wclip(logical(eye(size(Wclip)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
Wclip=(Wclip-min(Wclip(:)))./(max(Wclip(:))-min(Wclip(:)))-1; %rescaling W between -1 and 1



load('ising_inference_data_full.mat');
Widx=find([inference_data_full.meanspikecount]>9e7);
figure

for idx=1:11
	Jnew=inference_data_full(Widx(idx)).Jnewlist(2:end,2:end);
    Jnew(logical(eye(size(Jnew))))=NaN;
    
    figure(1)
    subplot(3,11,idx);
    imagesc(Jnew);
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    axis square
    title(inference_data_full(Widx(idx)).sW);
    
    [err2,alph0]=finderror_lsq(alph0,Wclip,Jnew,'full',2);
    Jnew_scaled=alph0*Jnew;    
    couplings=Jnew_scaled(1,:);
    for i=1:N-1
        couplings=couplings+circshift(Jnew_scaled(i,:),1-i,2);
    end
    couplings=couplings/(N-1);
    couplings=circshift(couplings,N/2-1,2);
    actualcouplings=Wclip(N/2,:);
    
    figure(2)
    subplot(3,11,idx);
    plot(couplings,'-');
    hold on;
    plot(actualcouplings,'-');
    hold off;
    xlabel(sprintf('%.2f',err2));
    axis tight
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);    
    title(inference_data_full(Widx(idx)).sW);
end

load('mf_sm_inferred_Js.mat');

for idx=1:11
    Jnew=inference_data(idx).Jnewlist;
    
    figure(1)
    subplot(3,11,idx+11);
    imagesc(Jnew);
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    axis square
    
    [err2,alph0]=finderror_lsq(alph0,Wclip,Jnew,'full',2);
    Jnew_scaled=alph0*Jnew;    
    couplings=Jnew_scaled(1,:);
    for i=1:N-1
        couplings=couplings+circshift(Jnew_scaled(i,:),1-i,2);
    end
    couplings=couplings/(N-1);
    couplings=circshift(couplings,N/2-1,2);
    actualcouplings=Wclip(N/2,:);
    
    figure(2)
    subplot(3,11,idx+11);
    plot(couplings,'-');
    hold on;
    plot(actualcouplings,'-');
    hold off;
    xlabel(sprintf('%.2f',err2));
    axis tight
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
end

load('mf_nmf_inferred_Js.mat');
Widx=find([inference_data.meanspikecount]>9e7);

for idx=1:11
	Jnew=inference_data(Widx(idx)).Jnewlist;
    Jnew(logical(eye(size(Jnew))))=NaN;
    
    figure(1)
    subplot(3,11,idx+22);
    imagesc(Jnew);
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    axis square
    
    [err2,alph0]=finderror_lsq(alph0,Wclip,Jnew,'full',2);
    Jnew_scaled=alph0*Jnew;    
    couplings=Jnew_scaled(1,:);
    for i=1:N-1
        couplings=couplings+circshift(Jnew_scaled(i,:),1-i,2);
    end
    couplings=couplings/(N-1);
    couplings=circshift(couplings,N/2-1,2);
    actualcouplings=Wclip(N/2,:);
    
    figure(2)
    subplot(3,11,idx+22);
    plot(couplings,'-');
    hold on;
    plot(actualcouplings,'-');
    hold off;
    xlabel(sprintf('%.2f',err2));
    axis tight
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
end

