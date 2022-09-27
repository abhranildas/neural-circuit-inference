%% CXCOV Circular Cross Covariance function estimates. 
% CXCOV(a,b), where a and b are two signals of the same length, both
% periodic signals and real.
%%
%[lags,cc]=CXCOV(a,b) returns the length M-1 circular cross covariance
%sequence cc with corresponded lags.
%%
% The circular cross covariance is the normalized circular cross correlation function of
% two vectors with their means removed:
%         c(k) = sum[a(n)-mean(a))*conj(b(n+k)-mean(b))]/[norm(a-mean(a))*norm(b-mean(b))]; 
% where vector b is shifted CIRCULARLY by k samples.
%%
% The function doesn't check the format of input vectors a and b!
%%
% For circular correlation and also the slower implementation of Cross Covariance 
% between a and b look for CXCORR(a,b) (written by G. Levin, Apr. 26, 2004.) in
% http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objectType=author&objectId=1093734
%%
% For Cross Covariance of real signals, the current method is about 30 times faster than
% the method suggested by Levin using For-loop.
% 
% Author: Ehsan Azarnasab, Aug. 17, 2006.
%%
function [lags,cc]=CXCOV(a,b)

cc=ifft(fft(a).*fft(b(length(b):-1:1)))/(norm(a)*norm(b));
lags=1:length(b);

return
