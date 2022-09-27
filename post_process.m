W=((W-min(W(:)))./(max(W(:))-min(W(:)))-0.5)*2; %rescaling W between -1 and 1
Jnew=-Jnew; %inverting colours
Jnew=((Jnew-min(Jnew(:)))./(max(Jnew(:))-min(Jnew(:)))-0.5)*2; %rescaling Jnew between -1 and 1
%Jnew=(triu(Jnew,1));
%W=(triu(W,1));
figure();
subplot(2,1,1);
imagesc(W);
colorbar;
title('Original weight matrix');
subplot(2,1,2);
imagesc(-Jnew(2:N-1,2:N-1));
colorbar;
title(sprintf('Inferred Ising coupling matrix (sW= %.4f)', sW));
%W(logical(eye(size(W)))) = 0; %setting diagonal to 0.
%Jnew(logical(eye(size(Jnew)))) = 0; %setting diagonal to 0.
err=norm(reshape(W,[1,numel(W)])-reshape(Jnew,[1,numel(Jnew)]));