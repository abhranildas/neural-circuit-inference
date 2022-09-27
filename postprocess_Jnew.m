%diagonal=diag(Jnew);
N=100;
Wclip=W(2:N,2:N);
Jnewclip=Jnew(2:N,2:N);
Jnewclip(logical(eye(size(Jnewclip)))) = NaN;

%PLOTTING START
% figure();
% subplot(3,1,1);
% imagesc(Jnewclip);
% axis square;
% colorbar;
% title(sprintf('sW: %f\nBinned spike count: %d\nBinsize: %d', [sW, binnedspikecount, binsize]));


Wclip(logical(eye(size(Wclip)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
Wclip=(Wclip-min(Wclip(:)))./(max(Wclip(:))-min(Wclip(:)))-1; %rescaling W between -1 and 1
Jnewclip=(Jnewclip-min(Jnewclip(:)))./(max(Jnewclip(:))-min(Jnewclip(:)))-1; %rescaling Jnew between -1 and 0

% subplot(3,1,2);
% imagesc(Wclip-Jnewclip);
% colorbar;
% caxis([-2,2]);
% axis square;

couplings=Jnewclip(1,:);
for i=1:N-1
    couplings=couplings+circshift(Jnewclip(i,:),1-i,2);
end
couplings=couplings/N;
couplings=(couplings-min(couplings(:)))./(max(couplings(:))-min(couplings(:)))-1; %rescaling couplings between -1 and 1
couplings=circshift(couplings,N/2-1,2);
actualcouplings=Wclip(N/2,:);

% subplot(3,1,3);
figure
plot(couplings,'-o');
hold on;
plot(actualcouplings,'-o');
%norm(couplings(~isnan(couplings))-actualcouplings(~isnan(actualcouplings)))
hold off;

err=norm(Wclip(~isnan(Wclip))-Jnewclip(~isnan(Jnewclip)));
% title(sprintf('Error: %f',err));

%% 
% figure();
% [ax,p1,p2] = plotyy(thresholds(1:10,1),thresholds(1:10,3),thresholds(1:10,1),thresholds(1:10,4));
% xlabel('Strength of Recurrent Weights');
% ylabel(ax(1),'Semilog Plot') % label left y-axis
% ylabel(ax(2),'Linear Plot') % label right y-axis
%%
% figure();
% plot(thresholds(1:10,1),thresholds(1:10,3),'-o');
% xlabel('Strength of Recurrent Weights');
% ylabel('Distance between weight matrix and coupling matrix');
% title('Inference Accuracy against Temperature');