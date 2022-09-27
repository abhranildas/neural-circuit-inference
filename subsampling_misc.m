%% Add 100 to subsample
for i=1:15:151
    sW=inference_data_full(i).sW;
    load(sprintf('subsamples/subsamples_%.4f.mat',sW));
    ind=numel(inference_data)+1;
    inference_data(ind).sW=sW;
    inference_data(ind).n=100;
    inference_data(ind).Jsubs=inference_data_full(i).Jnewlist;
    err=inference_data_full(i).errlist;
    inference_data(ind).errs=err;
    inference_data(ind).errmeansq=err^2/(100^2-100);
    inference_data(ind).errsem=0;
    save(sprintf('subsamples/subsamples_%.4f.mat',sW),'subsamples');
end

%% Concatenate subsample structures
for i=1:3
    subsamples1(i).Jsubs=cat(3,subsamples1(i).Jsubs,inference_data(i).Jsubs);
    subsamples1(i).errs=[subsamples1(i).errs,inference_data(i).errs];
end

%% Number of samples required
N=99;
for n=[10 20 30 40 50 60 70 80 90 99]
    numsamp=ceil(log(.01)/log(1-(n^2-n)/(N^2-N)))
end

%% Rescale subsample errors
load('W100.mat');
W=W(2:end,2:end);
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

inference_data=subsamples_05;
index=148;

for ii=1:numel(inference_data)
    Jsubs=inference_data(ii).Jsubs;
    errs_new=[];
    for jj=1:size(Jsubs,3)
        Jsub=Jsubs(:,:,jj);
        Jsub=Jsub(2:end,2:end);
        Jsub(logical(eye(size(Jsub))))=NaN;
        [err,alph]=finderror_lsq(100,W,Jsub,'full',2);
        errs_new=[errs_new,err];
    end
    inference_data(ii).errs=errs_new;
    n=inference_data(ii).n;
    inference_data(ii).errmean=mean(errs_new.^2/(n^2-n));
    inference_data(ii).errstd=std(errs_new.^2/(n^2-n))/n;
end



inference_data(ii+1).Jsubs=inference_data_full(index).Jnewlist;
err=inference_data_full(index).err2_full;
inference_data(ii+1).errs=[err^2/(99^2-99)];
inference_data(ii+1).errmean=inference_data(ii+1).errs;
inference_data(ii+1).errstd=0;

%% New re-calculate subsample errors
load thresholds_unpinned.mat
load W100.mat
W=normalize(W);

figure
hold on

for temp=1:11
    sW=thresholds(temp,1);
    load(sprintf('subsamples/subsamples_%.4f.mat',sW));
    for ii=1:numel(inference_data)
        Jsubs=inference_data(ii).Jsubs;
        errs_new=[];
        for jj=1:size(Jsubs,3)
            Jsub=Jsubs(:,:,jj);
            Jsub(logical(eye(size(Jsub))))=NaN;
            [err,alph]=finderror_lsq(100,W,Jsub,'full',2);
            err_new=err/norm(W(~isnan(Jsub)));
            errs_new=[errs_new,err_new];
        end
        inference_data(ii).errs_new=errs_new;
        %n=subsamples(ii).n;
        inference_data(ii).errmean_new=mean(errs_new);
        %subsamples(ii).errmean=mean(errs.^2/(n^2-n));
        inference_data(ii).errsem_new=std(errs_new)/sqrt(numel(errs_new));
        %subsamples(ii).errstd=std(errs.^2/(n^2-n))/n;
    end
    plot([inference_data.errmean_new],'-o')
    save(sprintf('subsamples/subsamples_%.4f.mat',sW),'subsamples');
end