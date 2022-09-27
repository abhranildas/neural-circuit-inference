function [err_shift,mu_error_shift,deltaXY_optimal] = correct_decoded_position(position_x,position_y,Xhats)

delta = -100:100;
errxy = nan(numel(delta),numel(delta));
for ii = 1:numel(delta)
    for jj = 1:numel(delta)
        errxy(ii,jj) = mean(sqrt((position_x-(Xhats(:,1)+delta(jj))).^2 + (position_y-(Xhats(:,2)+delta(ii))).^2));
    end
end
[iy,ix] = find(errxy == min(min(errxy)));
deltaXY_optimal = [delta(ix) delta(iy)];
err_shift = sqrt((position_x-(Xhats(:,1)+delta(ix))).^2 + (position_y-(Xhats(:,2)+delta(iy))).^2);
mu_error_shift = mean(err_shift);