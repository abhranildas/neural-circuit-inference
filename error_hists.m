set(0,'DefaultFigureWindowStyle','docked');
N=100;

load('W100.mat');
%Wclip=W(2:end,2:end);
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

load('unpinned_inf_full.mat');

skewnesslist=[];
negenlist=[];
figure
subplotidx=1;
for i=find([inference_data_full.meanspikecount]>9e7)
    sW=inference_data_full(i).sW;
    Jnew=inference_data_full(i).Jnewlist;
    Jnew(logical(eye(size(Jnew))))=NaN;
    %Jnewclip=Jnew(2:end,2:end);
    [err,alph]=finderror_lsq(100,W,Jnew,'full',2);
    Jnew=alph*Jnew;
%     couplings=Jnewclip(1,:);
%     for i=1:N-1
%         couplings=couplings+circshift(Jnewclip(i,:),1-i,2);
%     end
%     couplings=couplings/(N-1);
%     couplings=circshift(couplings,N/2-1,2);
%     
%     plot(couplings/abs(min(couplings)),'-');
%     hold on;
%     actualcouplings=Wclip(N/2,:);
%     plot(actualcouplings,'-');
%     hold off;    
    errormat=Jnew-W;
    errormat=errormat(~isnan(errormat)); %Remove NaN's and flatten
    v=var(errormat);
    [freqs,edges]=histcounts(errormat(:),100);
    delta=edges(2)-edges(1);
    p=freqs/sum(freqs);
    f=p/delta;
    H_p=-sum(f(f>0).*log(f(f>0)))*delta;
    H_g=log(2*pi*exp(1)*v)/2;
    negen=H_g-H_p;
    negenlist=[negenlist; [sW,negen]];
    subplot(11,1,subplotidx)
    hist(errormat,100);
    xlim([-1 1]);
    set(gca, 'YTick',[]);
    lineh=line([0 0], ylim);
    lineh.Color='r';
    %xlabel('J_{ij}-W_{ij}');
    %ylabel(sprintf('w=%.4f',sW),'rot',0);
    title(sprintf('w= %.4f',sW));
    subplotidx=subplotidx+1;
    skewnesslist=[skewnesslist; [sW,skewness(errormat(:))]];
end

%Plot skewness of histogram over weight strength
figure
plot(negenlist(:,1),negenlist(:,2),'-o');
xlabel('Weight strength \omega');
ylabel('Negentropy of inference error distribution');

figure
plot(skewnesslist(:,1),skewnesslist(:,2),'-o');
xlabel('Weight strength \omega');
ylabel('Skewness of inference error distribution');

