%addpath(genpath('MPF mine'));
load W100
load thresholds_unpinned

N=100;
N0=N;
%subsamples=struct;
dataindex=82;
for temp=9:11
    sW=thresholds(temp,1);
    load(sprintf('binnedspikes_dyn_glm/sW %.4f.mat',sW));
    %binnedspikes=bin(binnedspikes,100,0,0);
    binnedspikes_full=binnedspikes;
    for n=10:10:100
        numsamp=ceil(log(.01)/log(1-(n^2-n)/(N^2-N)));
        if numsamp==0, numsamp=1; end        
        J_expandedlist=NaN(N,N,numsamp);
        errlist=zeros(1,numsamp);
        for iter=1:numsamp
            tic
            disp(sprintf('sW: %.4f, n: %d, subsample %d of %d', [sW,n,iter,numsamp]))
            [binnedspikes,subindex]=datasample(binnedspikes_full,n,2,'Replace',false);
            N=n;
            %evalc('runme_ising_from_simulation');
            J=glm_inf_binned(binnedspikes);
            N=N0;        
            J_expanded=NaN(N);
            J_expanded(subindex,subindex)=J;
            J_expanded(logical(eye(N))) = NaN;
            %Least-squares matching and error
            [err,~]=finderror_lsq(100,W,J_expanded,'full',2);
            %Jnewexpanded=alph*Jnewexpanded;
            J_expandedlist(:,:,iter)=J_expanded;    
            errlist(iter)=err;
            toc
        end
        subsamples(dataindex).sW=sW;
        subsamples(dataindex).n=n;
        subsamples(dataindex).Jsubs=J_expandedlist;
        subsamples(dataindex).J_merged=nanmean(J_expandedlist,3);
        subsamples(dataindex).errs=errlist;
        %subsamples(dataindex).errmeansq=mean(errlist.^2/(n^2-n));
        %subsamples(dataindex).errsem=std(errlist.^2/(n^2-n))/sqrt(numsamp);
        subsamples(dataindex).errmean=mean(errlist);
        subsamples(dataindex).errse=std(errlist)/sqrt(numel(errlist));
        save inference_data_dyn_glm_subsampling.mat subsamples
        dataindex=dataindex+1;
    end    
end