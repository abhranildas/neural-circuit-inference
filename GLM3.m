set(0,'DefaultFigureWindowStyle','docked');
% x=binnedspikes(:,2);
% xrest=binnedspikes(:,3:end);
% 
% 
% tic
% [coeffs,fval] = fminunc(@(coeffs)glm_logp(x,xrest,coeffs),zeros(1,size(xrest,2)+1));
% toc

Jnew=(Jnew+Jnew')/2;
bs=diag(Jnew);
ws=nonzeros(triu(Jnew,1)');
coeffs_init=[bs;ws];

load('binnedspikes100_LNP/sW 0.025.mat');
binnedspikes=binnedspikes(1:1e3,2:2:end);
N=size(binnedspikes,2);

tic
[coeffs,fval] = fminunc(@(coeffs)glm_logp_full(binnedspikes,coeffs),coeffs_init); %zeros(N*(N+1)/2,1)
toc

w_u=triu(squareform(coeffs(N+1:end)));
wmat=w_u+w_u';

figure
imagesc(wmat);

% figure
% plot(coeffs(1:end-1))
