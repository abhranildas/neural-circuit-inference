% for dyn_glm data, inference_data_dyn_glm_new.mat
% for dyn_ising data, unpinned_inf_full.mat

load W100
load unpinned_inf_full %inference_data_dyn_glm_new.mat

N=100;

%Wclip=W(2:N,2:N);
W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W=normalize(W); %rescaling W between -1 and 0
actual_coupling=meancoupling(W);

bias_error_data=[];

for ii=find([inference_data_full.meanspikecount]>9e7)
    Jnew=inference_data_full(ii).Jnewlist(:,:,1);            
    %Jnewclip=Jnew(2:end,2:end);
    Jnew(logical(eye(size(Jnew)))) = NaN;       
    [err,alph]=finderror_lsq(100,W,Jnew,'av',2);       
    Jnew=alph*Jnew;
    mean_coupling=meancoupling(Jnew);
    %err2=norm(couplings(~isnan(couplings))-actualcouplings(~isnan(actualcouplings)),1);
    figure
    hold on;
    plot(mean_coupling,'-o');    
    plot(actual_coupling,'-o');
    hold off;
    bias_error_data=[bias_error_data; [inference_data_full(ii).sW, err/norm(actual_coupling(~isnan(actual_coupling)),2)]];
    legend('Inferred avg coupling', 'Original weight profile','Location','southeast');
end

figure
plot(bias_error_data(:,1), bias_error_data(:,2),'-o');

%save bias_error_dyn_ising.mat bias_error_data