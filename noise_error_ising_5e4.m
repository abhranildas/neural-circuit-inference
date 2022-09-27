noise_error_data=[];

for ii=1:10
    Jnew=inference_data(ii).Jnew;    
    Jnew(logical(eye(100)))=NaN;
    figure
    imagesc(Jnew);
    axis square
    
    for i=1:size(Jnew,1)
        Jnew(i,:)=circshift(Jnew(i,:),[0,1-i]);
    end



    m = 100;          % Window length
    %f = (0:m-1)/m;     % Frequency range (a little bit of cheating to make it 100 instead of 99)
    totpower=zeros(100,1);
    for i=2:size(Jnew,2)
        x=Jnew(:,i);
        y = fft(x);           % DFT
        power = y.*conj(y)/m;   % Power of the DFT
        %power = power./sum(power);
        totpower=totpower+power;
    %     figure
    %     plot(f,power);
    end
%     figure
%     plot(x)
%     refline(0,y(1)/100)
    %totpower=totpower(2:end);
    totpower=totpower./sum(totpower);
%     figure
%     plot(f(2:end),totpower,'-o');
%     ylim([0 1]);
    %Power in pattern frequency and harmonics
%     pattern_power=sum(totpower([4 8 12 16 95 91 87 83]));
    % and all power in noise:
    %FIGURE OUT THE CIRCULARITY/INDEXING
    noise_error_data=[noise_error_data; [inference_data(ii).sW, sum(totpower(2:end))]];
end

figure
plot(noise_error_data(:,1),noise_error_data(:,2),'-o');
set(gca,'yscale', 'log')

%save noise_error_data.mat noise_error_data