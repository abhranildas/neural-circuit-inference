function [gg1,gg2]=myGLMcouplingfit(sps1,sps2,dtSp,Stim,dtStim,nkt,ktbas,ihbas,iht)
    %% ===== 4. Fit cell #1 (with coupling from cell #2) =================== %%
    sps=[sps1,sps2];
    slen=size(Stim,1);

    % Compute Spike-triggered averages
    sps1 = sum(reshape(sps(:,1),[],slen),1)'; % bin spikes in bins the size of stimulus
    sta1 = simpleSTC(Stim,sps1,nkt); % Compute STA 1
    sta1 = reshape(sta1,nkt,[]); 

    sps2 = sum(reshape(sps(:,2),[],slen),1)'; % rebinned spike train
    sta2 = simpleSTC(Stim,sps2,nkt); % Compute STA 2
    sta2 = reshape(sta2,nkt,[]); 

    % Initialize param struct for fitting 
    gg0 = makeFittingStruct_GLM(dtStim,dtSp);  % Initialize params for fitting struct 

    % Initialize fields (using h and k bases computed above)
    gg0.ktbas = ktbas; % k basis
    gg0.ihbas = ihbas; % h self-coupling basis
    gg0.ihbas2 = ihbas; % h coupling-filter basis
    nktbasis = size(ktbas,2); % number of basis vectors in k basis
    nhbasis = size(ihbas,2); % number of basis vectors in h basis
    gg0.kt = 0.1*(ktbas\sta1); % initial params from scaled-down sta 
    gg0.k = gg0.ktbas*gg0.kt;  % initial setting of k filter
    gg0.ihw = zeros(nhbasis,1); % params for self-coupling filter
    gg0.ihw2 = zeros(nhbasis,1); % params for cross-coupling filter
    gg0.ih = [gg0.ihbas*gg0.ihw gg0.ihbas2*gg0.ihw2];
    gg0.iht = iht;
    gg0.dc = 0; % Initialize dc term to zero
    gg0.couplednums = 2; % number of cell coupled to this one (for clarity)

    % Set spike responses for cell 1 and coupled cell
    gg0.sps = sps(:,1);  
    gg0.sps2 = sps(:,2); 

    % Compute initial value of negative log-likelihood (just to inspect)
    [neglogli0,rr] = neglogli_GLM(gg0,Stim);

    % Do ML fitting
    fprintf('Fitting neuron 1:  initial neglogli0 = %.3f\n', neglogli0);
    opts = {'display', 'iter', 'maxiter', 100};
    [gg1, neglogli1] = MLfit_GLM(gg0,Stim,opts); % do ML (requires optimization toolbox)


    %% ===== 5. Fit cell #2 (with coupling from cell #1) ==================

    gg0b = gg0; % initial parameters for fitting 
    gg0b.sps = sps(:,2); % cell 2 spikes
    gg0b.sps2 = sps(:,1); % spike trains from coupled cells 
    gg0.kt = 0.1*(ktbas\sta2); % initial params from scaled-down sta 
    gg0b.k = gg0b.ktbas*gg0b.kt; % Project STA onto basis for fitting
    gg0.couplednums = 1; % number of cell coupled to this one

    % Compute initial value of negative log-likelihood (just to inspect)
    [neglogli0b] = neglogli_GLM(gg0b,Stim); % initial value of negative logli

    % Do ML fitting
    fprintf('Fitting neuron 2: initial neglogli = %.3f\n', neglogli0b);
    [gg2, neglogli2] = MLfit_GLM(gg0b,Stim,opts); % do ML (requires optimization toolbox)
end