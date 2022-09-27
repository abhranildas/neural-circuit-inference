% +++++++++++++++++++++++++++++++++++++++++++++++++++++++
% main.m is a script to run Grid Cell encoding model
% and learn model parameters through maximum likelihood.
%
% Created by: KiJung Yoon (kijung.yoon@gmail.com)
% Created on: July 17, 2015
% Last modified: July 17, 2015
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear all; close all; setpath;

% Need to arragne real/synthetic GC data to run this code.
% Vectors below can be a matrix if the number of GCs > 1
Data.position_x = position_x; % vector of animal's position x (cm)
Data.position_y = position_y; % vector of animal's position y (cm)
Data.Y = Y; % vector of binary spikes
Data.Dxy = Dxy; % amount of phase offset (unit: cm)
Data.gridparam = mean(Param_auto,1); % average grid parameters
maxYX = size(Ratemap{1}); % size of environment
Data.maxYX = maxYX;

Params.modelName = 'space_shared'; % OR 'space' / 'stimAll' / 'history'
Params.isLasso = 0; % True (1) / False (0)
Params.Nfreq = 24; % # of Fourier basis functions
Params.Ncell = 5; % # of cells from the same (putative) network

% Cross-validation
Params.dt = 5e-4; % modify dt depending on the source of data (unit: sec)
Params.Tinit = 1; % training set
Params.Tend = round(length(Data.position_x)*0.8);
Params.testInit = round(length(Data.position_x)*0.8) + 1; % test set
Params.testEnd = length(Data.position_x);
doTraining = true;

if Params.Ncell <= 20 && doTraining
    [coeff,dBs] = encode_gridcells(Data,Params);
    mkdir(modelName);
    eval(['save ' modelName '/encode_cells' num2str(Params.Ncell) '_simult_' Params.modelName '_Nfreq'...
          num2str(Params.Nfreq) '.mat coeff dBs']);
elseif ncell <= 20 && ~doTraining
    eval(['load ' modelName '/encode_cells' num2str(Params.Ncell) '_simult_' Params.modelName '_Nfreq'...
          num2str(Params.Nfreq) '.mat coeff dBs']);
else
    eval(['load ' modelName '/encode_cells' num2str(500) '_simult_' Params.modelName '_Nfreq'...
          num2str(Params.Nfreq) '.mat coeff dBs']);

    [coeff] = gen_coeff_spatialtuning_from_more_cells(coeff,dBs,Data.Dxy,ncell);
end

mkdir(modelName);
eval(['save ' modelName '/encode_cells' num2str(Params.Ncell) '_simult_' Params.modelName '_Nfreq'...
      num2str(Params.Nfreq) '.mat coeff dBs']);


%% (Optional) Generate data from trained GLM
modelName = Params.modelName;
Ncell = Params.Ncell;
testInit = Params.testInit;
testEnd = Params.testEnd;
dt = Params.dt;

position_x = Data.position_x;
position_y = Data.position_y;
Y = Data.Y;
position_x = position_x - min(position_x); 
position_y = position_y - min(position_y);
% position_x = position_x(testInit:testEnd);
% position_y = position_y(testInit:testEnd);

if strcmp(modelName,'space') == 1 || strcmp(modelName,'space_shared') == 1
    BetaMat = reshape(coeff,1+dBs.n_fb,Ncell);
elseif strcmp(modelName,'stimAll') == 1
    BetaMat = reshape(coeff,1+dBs.n_totalb,Ncell);
elseif strcmp(modelName,'history') == 1
    BetaMat = reshape(coeff,1+dBs.n_totalb,Ncell);
end

[loglambdas] = computeLogLambda([position_x position_y],[],[],dBs,BetaMat,dt,modelName);
rate = exp(loglambdas)*dt;

Y = rate > rand(length(position_x),Ncell);
%save cells5_GLM.mat position_x position_y Y

