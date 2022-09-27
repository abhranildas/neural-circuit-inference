function [c,x]=mycxcorr(a,b)
    x=0:length(b)-1;
    for k=0:length(b)-1
        corr=corrcoef(circshift(a,[0,-k]),b,'rows','complete');
        c(k+1)=corr(1,2);
    end