N=100;
load('W100.mat');

Wclip=W(2:N,2:N);
Wclip(logical(eye(size(Wclip)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
Wclip=(Wclip-min(Wclip(:)))./(max(Wclip(:))-min(Wclip(:)))-1; %rescaling W between -1 and 0

alph0=100;

type='full';
meas=2;

for ii=1:size(inference_data,2)
%     err1_list=[];
    err2_full_list=[];
    for j=1:size(inference_data(ii).Jnewlist,3)
        Jnew=inference_data(ii).Jnewlist(:,:,j);
        
        %For MPF        
%         Jnewclip=Jnew(2:end,2:end);
%         Jnewclip(logical(eye(size(Jnewclip)))) = NaN;
        
        %For Mean Field
        Jnewclip=Jnew;
        Jnewclip(logical(eye(size(Jnewclip)))) = NaN;
        
        if inference_data(ii).meanspikecount>9e7
            alph0=100;
        end        
        [err2,alph0]=finderror_lsq(alph0,Wclip,Jnewclip,type,meas);
        %err2=error_lsq(1,Wclip,Jnewclip,type,meas);
%         err1_list=[err1_list,err1];
        err2_full_list=[err2_full_list,err2];        
    end
    Jnewclip_scaled=alph0*Jnewclip;
    %Jnewclip_scaled=Jnewclip;
    couplings=Jnewclip_scaled(1,:);
    for i=1:N-1
        couplings=couplings+circshift(Jnewclip_scaled(i,:),1-i,2);
    end
    couplings=couplings/(N-1);
    couplings=circshift(couplings,N/2-1,2);

    figure
    hold on;
    plot(couplings,'-o');
    actualcouplings=Wclip(N/2,:);        
    plot(Jnewclip_scaled(N/2,:),'-o');
    plot(actualcouplings,'-o');
    hold off;
    title(sprintf('sW=%.3f, data=%0.3g spikes, alpha=%.1f',[inference_data(ii).sW,inference_data(ii).spikecounts(j),alph0]));
    legend('Inferred avg coupling', 'Inferred sample row', 'Original weight profile','Location','southeast');
%     inference_data_full(ii).err1_full_list=err1_full_list;
%     inference_data_full(ii).err1_full=mean(err1_full_list);
%     inference_data_full(ii).err1_av_list=err1_list;
%     inference_data_full(ii).err1_av=mean(err1_list);
    inference_data(ii).err2_full_list=err2_full_list;
    inference_data(ii).err2_full=mean(err2_full_list);
end