function [frate,spike_loc,animal_loc,Ntr,speed] = extractFrate(fromWhatTrials,strctParams,strctData)
% Call parameters & data
VR_time_interval_in_seconds = strctParams.VR_time_interval_in_seconds;
sd1DKernel = strctParams.sd1DKernel;
VR_y = strctData.VR_y;
VR_spike_times = strctData.VR_spike_times;
VR_position_times = strctData.VR_position_times;
%
L = ceil(max(VR_y))*1;
lapStartingPosInd = find(diff(VR_y)<-400);
lapStartingPosInd = [0; lapStartingPosInd; length(VR_y)];
x = -8*sd1DKernel:8*sd1DKernel;
kernel = 1/sqrt(2*pi*sd1DKernel^2)*exp(-x.^2/(2*sd1DKernel^2));
ignorableTrack = 0;
%% Binning the position & spike samples
for ii = 1:numel(fromWhatTrials)
    tr = fromWhatTrials(ii);
    lap_spktimes = VR_spike_times( all([VR_spike_times>VR_position_times(lapStartingPosInd(tr)+1), VR_spike_times<=VR_position_times(lapStartingPosInd(tr+1))],2) );

    spike_loc{ii,1} = interp1(VR_position_times(lapStartingPosInd(tr)+1:lapStartingPosInd(tr+1)),VR_y(lapStartingPosInd(tr)+1:lapStartingPosInd(tr+1)),lap_spktimes);
    if ignorableTrack ~= 0
        spike_loc{ii}(spike_loc{ii} < ignorableTrack) = [];
        spike_loc{ii} = spike_loc{ii} - ignorableTrack;
    end
    if isempty(spike_loc{ii}), spike_loc{ii} = nan; end
    [Nc,~] = hist(spike_loc{ii},0.5:1:0.5*2*L-ignorableTrack);
    Nspk(ii,:) = Nc;

    animal_loc{ii,1} = VR_y(lapStartingPosInd(tr)+1:lapStartingPosInd(tr+1));
    if ignorableTrack ~= 0
        animal_loc{ii}(animal_loc{ii} <= ignorableTrack) = [];
        animal_loc{ii} = animal_loc{ii} - ignorableTrack;
    end
    [N,~] = hist(animal_loc{ii},0.5:1:0.5*2*L-ignorableTrack);
    Npos(ii,:) = N;
    
    speed{ii,1} = diff(animal_loc{ii})/VR_time_interval_in_seconds/100;    
end
%% Compute the average firing rate
posSum = sum(Npos,1);
posSum(posSum == 0) = 1;
spkSum = sum(Nspk,1);
frate = conv( spkSum./(posSum*VR_time_interval_in_seconds),kernel,'same');

Ntr = numel(lapStartingPosInd)-1;
%% Estimate analytic solutions of original and bootstrapped frates
% for Nsample = 1:1001
%     if Nsample == 1
%         frateBootstr(Nsample,:) = frate;
%     else
%         % Method 1
%         spkloc = cell2mat(spike_loc);
%         indspk = randsample(numel(spkloc),numel(spkloc),'true');
%         sampled_spkloc = spkloc(indspk);
%         [Nc,~] = hist(sampled_spkloc,0.5:1:0.5*2*L-ignorableTrack);
%         frateBootstr(Nsample,:) = conv( Nc./(posSum*VR_time_interval_in_seconds),kernel,'same');
% 
% %         % Method 2
% %         R = poissrnd(frate*VR_time_interval_in_seconds);
% %         frateBootstr(Nsample,:) = conv(R,kernel/max(kernel),'same');        
%     end
% 
%     fr = frateBootstr(Nsample,:);
%     autocorr = fr;%normxcorr2(frate,frate);
%     L = numel(autocorr);
%     Lzeropad = 2^nextpow2(2^nextpow2(L)+1);
%     windowFr = autocorr.*gausswin(L)';
%     windowFr = windowFr - mean(windowFr);
%     Y = fft(windowFr,Lzeropad)/Lzeropad;
%     powerSpectra = Y.*conj(Y);
%     powerSpectra = powerSpectra/max(powerSpectra);
% 
%     [pks,locs] = findpeaks(powerSpectra);
%     [pks,idsort] = sort(pks(1:floor(numel(pks)/2)),'descend');
%     locs = locs(idsort)-1;
%     locs = locs(1:3); 
%     pks = pks(1:3);
% 
%     k1 = locs(1)/Lzeropad;
%     k2 = locs(2)/Lzeropad;
%     P(Nsample,1) = sqrt(1/(k1^2+k1*k2+k2^2));
%     theta(Nsample,1) = rad2deg(asin(sqrt(3)*P(Nsample)*k1/2));
%     if theta(Nsample,1) > 30, theta(Nsample,1) = 60-theta(Nsample,1); end
%     
%         
% %         subplot(10,10,Nsample);
% %         plot((0:60-1)/Lzeropad, powerSpectra(1:60)/max(powerSpectra(1:60)),'b','linewidth',1); hold on; axis fill; box off; hold on;
% %         stem(locs/Lzeropad,pks,'r');
% %         axis tight;
% %         if Nsample == 1, title(['trial # ' num2str(tr) 10 ...
% %            '\theta = ' num2str(theta(Nsample),3) ' , \alpha = ' num2str(alpha(Nsample),2)],'fontsize',12);
% %         else title(['Shuffle # ' num2str(Nsample-1) 10 ...
% %            '\theta = ' num2str(theta(Nsample),3) ' , \alpha = ' num2str(alpha(Nsample),2)],'fontsize',12); 
% %         end
% end




