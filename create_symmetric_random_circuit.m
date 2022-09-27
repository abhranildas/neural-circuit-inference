N=100;
load W100
imagesc(W); colorbar

W_rand=unifrnd(min(W(:)),max(W(:)),N);
W_rand=W_rand-tril(W_rand,-1)+triu(W_rand,1)';
figure; imagesc(W_rand); colorbar