N=100;
load('W100.mat');
W=W(2:end,2:end);
Jnew=Jnew(2:end,2:end);
Jnew(logical(eye(size(Jnew)))) = NaN;

[err,alph]=finderror_lsq(100,W,Jnew,'full',2)

figure
subplot(2,1,1)
imagesc(Jnew)
axis square
title(sprintf('Binsize=%d',binsize));

couplings=Jnew(1,:);
for i=2:N-1
    couplings=couplings+circshift(Jnew(i,:),1-i,2);
end
couplings=couplings/(N-1);
couplings=circshift(couplings,N/2-1,2);

subplot(2,1,2)
plot(couplings)

% hold on;
% actualcouplings=W(N/2,:);
% plot(actualcouplings,'-');
% hold off;



