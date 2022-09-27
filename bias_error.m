function bias_err=bias_error(J,W)
N=size(W,1);
W(logical(eye(size(W))))=nan;
Wmean=meancoupling(W);
Wmean=Wmean(~isnan(Wmean));
[~,alph]=finderror_lsq(100,W,J,'av',1);
J=alph*J;
J(logical(eye(size(J))))=nan;
J=circular_shift(J);
J=J(:,[1:49 51:end]);
Jmean=mean(J);
bias_err=sqrt(N)*norm(Jmean-Wmean,2)/norm(W(~isnan(W)),2);