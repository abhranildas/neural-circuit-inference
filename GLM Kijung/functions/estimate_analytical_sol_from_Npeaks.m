function [Lambda_Theta_Phase,PeakLocTriple] = estimate_analytical_sol_from_Npeaks(peakLocs,phase_ang,Lzeropad,objf,structData,frate1d)
Npks = numel(peakLocs);
idTriple = nchoosek(1:Npks,3);
if strcmp(objf,'corr')
    obj_fun = @(x,y)corr(x,y);
elseif strcmp(objf,'mse')
    obj_fun = @(x,y)sqrt(sum((x-y).^2)/numel(x));
end

for ii = 1:size(idTriple,1)
    locs = peakLocs(idTriple(ii,:));
    lambda_theta_phase = estimate_analytical_sol_from_3peaks(locs,phase_ang(idTriple(ii,:)),Lzeropad);
    alpha = lambda_theta_phase(1)/structData.gridparam(1);
    theta = lambda_theta_phase(2);
    absPhase = lambda_theta_phase(3:4);
    
    strctPred1D = extract_slice_numerically(theta,alpha,absPhase,structData);
    slice1d = strctPred1D.slice1D;
    obj_val = obj_fun(frate1d(:),slice1d(:));
    
    LTP(ii,:) = lambda_theta_phase;
    Obj_val(ii,:) = obj_val;
end

for ii = 1:Npks
    lambda_theta_phase = estimate_analytical_sol_for_0deg(peakLocs(ii),phase_ang(ii),Lzeropad);
    alpha = lambda_theta_phase(1)/structData.gridparam(1);
    theta = lambda_theta_phase(2);
    absPhase = lambda_theta_phase(3:4);
    
    strctPred1D = extract_slice_numerically(theta,alpha,absPhase,structData);
    slice1d = strctPred1D.slice1D;
    obj_val = obj_fun(frate1d(:),slice1d(:));

    LTP = [LTP; lambda_theta_phase];
    Obj_val = [Obj_val; obj_val];
end

for ii = 1:Npks
    lambda_theta_phase = estimate_analytical_sol_for_30deg(peakLocs(ii),phase_ang(ii),Lzeropad);
    alpha = lambda_theta_phase(1)/structData.gridparam(1);
    theta = lambda_theta_phase(2);
    absPhase = lambda_theta_phase(3:4);
    
    strctPred1D = extract_slice_numerically(theta,alpha,absPhase,structData);
    slice1d = strctPred1D.slice1D;
    obj_val = obj_fun(frate1d(:),slice1d(:));

    LTP = [LTP; lambda_theta_phase];
    Obj_val = [Obj_val; obj_val];
end

if strcmp(objf,'corr')    
    I = find(Obj_val==max(Obj_val));
elseif strcmp(objf,'mse')
    I = find(Obj_val==min(Obj_val));
end

if numel(I) > 1 && any(I <= size(idTriple,1))
    pl = peakLocs(idTriple(I,:));
    [~,jj] = min(abs(pl(:,3) - sum(pl(:,1:2),2)));
    I = I(jj);
end


Lambda_Theta_Phase = LTP(I,:);

if I <= size(idTriple,1)
    PeakLocTriple = peakLocs(idTriple(I,:));
elseif I <= numel(Obj_val)-Npks
    PeakLocTriple = [0 peakLocs(I-size(idTriple,1)) peakLocs(I-size(idTriple,1))];
else
    PeakLocTriple = [peakLocs(I-size(idTriple,1)-Npks) peakLocs(I-size(idTriple,1)-Npks) 2*(peakLocs(I-size(idTriple,1)-Npks))];
end





