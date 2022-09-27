N=100;

addpath(genpath('GLM Kijung'));
load('thresholds_unpinned.mat');
load('W100.mat');
W(logical(eye(size(W)))) = NaN;
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

alph=100;
L=200;
nbasis=10;
ihbasprs.ncols = nbasis;
ihbasprs.hpeaks = [1 L];
ihbasprs.b = 1;
dt = 1;
[~,~,basis] = makeBasis_PostSpike(ihbasprs,dt);
basis=basis(1:L,:);

GLM_inf_data=struct;
ii=1;

options_long = optimoptions(@fminunc,'MaxFunEvals',5000,'MaxIter',400,'Display','iter');
options_short = optimoptions(@fminunc,'MaxFunEvals',2000,'MaxIter',400,'Display','iter');

for temp=8
    sW=thresholds(temp,1);
    load(sprintf('binnedspikes_LNP_unpinned/sW %.4f.mat',sW));
    Jnew=zeros(N);
    for node=1:2
        node
        x=binnedspikes(L+1:end,node);
        xrest=binnedspikes(1:end-1,[1:node-1,node+1:end]);
        tic
        if node==1
            coeffs = fminunc(@(coeffs)glm_logp_basis(x,xrest,basis,coeffs),[zeros(1,size(xrest,2)+1),ones(1,nbasis)],options_long);
            %coeffs = fminunc(@(coeffs)glm_logp_lag(x,xrest,L,coeffs),[zeros(1,100),zeros(1,L)],options_long);
        else
            coeffs = fminunc(@(coeffs)glm_logp_basis(x,xrest,basis,coeffs),[b,circshift(ws',1,2),base_w'],options_short);
            %coeffs = fminunc(@(coeffs)glm_logp_lag(x,xrest,L,coeffs),[b,circshift(ws',1,2),zeros(1,L)],options_short);
        end
        toc        
        figure
        plot(circshift(ws',1,2));
        hold on        
        b=coeffs(1);
        ws=coeffs(2:2+size(xrest,2)-1)';
        base_w=coeffs(end-size(basis,2)+1:end)';
        Jnew(node,:)=[ws(1:node-1)', NaN, ws(node:end)'];
%         figure
%         plot(circshift(ws,50,1));
        plot(ws);
        hold off
        a=basis*base_w;
        figure
        plot(a);
    end
    GLM_inf_data(ii).Jnew=Jnew;
    GLM_inf_data(ii).err=finderror_lsq(alph,W,Jnew,'full',2);
    ii=ii+1;
end
save GLM_inf_data.mat GLM_inf_data