binnedspikes_full=binnedspikes;
evalc('runme_ising_from_simulation');
Jnewfull=Jnew;
subsamplecurve=[];

alph0=100;
for n=2:10:N-1
    n
    %subdists=[];
    numsamp=ceil(log(.1)/log(1-n^2/N^2));%ceil(8000/n^2);
    Jnewexpandedlist=NaN(N,N,numsamp);
    for iter=1:numsamp
        [binnedspikes,subindex]=datasample(binnedspikes_full,n,2,'Replace',false,'Weights',horzcat(0,ones(1,N-1))); %The weights make sure the pinned end is not chosen.
        Jnewfullsub=Jnewfull(subindex,subindex);
        N1=N; N=n;
        evalc('runme_ising_from_simulation');
        N=N1;        
        Jnewexpanded=NaN(N);
        Jnewexpanded(subindex,subindex)=Jnew;
        Jnewexpandedlist(:,:,iter)=Jnewexpanded;
        Jnewexpanded(logical(eye(N))) = NaN;
        %figure;
        %imagesc(Jnewexpanded);
        %set(gca,'YDir','reverse');
        %axis square
        %subdists=[subdists,norm(Jnewfullsub(:)-Jnew(:))/n^2];
    end

%     subplot(2,1,1);
    meansubJ=nanmean(Jnewexpandedlist,3);
    meansubJ(logical(eye(N))) = NaN;
    
    figure
    imagesc(meansubJ(2:N,2:N));
    axis square
    title(sprintf('sW=%.4f, n=%d', [sW, n]));
    
%     subplot(2,1,2);
%     plot(Jnewfullsub(~eye(n)), Jnew(~eye(n)), '.' );
%     refline(1,0);
%     axis equal
%     title(sprintf('n=%d    Mean dist: %f', [n, norm(Jnewfullsub(:)-Jnew(:))/n^2]));
%     subsamplecurve=[subsamplecurve;[n,mean(subdists),std(subdists)]];
    Jnewclip=Jnewfull(2:N,2:N);
    meansubJclip=meansubJ(2:N,2:N);
    err=finderror_lsq(alph0,Wclip,meansubJclip,'full',2);
    %diff=meansubJclip-Jnewclip;
    %err=norm(diff(~isnan(diff)));
    subsamplecurve=[subsamplecurve;[n,err]];
end
% figure();
% errorbar(subsamplecurve(:,1),subsamplecurve(:,2),subsamplecurve(:,3));
% xlim([2 50]);
% xlabel('Subsample size (population size = 50)');
% ylabel('Average distance between parameter vectors');

% n^2*numsamp
% sum(sum(~isnan(meansubJ)))

Jnewfull(logical(eye(N))) = NaN;
figure
imagesc(Jnewfull(2:N,2:N));
axis square

% figure
% plot(subsamplecurve(:,1),subsamplecurve(:,2),'-o');