%load W100.mat
% W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
% W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

N=100;
% subplot(3,1,1)
% plot(diag(Jnew));

Jnew(logical(eye(size(Jnew))))=NaN;

figure
% subplot(3,1,2)
imagesc(Jnew);
axis square

couplings=Jnew(1,:);
for i=2:size(Jnew,1)
    couplings=couplings+circshift(Jnew(i,:),1-i,2);
end
couplings=couplings/(size(Jnew,1));
couplings=circshift(couplings,N/2-1,2);
figure
plot(couplings)

[err,alph]=finderror_lsq(100,W,Jnew,'full',2)
%% 
for i=1:size(binnedspikes,1)
    stem(binnedspikes(i,:));
    drawnow
end

%%
Jnew=inference_data_full(118).Jnewlist(:,:,1);
Jnew=Jnew(2:end,2:end);
Jnew(logical(eye(99)))=NaN;
imagesc(Jnew)