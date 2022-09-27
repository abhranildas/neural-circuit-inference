function [coeff] = gen_coeff_spatialtuning_from_more_cells(coeff,dBs,Dxy,Ncell)

for gcell = 1:Ncell
    % Spatial Tuning
    if true
        cff_gcell = coeff(2:dBs.n_fb+1);
        cff_gcell = reshape(cff_gcell,dBs.n_fb/2,2); % n_fb/2 by 2

        phi = atan2(-cff_gcell(:,2),cff_gcell(:,1)); % n_fb/2 by 1
        amp = sqrt(sum(cff_gcell.^2,2));

        phi_new = (2*pi*(-Dxy(gcell,:))*dBs.fBasis')' + phi;
        cff_new{gcell,1} = [amp.*cos(phi_new); -amp.*sin(phi_new)];
    end
    
    if gcell == Ncell
        temp = [];
        for gc = 1:Ncell
            temp = [temp; coeff(1); cff_new{gc}];
        end
        coeff = temp;
    end
end