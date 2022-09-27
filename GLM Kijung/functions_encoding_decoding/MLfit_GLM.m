function [dBs,output] = MLfit_GLM(modelName,isLasso,dataIn)
Ncell = size(dataIn.nspk,2);
dBs = struct;
if strcmp(modelName,'space') == 1 % Assuming indep spatial tuning
    [dBs.fBasis,dBs.funcSpaceCos,dBs.funcSpaceSin] = makeBasis_Space(dataIn);
    XspaceCos = dBs.funcSpaceCos([dataIn.position_x dataIn.position_y],dBs.fBasis);
    XspaceSin = dBs.funcSpaceSin([dataIn.position_x dataIn.position_y],dBs.fBasis);
    X = [XspaceCos XspaceSin];
    X = [ones(size(X,1),1) X];
    temp = X;
    for gcell = 2:Ncell
        X = blkdiag(X,temp);
    end
    
    dBs.n_fb = 2*size(XspaceCos,2);
    dBs.n_totalb = dBs.n_fb;
    clear XspaceCos XspaceSin temp;
elseif strcmp(modelName,'space_shared') == 1 % Imposing relative phase info
    [dBs.fBasis,dBs.funcSpaceCos,dBs.funcSpaceSin] = makeBasis_Space(dataIn);
    X = [];
    for gcell = 1:Ncell
        XspaceCos = dBs.funcSpaceCos([dataIn.position_x-dataIn.Dxy(gcell,1)...
                                      dataIn.position_y-dataIn.Dxy(gcell,2)],dBs.fBasis);
        XspaceSin = dBs.funcSpaceSin([dataIn.position_x-dataIn.Dxy(gcell,1)...
                                      dataIn.position_y-dataIn.Dxy(gcell,2)],dBs.fBasis);
        X = [X; [XspaceCos XspaceSin]];
    end
    X = [ones(size(X,1),1) X];
    
    dBs.n_fb = 2*size(XspaceCos,2);
    dBs.n_totalb = dBs.n_fb;
    dBs.n_subtotalb = dBs.n_fb;
    clear XspaceCos XspaceSin;
elseif strcmp(modelName,'stimAll') == 1 % Assuming space_shared
    [dBs.fBasis,dBs.funcSpaceCos,dBs.funcSpaceSin] = makeBasis_Space(dataIn);
    Xspeed = dataIn.speed;
    X = [];
    for gcell = 1:Ncell
        XspaceCos = dBs.funcSpaceCos([dataIn.position_x-dataIn.Dxy(gcell,1)...
                                      dataIn.position_y-dataIn.Dxy(gcell,2)],dBs.fBasis);
        XspaceSin = dBs.funcSpaceSin([dataIn.position_x-dataIn.Dxy(gcell,1)...
                                      dataIn.position_y-dataIn.Dxy(gcell,2)],dBs.fBasis);
        X = [X; [XspaceCos XspaceSin Xspeed]]; % Assuming shared speed tuning
    end
    X = [ones(size(X,1),1) X];
    
    Xhdir = makeBasis_Direction(dataIn.hdir);
    temp = Xhdir;
    for gcell = 2:Ncell
        Xhdir = blkdiag(Xhdir,temp); % Assuming indep dir tuning
    end
    X = [X Xhdir];
    
    dBs.n_fb = 2*size(XspaceCos,2);
    dBs.n_sb = 1;
    dBs.n_db = size(Xhdir,2)/Ncell;
    dBs.n_totalb = dBs.n_fb+dBs.n_sb+dBs.n_db;
    dBs.n_subtotalb = dBs.n_fb+dBs.n_db;
    clear XspaceCos XspaceSin Xspeed Xhdir temp 
elseif strcmp(modelName,'history') == 1 % Should correct as above!
    [dBs.fBasis,dBs.funcSpaceCos,dBs.funcSpaceSin] = makeBasis_Space(dataIn);
    Xspeed = dataIn.speed;
    X = [];
    for gcell = 1:Ncell
        XspaceCos = dBs.funcSpaceCos([dataIn.position_x-dataIn.Dxy(gcell,1)...
                                      dataIn.position_y-dataIn.Dxy(gcell,2)],dBs.fBasis);
        XspaceSin = dBs.funcSpaceSin([dataIn.position_x-dataIn.Dxy(gcell,1)...
                                      dataIn.position_y-dataIn.Dxy(gcell,2)],dBs.fBasis);
        X = [X; [XspaceCos XspaceSin Xspeed]]; % Assuming shared speed tuning
    end
    X = [ones(size(X,1),1) X];
    
    Xhdir = makeBasis_Direction(dataIn.hdir);
    temp = Xhdir;
    for gcell = 2:Ncell
        Xhdir = blkdiag(Xhdir,temp); % Assuming indep dir tuning
    end
    X = [X Xhdir];
    
    Xhistory = cell(0);
    for gcell = 1:Ncell
        [xhistory,dBs.historyBasis,~] = makeBasis_History(dataIn.nspk(:,gcell));
        Xhistory{gcell,1} = xhistory;
    end
    X = [X cell2mat(Xhistory)];
    
    dBs.n_fb = 2*size(XspaceCos,2);
    dBs.n_sb = 1;
    dBs.n_db = size(Xhdir,2)/Ncell;
    dBs.n_hb = size(xhistory,2);
    dBs.n_totalb = dBs.n_fb+dBs.n_sb+dBs.n_db+dBs.n_hb;
    clear XspaceCos XspaceSin Xspeed Xhdir Xhistory xhistory temp
end

tic;
nspk_all = dataIn.nspk;
nspk_all = nspk_all(:);
if isLasso
    [output, FitInfo] = lassoglm(X,nspk_all,'poisson','CV',10);
    %eval(['save data_' modelName '_lasso' num2str(isLasso) '_thrsh' num2str(dataIn.threshold) '.mat dBs output FitInfo']);
else
    s.Link = @(x) log(x/dataIn.dt);
    s.Inverse = @(x) exp(x)*dataIn.dt;
    s.Derivative = @(x) 1./x;
    
    output = fitglm(X,nspk_all,'linear','Distribution','poisson','Link',s,'Intercept',false);
    %eval(['save data_' modelName '_lasso' num2str(isLasso) '_thrsh' num2str(dataIn.threshold) '.mat dBs output']);
end
toc;