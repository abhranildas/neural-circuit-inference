N=100;

addpath(genpath('GLM Kijung'));
% load('thresholds.mat');
% load('W100.mat');
% Wclip=W(2:N,2:N);
% Wclip(logical(eye(size(Wclip)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
% Wclip=(Wclip-min(Wclip(:)))./(max(Wclip(:))-min(Wclip(:)))-1; %rescaling W between -1 and 0
% 
% alph=100;


nbasis=10;
ihbasprs.ncols = nbasis;

options = optimoptions(@fminunc,'MaxFunEvals',2000,'MaxIter',400,'Display','iter');

L_logp=[];

for L=[50 100 150 200 300]
    
    ihbasprs.hpeaks = [1 L];
    ihbasprs.b = 1;
    dt = 1; % For computing purpose
    [iht,ihbasOrthog,basis] = makeBasis_PostSpike(ihbasprs,dt);
    basis=basis(1:L,:);


% for sW=.05
    %load(sprintf('binnedspikes100_LNP/sW %.3f.mat',sW));
    %binnedspikes=binnedspikes(1:1e5,2:end);
    %binnedspikes=binnedspikes(1:1e4,2:end);
    %N=size(binnedspikes,2);
    %Jnew=zeros(N);
%     for node=1
%         node
%         g = fitglm(binnedspikes_binned(:,[1:node-1,node+1:end]),binnedspikes_binned(:,node),'linear','distr','poisson');
%         coeffseed=g.Coefficients.Estimate(1:end);
        
%         binnedspikes=binnedspikes0(1:1e5,:);
%         
%         x=binnedspikes0(L+1:1.5e5,node);        
%         xrest=binnedspikes0(1:1.5e5-1,[1:node-1,node+1:end]);       

%         options = optimoptions(@fminunc,'MaxFunEvals',5000,'MaxIter',400,'Display','iter');
        %[coeffseed,~] = fminunc(@(coeffs)glm_logp(x,xrest,coeffs),zeros(1,N),options);
        %L=1;
        %[coeffs,fval] = fminunc(@(coeffs)glm_logp_lag(x,xrest,L,coeffs),zeros(1,100),options);
        %coeffseed=coeffs(1:end-1);
        %[coeffs,fval] = fminunc(@(coeffs)glm_logp_lag_simple(x,xrest,L,coeffs),zeros(1,100),options);

        %[coeffs,~] = fminunc(@(coeffs)glm_logp_lag(x,xrest,L,coeffs),[coeffseed',zeros(1,L)],options);
        breakind=round(size(binnedspikes,1)*.8);
        
        binnedspikes_train=binnedspikes(1:breakind,:);        
        x=binnedspikes_train(L+1:end,node);        
        xrest=binnedspikes_train(1:end-1,[1:node-1,node+1:end]);

        [coeffs,logp] = fminunc(@(coeffs)glm_logp_basis(x,xrest,basis,coeffs),[zeros(1,size(xrest,2)+1),ones(1,nbasis)],options);
        
        binnedspikes_test=binnedspikes(breakind+1:end,:);        
        x=binnedspikes_test(L+1:end,node);        
        xrest=binnedspikes_test(1:end-1,[1:node-1,node+1:end]);
        
        L_logp=[L_logp;[L,glm_logp_basis(x,xrest,basis,coeffs)]];
        
        
        
%         [coeffs,logp] = fminunc(@(coeffs)glm_logp_basis(x,xrest,basis,coeffs),[coeffseed',ones(1,nbasis)],options);


%         tic
%         [coeffs,logp] = fminunc(@(coeffs)glm_logp_basis(x,xrest,basis,coeffs),coeffs,options);
%         toc
        %[coeffs,~] = fminunc(@(coeffs)glm_logp_basis(x,xrest,L,base,coeffs),zeros(1,110),options);
        

        %Jnew(node,:)=[coeffs(2:node), coeffs(1), coeffs(node+1:end)];
        
        ws=coeffs(2:2+size(xrest,2)-1)';
        figure
        %plot(circshift(coeffseed(2:end),50,1));
        %hold on
        plot(circshift(ws,50,1));
        title(L)
        %hold off
        
        base_w=coeffs(end-size(basis,2)+1:end)';
        a=basis*base_w;
        %a=a(1:L);
        figure
        plot(a);
        title(L)
%     end    
    %Jnew(logical(eye(size(Jnew)))) = NaN;
%     [err,alph]=finderror_lsq(alph,Wclip,Jnew,'full',2);
%     errlist=[errlist; [thresholds(temp,1),err]];
end
figure;
plot(L_logp(:,1),L_logp(:,2),'-o')