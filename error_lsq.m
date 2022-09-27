function err=error_lsq(alph,W,J,type,meas)
    %discount diagonal terms:
    W(logical(eye(size(W))))=NaN;
    J(logical(eye(size(J))))=NaN;
    
    %for subsampling:
    W(isnan(J))=NaN;
    J(isnan(W))=NaN;
    
    J_scaled=alph*J;
    if strcmp(type,'full')
        diff=W-J_scaled;
        err=norm(diff(~isnan(diff)),meas)/norm(W(~isnan(W)),meas);
        %err=norm(Wclip(~isnan(Wclip))-Jnewclip_scaled(~isnan(Jnewclip)),meas);
    elseif strcmp(type,'av')        
        mean_coupling=meancoupling(J_scaled);        
        actual_coupling=meancoupling(W);
        err=norm(mean_coupling(~isnan(mean_coupling))-actual_coupling(~isnan(actual_coupling)),meas);
    end
end