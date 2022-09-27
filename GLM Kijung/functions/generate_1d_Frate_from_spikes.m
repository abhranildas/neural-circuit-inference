function [Frate1D,SpikeLoc,AnimalLoc] = generate_1d_Frate_from_spikes(idAnimal,strctParams,nTrialAvg,fromWhatTrial)

eval(['load data_' idAnimal '/T10_' idAnimal]);
pathway = ['data_' idAnimal '/T10*c*.mat'];
files = dir(pathway);
Ncell = length(files);
VR_y_cm = VR_y_cm - min(VR_y_cm);

for gcell = 1:Ncell
    eval(['load data_' idAnimal '/' files(gcell).name]);
    strctData = struct('VR_y',VR_y_cm,'VR_spike_times',VR_spike_times_microsec,'VR_position_times',VR_position_times_microsec);
    
    if nargin == 3
        % Compute N-trials average firing rates across all trials.
        [~,~,~,Ntr,~] = extractFrate(1,strctParams,strctData);
        frate = [];
        for tr = 1:Ntr-nTrialAvg+1
            consecutiveTrials = tr:tr+nTrialAvg-1;
            [fr,spike_loc,animal_loc,~,~] = extractFrate(consecutiveTrials,strctParams,strctData);
            frate(tr,:) = fr;
            spikeLoc{tr,1} = spike_loc;
            animalLoc{tr,1} = animal_loc;
        end
    elseif nargin == 4
        % Compute a N-trials average firing rate from a specific trial.
        consecutiveTrials = fromWhatTrial:fromWhatTrial+nTrialAvg-1;
        [frate,spikeLoc,animalLoc,~,~] = extractFrate(consecutiveTrials,strctParams,strctData);
    else
        tmp = sprintf('Please check the number of input arguments!\n'); disp(tmp);
    end
    Frate1D{gcell} = frate;
    SpikeLoc{gcell} = spikeLoc;
    AnimalLoc = animalLoc;
end



