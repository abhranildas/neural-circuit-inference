load inference_ising_ising.mat

N=100;
load('W100.mat');

%Wclip=W(2:N,2:N);
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0

bias_error_data=[];

for ii=find([inference_data.meanspikecount]<2e6)
    Jnew=inference_data(ii).Jnewlist(:,:,1);            
    %Jnewclip=Jnew(2:end,2:end);
    Jnew(logical(eye(size(Jnew)))) = NaN;       
    [err,alph]=finderror_lsq(100,W,Jnew,'av',1);        
    Jnew=alph*Jnew;
    couplings=Jnew(1,:);
    for i=2:N
        couplings=couplings+circshift(Jnew(i,:),1-i,2);
    end
    couplings=couplings/N;
    couplings=circshift(couplings,N/2-1,2);
    actualcouplings=W(N/2,:);
    
    %err2=norm(couplings(~isnan(couplings))-actualcouplings(~isnan(actualcouplings)),1);

    figure
    hold on;
    plot(couplings,'-o');    
    plot(actualcouplings,'-o');
    hold off;
%     title(err);
    bias_error_data=[bias_error_data; [inference_data(ii).sW, err]];
    legend('Inferred avg coupling', 'Original weight profile','Location','southeast');
end

figure
plot(bias_error_data(:,1), bias_error_data(:,2),'-o');

%save bias_error_data.mat bias_error_data