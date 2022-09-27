function [Frate1DRandom] = generate_1d_random_response(ratID,fromWhatTrials,Nsamples)
% fromWhatTrials can be a scalar (e.g. 5) or a vector (e.g. 35:45).
% Nsamples is the number of random samples to be generated.

eval(['load data_' ratID '/T10_' ratID]);
pathway = ['data_' ratID '/T10*c*.mat'];
files = dir(pathway);
Ncell = length(files);
VR_y = (VR_y-min(VR_y))/2;
sd1DKernel = 7;
strctParams = struct('VR_time_interval_in_seconds',1/30,'sd1DKernel',sd1DKernel);

for gcell = 1:Ncell
    eval(['load data_' ratID '/' files(gcell).name]);
    strctData = struct('VR_y',VR_y,'VR_spike_times',VR_spike_times,'VR_position_times',VR_position_times);
    
    [frate,~,~,~,~] = extractFrate(fromWhatTrials,strctParams,strctData);
    Frate1D{gcell} = frate;
end

Frate1DRandom = extractFrateRandom(Frate1D,Nsamples);
%eval(['save data_' ratID '/dataRandom.mat Frate1DRandom']);


