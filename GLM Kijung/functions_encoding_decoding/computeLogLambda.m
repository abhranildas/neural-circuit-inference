function [loglambdas] = computeLogLambda(x,x_past,y_past,dBs,BetaMat,dt,modelName)

% speed = abs(x(:,1)-x_past(:,1) + 1i*(x(:,2)-x_past(:,2)))/dt;
% hdir = angle(x(:,1)-x_past(:,1) + 1i*(x(:,2)-x_past(:,2)));

XspaceCos = dBs.funcSpaceCos(x,dBs.fBasis);
XspaceSin = dBs.funcSpaceSin(x,dBs.fBasis);
Xspace = [XspaceCos XspaceSin];
Xspace = [ones(size(Xspace,1),1) Xspace];

if strcmp(modelName,'space') == 1 || strcmp(modelName,'space_shared') == 1
    loglambdas = Xspace*BetaMat; % Nptc by Ncell
% elseif strcmp(modelName,'stimAll') == 1
%     Xhdir = makeBasis_Direction(hdir);
%     loglambdas = [Xspace speed Xhdir]*BetaMat; % Nptc by Ncell
% elseif strcmp(modelName,'history') == 1
%     Xhdir = makeBasis_Direction(hdir);
%     loglambdas = [Xspace speed Xhdir]*BetaMat(1:dBs.n_totalb-dBs.n_hb+1,:)...
%                         + ones(size(Xspace,1),1)*diag(y_past'*dBs.historyBasis*BetaMat(end-dBs.n_hb+1:end,:))'; % Nptc by Ncell
end
