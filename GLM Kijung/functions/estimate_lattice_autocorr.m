function [Autocorr,Lpeak,Lattice,Param_auto] = estimate_lattice_autocorr(Ratemap,Init_param)

[my,mx] = size(Ratemap);
% Compute the autocorrelation
Autocorr = normxcorr2(Ratemap,Ratemap);
% Search for local peaks
lp = imregionalmax(Autocorr);
[r,c] = find(lp == 1);
% Remove local peaks whose height is lower than 1% 
% of the height of the global peak
Lpeak1D = sub2ind(size(Autocorr),r,c);
thrshold = max(Autocorr(:))/100;
ind = find(Autocorr(Lpeak1D)<thrshold);
Lpeak1D(ind) = [];
[I,J] = ind2sub(size(Autocorr),Lpeak1D);
Lpeak = [J I];
% Center of the autocorrelogram
center = [mx my];
% maximum/minimum XY border of the autocorrelogram
maxXY = [2*mx-1 2*my-1];
minXY = [0 0];

q3 = 1; 
while q3 == 1
    % Plot autocorrelogram with local peaks
    figure(100); set(gcf,'color','white');
    subplot(121); imagesc(Autocorr); hold on;
    plot(Lpeak(:,1),Lpeak(:,2),'k*');
    line([mx mx],[1 2*my-1],'color','k'); line([1 2*mx-1],[my my],'color','k');
    axis equal; axis tight; set(gca,'visible','off');
    % Find out initial grid parameters x0
    if nargin == 1
        tmp = sprintf('Move the mouse pointer and click 2 nearest local peaks in quadrant I & IV.'); disp(tmp);
        x0 = find_init_param(Lpeak,center);
        tmp = sprintf('\n'); disp(tmp);
    elseif nargin == 2
        x0 = Init_param;
    else
        tmp = sprintf('Please check the number of input arguments!\n'); disp(tmp);
    end
    % Estimate the grid parameters
    [Param_auto, Lattice] = fit_lattice(x0,Autocorr-min(Autocorr(:)),Lpeak,maxXY,center);
    Param_auto = [Param_auto(2),Param_auto(1),-Param_auto(4),-Param_auto(3)];
       
    while true
        % Plot the template lattice
        subplot(122);
        plot(Lattice(:,1),Lattice(:,2),'ro'); hold on;
        plot(Lpeak(:,1),2*my-Lpeak(:,2),'k*');
        line([mx mx],[1 2*my-1],'color','k'); line([1 2*mx-1],[my my],'color','k');
        % Draw two primary Lattice vector e1 and e2
        line([mx mx+Param_auto(1)*cos(Param_auto(3))],[my my+Param_auto(1)*sin(Param_auto(3))],'color','r');
        line([mx mx+Param_auto(2)*cos(Param_auto(4))],[my my+Param_auto(2)*sin(Param_auto(4))],'color','r');

        axis equal; axis tight; hold off;
        set(gca,'xticklabel',[]); set(gca,'yticklabel',[]);
        set(gca,'xtick',[]); set(gca,'ytick',[]);
        title(['(\lambda_1,\lambda_2,\psi_1,\psi_2) = (' sprintf('%.0f,%.0f,', Param_auto(1),Param_auto(2))...
                sprintf('%.0f',rad2deg(Param_auto(3))) '\circ' sprintf(',%.0f',rad2deg(Param_auto(4))) '\circ)']);
        
        % Check whether primary lattice vectors need to be replaced by
        % the linear combination of e1 and e2
        if nargin == 1
            q1 = input(['Do you want to construct another primary Lattice vector' 10 ...
                        'by the linear combination of e1 and e2? (no=0/yes=1) : ']);
            tmp = sprintf('\n'); disp(tmp);
        else
            q1 = 0;
        end
        
        if q1 == 0, break;
        else
            coeff = input('Enter coefficient [1 by 2] : '); disp(tmp);
            param_new = [Param_auto(1)*abs(coeff(1)), Param_auto(2)*abs(coeff(2)), Param_auto(3)-pi*(coeff(1)<0), Param_auto(4)+pi*(coeff(2)<0)];
            [lambda_tmp, theta_tmp] = vector_sum(param_new);
            q2 = input(['Which do you want to replace? :' 10 ...
                        '1.{eNew,e1}' 10 '2.{eNew,e2}' 10 '3.{e1,eNew}' 10 '4.{e2,eNew}' 10 'Choose # : ']); disp(tmp);
            switch q2
                case 1, Param_auto = [lambda_tmp,Param_auto(1),theta_tmp,Param_auto(3)];
                case 2, Param_auto = [lambda_tmp,Param_auto(2),theta_tmp,Param_auto(4)];
                case 3, Param_auto = [Param_auto(1),lambda_tmp,Param_auto(3),theta_tmp];
                case 4, Param_auto = [Param_auto(2),lambda_tmp,Param_auto(4),theta_tmp];
            end
            Lattice = generate_lattice([Param_auto(1)*cos(Param_auto(3)) Param_auto(1)*sin(Param_auto(3))],...
                [Param_auto(2)*cos(Param_auto(4)) Param_auto(2)*sin(Param_auto(4))],center,minXY,maxXY);
        end
    end
    
    if nargin == 1, q3 = input('Do you want to try again? (no=0/yes=1) : '); disp(tmp);
    else q3 = 0;
    end
    close(100);
end

