function J=logreg_fullJ(spikes,lambda) % lambda is the regularization strength
N=size(spikes,2);
J=zeros(N);
for node=1:N
    node
    y=sign(spikes(:,node));
    x=spikes;
    x(:,node)=1;
    x=x-mean(x);
    J(node,:)=logreg(x,y,lambda);
end
end