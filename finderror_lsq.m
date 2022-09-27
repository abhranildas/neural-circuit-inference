function [err,alph]=finderror_lsq(alph0,W,J,type,meas)
%discount diagonal terms:
W(logical(eye(size(W))))=NaN;
J(logical(eye(size(J))))=NaN;

if nanmin(meancoupling(J))
    alph0=nanmin(meancoupling(W))/nanmin(meancoupling(J));
end
[alph,~] = fminunc(@(alph)error_lsq(alph,W,J,type,meas),alph0);
err=error_lsq(alph,W,J,type,meas);
%Jnewclip_scaled=alph*Jnewclip;
%err=norm(Wclip(~isnan(Wclip))-Jnewclip_scaled(~isnan(Jnewclip_scaled)),meas);
end