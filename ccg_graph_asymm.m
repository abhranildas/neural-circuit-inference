function [Z,B]=ccg_graph_asymm(R)
N=size(R,1);
max_lag=(size(R,3)-1)/2;
Z=zeros(N);
for i=1:N
    for j=i+1:N
        R_b=reshape(R(i,j,:),[1 size(R,3)]);
        R_f=fliplr(R_b);        
        R_d=diff(R_f);
        [~,i_max]=max(abs(R_d(max_lag:max_lag+1)));
        i_max=i_max+max_lag-1;       
        R_rest=R_d([1:i_max-2,i_max+2:end]);
        d_norm=(R_d(i_max)-mean(R_rest))/std(R_rest);
        if d_norm<0
            Z(i,j)=d_norm;
        else
            Z(j,i)=-d_norm;
        end
        % plot
%         subplot(2,1,1)
%         plot(R_f)
%         ylabel 'cross-corr.'
%         title([i j])
%         %title(sprintf('actual weight=%.g',W(i,j)))
%         subplot(2,1,2)
%         plot(R_d)
%         xlabel 'shifts (units of tau)'
%         ylabel 'diff(cross-corr.)'
%         pause
    end
end
Z(logical(eye(N)))=nan;
B=abs(Z)>3;