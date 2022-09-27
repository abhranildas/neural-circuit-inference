function [err,var_err,bias_err,diff,alph]=inference_error(J,W,scale_type,scale_norm,meas_norm)
N=size(W,1);
W(logical(eye(size(W))))=NaN;
J(logical(eye(size(J))))=NaN;

%for subsampling:
W(isnan(J))=NaN;
J(isnan(W))=NaN;
    
[~,alph]=finderror_lsq(1,W,J,scale_type,scale_norm);
J=alph*J;
diff=(W-J)/norm(W(~isnan(W)),meas_norm);
err=norm(diff(~isnan(diff)),meas_norm);

J=circular_shift(J);
var_err=sqrt(N*nansum(nanvar(J)))/norm(W(~isnan(W)),meas_norm);

Jmean=nanmean(J); Wmean=meancoupling(W);
%figure; plot(Jmean); hold on; plot(Wmean)
Jmean=Jmean(~isnan(Jmean)); Wmean=Wmean(~isnan(Wmean));
diff_mean=Jmean-Wmean;
bias_err=sqrt(N)*norm(diff_mean(~isnan(diff_mean)),meas_norm)/norm(W(~isnan(W)),meas_norm);