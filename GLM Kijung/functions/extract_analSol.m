function [strctOutput] = extract_analSol(frate,strctData)

L = numel(frate);
Lzeropad = 2^12;%2^nextpow2(2^nextpow2(L)+1);
frateNorm = frate - mean(frate);
Y = fft(frateNorm,Lzeropad)/Lzeropad;
phaseAng = angle(Y);
phaseAng(phaseAng<0) = 2*pi + phaseAng(phaseAng<0);
powerSpectra = Y.*conj(Y);
powerSpectra = powerSpectra/max(powerSpectra);

[pks,locs] = findpeaks(powerSpectra);
[pks,idsort] = sort(pks(1:floor(numel(pks)/2)),'descend');
locs = locs(idsort);
phaseAng = phaseAng(idsort);

NlocsCand = 3;
locs_cand = locs(1:NlocsCand);
pks_cand = pks(1:NlocsCand);
phaseAng_cand = phaseAng(1:NlocsCand);
[locs_cand,I] = sort(locs_cand,'ascend');
pks_cand = pks_cand(I);
phaseAng_cand = phaseAng_cand(I);

locsPair = locs_cand(combntns(1:NlocsCand,2));
pksPair = pks_cand(combntns(1:NlocsCand,2));
phaseAngPair = phaseAng_cand(combntns(1:NlocsCand,2));

for mycase = 1:2
    for ii = 1:size(locsPair,1)
        k1 = nan; k2 = nan; k3 = nan;
        k1H = nan; k2H = nan; k3H = nan;
        switch mycase
            case 1
                k1 = locsPair(ii,1)/Lzeropad; k1H = pksPair(ii,1);
                k2 = locsPair(ii,2)/Lzeropad; k2H = pksPair(ii,2);
                lambda = sqrt(1/(k1^2+k1*k2+k2^2));
                theta = rad2deg(asin(sqrt(3)*lambda*k1/2));
            case 2
                k1 = locsPair(ii,1)/Lzeropad; k1H = pksPair(ii,1);
                k3 = locsPair(ii,2)/Lzeropad; k3H = pksPair(ii,2);
                lambda = sqrt(1/(k1^2-k1*k3+k3^2));
                theta = rad2deg(asin(sqrt(3)*lambda*k1/2));
%             case 3
%                 k2 = locsPair(ii,1)/Lzeropad; k2H = pksPair(ii,1);
%                 k3 = locsPair(ii,2)/Lzeropad; k3H = pksPair(ii,2);
%                 theta = atan((k3+k2)/(k3-k2)/sqrt(3));
%                 lambda = (cos(theta)-sin(theta)/sqrt(3))/k2;
%                 theta = rad2deg(theta);
        end
        
        if theta > 30, theta = 60-theta; end
        phi = [phaseAngPair(ii,1); phaseAngPair(ii,2)];
        freqD = [0         2/sqrt(3)/lambda;
                 1/lambda -1/sqrt(3)/lambda];
        absPhase = freqD\phi/(2*pi)/lambda;

        strctPred1D = extract_slice(theta,lambda,absPhase,strctData);
        slice1D = strctPred1D.slice1D;

        frPredNorm = slice1D - mean(slice1D);
        Y = fft(frPredNorm,Lzeropad)/Lzeropad;
        powerSpectraPred = Y.*conj(Y);
        powerSpectraPred = powerSpectraPred/max(powerSpectraPred);
        MSEfft(ii,mycase) = sum((powerSpectra-powerSpectraPred).^2)/numel(powerSpectra);
        MSEfrate(ii,mycase) = sum((frate/max(frate)-slice1D/max(slice1D)).^2)/numel(frate);
        Corrfft(ii,mycase) = corr(powerSpectra',powerSpectraPred');
        Corrfrate(ii,mycase) = corr(frate',slice1D');
        
        locPks{ii,mycase} = [k1 k2 k3];
        locPksH{ii,mycase} = [k1H k2H k3H];
        th(ii,mycase) = theta;
        lamb(ii,mycase) = lambda;
        slc{ii,mycase} = slice1D;
        fftPred{ii,mycase} = powerSpectraPred;
        absPh{ii,mycase} = absPhase;
        
    end
end

[costf,I] = max(Corrfrate(:));
[ii,mycase] = ind2sub([size(locsPair,1) 3],I);
theta = th(ii,mycase);
lambda = lamb(ii,mycase);
peaks3 = locPks{ii,mycase};
peaks3H = locPksH{ii,mycase};
powerSpectraPred = fftPred{ii,mycase};
slice1D = slc{ii,mycase};
absPhase = absPh{ii,mycase};

strctOutput = struct('theta',theta,'lambda',lambda,'absPhase',absPhase,'peaks3',peaks3,'peaks3H',peaks3H,...
'slice1D',slice1D,'powerSpectra',powerSpectra,'powerSpectraPred',powerSpectraPred,'Lzeropad',Lzeropad,'costf',costf);

% plot((0:80-1)/Lzeropad, powerSpectra(1:80),'b','linewidth',1); hold on; axis fill; box off; hold on;
% stem((locs_cand-1)/Lzeropad,pks_cand,'r'); axis tight;
% title(['\theta = ' num2str(theta,3) ' , \alpha = ' num2str(lambda,3)],'fontsize',12);
