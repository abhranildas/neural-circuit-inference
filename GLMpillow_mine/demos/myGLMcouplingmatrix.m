clearvars -except ktbas ihbas iht

nkt=20;

dtStim = .01; % Bin size for simulating model & computing likelihood (in units of stimulus frames)
dtSp = .005;  % Bin size for simulating model & computing likelihood (must evenly divide dtStim);


load('../../binnedspikes100/sW 0.050.mat')

sps1=binnedspikes(1:end-1,2);
sps2=binnedspikes(1:end-1,3);
Stim=ones(size(sps1,1)/2,1);

[gg1,gg2]=myGLMcouplingfit(sps1,sps2,dtSp,Stim,dtStim,nkt,ktbas,ihbas,iht);

subplot(211); % --Spike filters cell 1 % -------------
plot(gg1.iht, (gg1.ih));
title('exponentiated incoming h filters');
legend('estim h11', 'estim h21');
axis tight;
subplot(212); % --Spike filters cell 2 % ------------- 
plot(gg2.iht, (gg2.ih));
title('exponentiated incoming h filters');
axis tight; xlabel('time (s)')
legend('estim h22', 'estim h12');