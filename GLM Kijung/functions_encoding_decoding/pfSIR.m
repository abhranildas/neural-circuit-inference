% Y is T by Ncell matrix.
% CovM is a pre-defined covariance matrix for a Gaussian random walk.
function [Xhats] = pfSIR(Y,CovM,maxYX,DBS,BetaMat,pos_init,vel_init,dt,Tinit,Tend,modelName,pos,vel)
    
%     plot(pos_init(1),pos_init(2),'k*','markersize',15); hold on;
    
    % The number of particles
    alpha = 0.1;
    Sig = 4*chol(CovM);
    Sig(1,2) = 0;
    Nptc = 1e3;
    [T, Ncell] = size(Y);

    % Draw samples for the initial position
    %vel_past = [0 0];
    vel_past = vel(1,:);
    %vel_past = vel(2,:);
    %Xptc = bsxfun(@plus,pos_init + vel_past*dt,((Sig+diag(alpha*abs(vel_past*dt)))*randn(2,Nptc))');
    Xptc = bsxfun(@plus,pos_init, ((Sig+diag(alpha*abs(vel_past*dt)))*randn(2,Nptc))');
    
    xest = pos_init;
    
    Xhats = zeros(T,2);
    Xhats(Tinit,:) = pos_init;
    %Covhats = cell(T,1);
    %Covhats{1,1} = zeros(2,2);
    Xptc_hist = repmat(pos_init,Nptc,1);

    for ii = 2:Tend-Tinit+1
        tidx = Tinit + ii - 1;
        % Step 1: compute weights according to the obsv. eq.
        Xptc_past = Xptc_hist;
        
        if strcmp(modelName,'history') == 1
            Lhistory = size(DBS.historyBasis,1);
            
            if tidx <= Lhistory
                Ypast = zeros(Lhistory,Ncell);
                Ypast(1:tidx-1,:) = flipud(Y(max(1,tidx-Lhistory):tidx-1,:));
            else
                Ypast = flipud(Y(max(1,tidx-Lhistory):tidx-1,:));
            end
        else
            Ypast = [];
        end
        
        ws = computeLogLikelihoods(Xptc,Xptc_past,Y(tidx,:),Ypast,DBS,BetaMat,dt,modelName);
        ws = exp(ws-max(ws));
        ws = ws/sum(ws);
        %ws = ones(length(ws),1)/length(ws);
        
        % Step 2: importance sampling
        idx = mnrnd(Nptc,ws);
        S = bsxfun(@le,bsxfun(@plus,zeros(Nptc,1),1:max(idx)),idx');
        [idxs,~] = find(S);
        Xptc = Xptc(idxs,:);
        
        Xptc_hist = Xptc;
        Xhats(tidx,:) = sum(Xptc.*[ws ws],1);%mean(Xptc);
        %Xhats(tidx,:) = round(Xhats(tidx,:)) + 1; % finite resolution
        %Covhats{tidx,1} = cov(Xptc);
        
%         plot(Xhats(1:tidx,1),Xhats(1:tidx,2),'b*','markersize',15); hold on; axis equal;
%         plot(Xptc(:,1),Xptc(:,2),'b.','markersize',2);
%         plot(pos(1:tidx,1),pos(1:tidx,2),'k*','markersize',15);
%         %xest(tidx,:) = xest(tidx-1,:) + vel(tidx,:)*dt;
%         %plot(xest(1:tidx,1),xest(1:tidx,2),'ro');
%         drawnow;
%         
%         pause;
%         hold off;
        
        % Step 3: propagate each particle through the state eq.
        vel_past = (Xhats(tidx,:) - Xhats(tidx-1,:))/dt;
        %vel_past = [0 0];
        
        %vel = (Xhats(tidx,:) - Xhats(tidx-1,:))/dt;
        %vel_past = 1/3*vel_past + 2/3*vel;
        
        %vel_past = vel(tidx+1,:);
        
        %Xptc_temp = Xptc + ones(Nptc,1)*vel_past*dt;
        %Xptc_temp = Xptc + ones(Nptc,1)*vel_past*dt + ((Sig+diag(alpha*abs(vel_past*dt)))*randn(2,Nptc))';
        Xptc_temp = Xptc + ((Sig+diag(alpha*abs(vel_past*dt)))*randn(2,Nptc))';
                
        %vt = mean(sqrt(sum((Xhats(ii,:)-Xhats(ii-1,:)).^2,2))/dt);
        %Xptc_temp = Xptc + ((Sig+vt/10000*eye(2))*randn(2,Nptc))';
        
        % Step 3.5: enforce particles to be inside the circular enclosure
        % (Boundary Constraint)
        alpha_temp = alpha;
        while true
            idx = find(sum((Xptc_temp-50).^2,2) > (maxYX(1)/2)^2);
            
            %[r_min,~] = find(Xptc_temp<0);
            %[r_max,~] = find(Xptc_temp>50);
            %idx = union(r_min,r_max);
            
            if isempty(idx)
                break;
            else
                Xptc_temp(idx,:) = Xptc(idx,:) + ones(length(idx),1)*vel_past*dt +...
                                 ((Sig+diag(alpha_temp*abs(vel_past*dt)))*randn(2,length(idx)))';
                %Xptc_temp(idx,:) = Xptc(idx,:) + ((Sig+vt/10000*eye(2))*randn(2,length(idx)))';
                alpha_temp = alpha_temp + 0.1;
            end
        end
        Xptc = Xptc_temp;
        
        if mod(ii,1000) == 0
            fprintf('Iteration %d\n',ii);
        end
    end

    function [lls] = computeLogLikelihoods(x,x_past,y,y_past,dBs,BetaMat,dt,modelName)
        speed = abs(x(:,1)-x_past(:,1) + 1i*(x(:,2)-x_past(:,2)))/dt;
        hdir = angle(x(:,1)-x_past(:,1) + 1i*(x(:,2)-x_past(:,2)));
            
        XspaceCos = dBs.funcSpaceCos(x,dBs.fBasis);
        XspaceSin = dBs.funcSpaceSin(x,dBs.fBasis);
        Xspace = [XspaceCos XspaceSin];
        Xspace = [ones(size(Xspace,1),1) Xspace];

        if strcmp(modelName,'space') == 1 || strcmp(modelName,'space_shared') == 1
            loglambdas = Xspace*BetaMat; % Nptc by Ncell
        elseif strcmp(modelName,'stimAll') == 1
            Xhdir = makeBasis_Direction(hdir);
            loglambdas = [Xspace speed Xhdir]*BetaMat; % Nptc by Ncell
        elseif strcmp(modelName,'history') == 1
            Xhdir = makeBasis_Direction(hdir);
            loglambdas = [Xspace speed Xhdir]*BetaMat(1:dBs.n_totalb-dBs.n_hb+1,:)...
                                + ones(size(Xspace,1),1)*diag(y_past'*dBs.historyBasis*BetaMat(end-dBs.n_hb+1:end,:))'; % Nptc by Ncell
        end

        lls = loglambdas*y' - sum(loglambdas,2)*dt;
    end
end