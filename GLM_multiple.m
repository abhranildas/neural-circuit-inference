N=100;
load('thresholds_unpinned.mat');
load('W100.mat');
%W=W(2:N,2:N);
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

alph=100;
L=10;
%errlist=[];
tic

binsize=100;
for sW=.04
    %load binnedspikes_GLM.mat
    %binnedspikes=bin(binnedspikes,binsize,1e6);
    %load(sprintf('binnedspikes100_LNP/sW %.3f.mat',sW));
    %binnedspikes=binnedspikes(1:1e4,2:end);
    N=size(binnedspikes,2);
    Jnew=zeros(N,N,3);
    for node=1:N
        node
        ind=[];
        %ind=zeros(size(binnedspikes,1)-L,N);
        for l=1:L
            ind=[ind,binnedspikes(L-l+1:end-l,[1:node-1,node+1:end])];
        end
        %ind=[binnedspikes(3:end-1,[1:node-1,node+1:end]),...
         %   binnedspikes(2:end-2,[1:node-1,node+1:end]),...
          %  binnedspikes(1:end-3,[1:node-1,node+1:end])];
        g = fitglm(ind,binnedspikes(L+1:end,node),'linear','distr','poisson');
        coeffs=g.Coefficients.Estimate(1:end);
        b=coeffs(1);
        ws=coeffs(2:end);
        for l=1:L
            wsl=ws((l-1)*(N-1)+1:l*(N-1));
            Jnew(:,node,l)=[wsl(1:node-1); NaN; wsl(node:N-1)];
        end
        %Jnew(:,node,3)=[ws(N:N+node-2); NaN; ws(N+node-1:2*N-2)];
    end
    %Jnew(logical(eye(size(Jnew)))) = NaN;
    figure
    hold on
    for l=1:L
        plot(meancoupling(Jnew(:,:,l)),'Color',[0 0 1]*(1-l/L));
%         imagesc(Jnew(:,:,l)); axis square
    end
    hold off
    %title(binsize);
    %[err,alph]=finderror_lsq(alph,W(2:end,2:end),Jnew,'full',2);
    %bin_err=[bin_err;[binsize,err]];
end
toc