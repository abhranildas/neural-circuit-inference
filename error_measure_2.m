set(0,'DefaultFigureWindowStyle','docked');
errlist=[];
for i=1:size(inference_data,2)
    load(sprintf('binnedspikes100_1e8/sW %.3f.mat',inference_data(i).sW));
    covmat=cov(binnedspikes);
    Cinv=covmat(2:end,2:end);
    Cinv(logical(eye(size(Cinv)))) = NaN;
    Cinv=(Cinv-min(Cinv(:)))./(max(Cinv(:))-min(Cinv(:)))-1;
    
    Jnew=inference_data(i).Jnew(2:end,2:end);
    Jnew(logical(eye(size(Jnew)))) = NaN;
    Jnew=(Jnew-min(Jnew(:)))./(max(Jnew(:))-min(Jnew(:)))-1;
    
    err=norm(Cinv(~isnan(Cinv))-Jnew(~isnan(Jnew)));
    errlist=[errlist;[inference_data(i).sW,err]];
end

plot(errlist(:,1),errlist(:,2),'-o');
xlabel('Weight strength \omega');
ylabel('Distance between covariance matrix and inferred weight matrix');

