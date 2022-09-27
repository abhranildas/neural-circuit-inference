%%%%%%%%%%%% fit_lattice function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Given the initial grid parameter Init_param,
% Minimize a cost function consisting of the sum of the squared distances 
% from every local peak to the nearest vertex in the template lattice,
% weighted by the correlation amplitude at that data peak
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Param,Lattice] = fit_lattice(Init_param,Correlogram,Lpeak,Max_bnd,Center,fixed_grid_param)

    R = mean(Init_param(1:2));

    if nargin == 5 % Fitting a lattice to autocorrelogram
        Init_param = [ Init_param(1)*cos(Init_param(3)) Init_param(1)*sin(Init_param(3))...
                       Init_param(2)*cos(Init_param(4)) Init_param(2)*sin(Init_param(4))];
        lb = Init_param - [5 5 5 5];
        ub = Init_param + [5 5 5 5];
    elseif nargin == 4 % Fitting a lattice to crosscorrelogram
        
        Init_param = [ Init_param(1)*cos(Init_param(3)) Init_param(1)*sin(Init_param(3))...
                       Init_param(2)*cos(Init_param(4)) Init_param(2)*sin(Init_param(4)) Init_param(5:6) ];
        lb = Init_param - [5 5 5 5 R/2 R/2];
        ub = Init_param + [5 5 5 5 R/2 R/2];
    elseif nargin == 6 % Fitting a lattice to crosscorrelogram give a fixed grid params
        grid_param_cart = [ fixed_grid_param(1)*cos(fixed_grid_param(3)) fixed_grid_param(1)*sin(fixed_grid_param(3))...
                            fixed_grid_param(2)*cos(fixed_grid_param(4)) fixed_grid_param(2)*sin(fixed_grid_param(4)) ];
                
        lb = Init_param - [R/2 R/2];
        ub = Init_param + [R/2 R/2];
    else
        tmp = sprintf('Please check the number of input arguments!\n'); disp(tmp);
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    options = optimset('display','off','algorithm','interior-point');
    [Param] = fmincon(@costf,Init_param,[],[],[],[],lb,ub,[],options);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if nargin == 5
        [psi1, lambda1] = cart2pol(Param(1),Param(2));
        [psi2, lambda2] = cart2pol(Param(3),Param(4));
    
        Lattice = generate_lattice([Param(3) -Param(4)],[Param(1) -Param(2)],Center,[0 0],Max_bnd);
        Param = [lambda1 lambda2 psi1 psi2];
    elseif nargin == 4
        [psi1, lambda1] = cart2pol(Param(1),Param(2));
        [psi2, lambda2] = cart2pol(Param(3),Param(4));
    
        Lattice = generate_lattice([Param(3) -Param(4)],[Param(1) -Param(2)],[Param(5) Max_bnd(2)+1-Param(6)],[0 0],Max_bnd);
        Param = [lambda1 lambda2 psi1 psi2 Param(5:6)];
    elseif nargin == 6
        [psi1, lambda1] = cart2pol(grid_param_cart(1),grid_param_cart(2));
        [psi2, lambda2] = cart2pol(grid_param_cart(3),grid_param_cart(4));

        Lattice = generate_lattice([grid_param_cart(3) -grid_param_cart(4)],[grid_param_cart(1) -grid_param_cart(2)],[Param(1) Max_bnd(2)+1-Param(2)],[0 0],Max_bnd);
        Param = [lambda1 lambda2 psi1 psi2 Param];    
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    function [Min_cost] = costf(x)
        if length(x) == 4
            lattice = generate_lattice(x(1:2),x(3:4),Center,[0 0],Max_bnd);
        elseif length(x) == 6
            lattice = generate_lattice(x(1:2),x(3:4),x(5:6),[0 0],Max_bnd);
        else
            lattice = generate_lattice(grid_param_cart(1:2),grid_param_cart(3:4),x,[0 0],Max_bnd);
        end
        N = size(Lpeak,1);
        correl = nan(N,1);
        L2dist = nan(N,1);
        for ii = 1:N
            Lp = Lpeak(ii,:);
            diffP = Lp(ones(1,size(lattice,1)),:) - lattice;
            %diffP = repmat(Lpeak(ii,:), size(lattice,1), 1) - lattice;
            correl(ii,1) = Correlogram(Lpeak(ii,2),Lpeak(ii,1));
            L2dist(ii,1) = sqrt(min(sum(diffP.^2,2)));
        end
        Min_cost = L2dist'*correl;
    end
end