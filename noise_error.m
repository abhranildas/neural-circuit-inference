% for dyn_glm data, inference_data_dyn_glm_new.mat
% for dyn_ising data, unpinned_inf_full.mat

load W100
load inference_data_dyn_glm_new %unpinned_inf_full
noise_error_data=[];
m=100; % window length

for ii=find([inference_data.meanspikecount]>9e7)
    J=inference_data(ii).Jlist(:,:,1);    
    [~,alph]=finderror_lsq(100,W,J,'full',2);        
    J=alph*J;
    for i=1:size(J,1)
        J(i,:)=circshift(J(i,:),[0,1-i]);
    end
    
    J=J(:,2:end); % remove column 1 (diagonal).
    
    f=zeros(100,99); % FFT's of columns
    for i=1:size(J,2)
        f(:,i) = fft(J(:,i));
    end
  
    power = abs(f).^2;   % Power of the DFT
    power=power./sum(power); % relative power
    power_mean=mean(power,2); % average of relative power spectra.

    noise_error_data=[noise_error_data; [inference_data(ii).sW, sum(power_mean(2:end))]];
end

figure
plot(noise_error_data(:,1),noise_error_data(:,2),'-o');

save noise_error_dyn_glm.mat noise_error_data