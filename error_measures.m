set(0,'DefaultFigureWindowStyle','docked');
cvlist=[];
for j=1:size(inference_data,2)
    Jnew=inference_data(j).Jnew(2:end,2:end);
    Jnew(logical(eye(size(Jnew)))) = NaN;
    figure
    imagesc(Jnew);
    axis square
%     Jnew=(Jnew-min(Jnew(:)))./(max(Jnew(:))-min(Jnew(:)))-1;
    for i=2:size(Jnew,1)
        Jnew(i,:)=circshift(Jnew(i,:),[0,1-i]);
    end

    cv=var(Jnew)./mean(Jnew);
    v=var(Jnew);
    figure
    subplot(2,1,1);
    imagesc(Jnew);
    %axis square
    subplot(2,1,2);
    plot(cv(2:end));
%     cvlist=[cvlist,mean(cv(2:end))];
    cvlist=[cvlist,mean(v(2:end))];    
end

figure
plot([inference_data.sW],abs(cvlist),'-o');
xlabel('Weight strength \omega');
