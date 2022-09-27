addpath(genpath('GLM Kijung'));
load('thresholds_unpinned.mat');

load W100.mat

L=200;
nbasis=10;
ihbasprs.ncols = nbasis;
ihbasprs.hpeaks = [1 L];
ihbasprs.b = 1;
dt = .1;
[~,~,basis] = makeBasis_PostSpike(ihbasprs,dt);
basis=basis(1:L,:);


options = optimoptions(@fminunc,'MaxFunEvals',1000,'MaxIter',400,'Display','iter');

temp=11;
sW=thresholds(temp,1);
load(sprintf('binnedspikes_LNP_unpinned/sW %.4f.mat',sW));
node=1;
x=binnedspikes(L+1:end,node);
xrest=binnedspikes(1:end-1,[1:node-1,node+1:end]);
wseed=W(1,:)*.14/abs(min(W(1,:)));
tic
coeffs = fminunc(@(coeffs)glm_logp_basis(x,xrest,basis,coeffs),[zeros(1,size(xrest,2)+1),ones(1,nbasis)],options);
%coeffs = fminunc(@(coeffs)glm_logp_basis(x,xrest,basis,coeffs),[b,wseed(2:end),base_w'],options);
toc       
b=coeffs(1);
ws=coeffs(2:2+size(xrest,2)-1)';
figure        
plot(circshift(ws,50,1));
plot(ws);

base_w=coeffs(end-size(basis,2)+1:end)';
a=basis*base_w;
figure
plot(a);

