N=100;

addpath(genpath('GLM Kijung'));
load('thresholds.mat');
load('W100.mat');
Wclip=W(2:N,2:N);
Wclip(logical(eye(size(Wclip)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
Wclip=(Wclip-min(Wclip(:)))./(max(Wclip(:))-min(Wclip(:)))-1; %rescaling W between -1 and 0

alph=100;

L=200;
nbasis=10;

ihbasprs.ncols = nbasis;
ihbasprs.hpeaks = [1 L];
ihbasprs.b = 1;
dt = 1; % For computing purpose
[iht,ihbasOrthog,basis] = makeBasis_PostSpike(ihbasprs,dt);
basis=basis(1:L,:);

%USE THE SAME COEFFSEED FOR ALL NODES.
for sW=.05
    %load(sprintf('binnedspikes100_LNP/sW %.3f.mat',sW));
    %binnedspikes=binnedspikes(1:1e5,2:end);
    %binnedspikes=binnedspikes(1:1e4,2:end);
    %N=size(binnedspikes,2);
    %Jnew=zeros(N);
    for node=1:N
        node
        %g = fitglm(binnedspikes(:,[2:node-1,node+1:end]),binnedspikes(:,node),'linear','distr','poisson');
        x=binnedspikes(L+1:end,node);
        xrest=binnedspikes(1:end-1,[1:node-1,node+1:end]);
        %g = fitglm(xrest(1:end-1,:),x(2:end),'linear','distr','poisson');
        %coeffseed=g.Coefficients.Estimate(1:end);
        options = optimoptions(@fminunc,'MaxFunEvals',10000,'MaxIter',400,'Display','iter');
        %[coeffseed,~] = fminunc(@(coeffs)glm_logp(x,xrest,coeffs),zeros(1,N),options);
        %L=1;
        %[coeffs,fval] = fminunc(@(coeffs)glm_logp_lag(x,xrest,L,coeffs),zeros(1,100),options);
        %coeffseed=coeffs(1:end-1);
        %[coeffs,fval] = fminunc(@(coeffs)glm_logp_lag_simple(x,xrest,L,coeffs),zeros(1,100),options);

        %[coeffs,~] = fminunc(@(coeffs)glm_logp_lag(x,xrest,L,coeffs),[coeffseed',zeros(1,L)],options);
        tic
        [coeffs,logp] = fminunc(@(coeffs)glm_logp_basis(x,xrest,basis,coeffs),[zeros(1,size(xrest,2)+1),ones(1,nbasis)],options);
        toc
        
        [coeffs,logp] = fminunc(@(coeffs)glm_logp_basis(x,ind,xrest,L,basis,coeffs),coeffs,options);
        toc
        %[coeffs,~] = fminunc(@(coeffs)glm_logp_basis(x,xrest,L,base,coeffs),zeros(1,110),options);
        
        glm_logp_basis(x,xrest,L,basis,[coeffseed',base_w])
        
        %coeffs=g.Coefficients.Estimate(1:end);
        %Jnew(node,:)=[coeffs(2:node), coeffs(1), coeffs(node+1:end)];
        
        ws=coeffs(2:2+size(xrest,2)-1)';
        figure
        %plot(circshift(coeffseed(2:end),50,1));
        %hold on
        plot(circshift(ws,50,1));
        %hold off
        
        base_w=coeffs(end-size(basis,2)+1:end)';
        a=basis*base_w;
        %a=a(1:L);
        figure
        plot(a);
    end    
    %Jnew(logical(eye(size(Jnew)))) = NaN;
%     [err,alph]=finderror_lsq(alph,Wclip,Jnew,'full',2);
%     errlist=[errlist; [thresholds(temp,1),err]];
end