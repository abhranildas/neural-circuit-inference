% this code implements minimum probability flow learning for a fully connected Ising model.  see http://arxiv.org/abs/0906.4779

% Author: Jascha Sohl-Dickstein (2009)
% Web: http://redwood.berkeley.edu/wiki/Jascha_Sohl-Dickstein
% This software is made available under the Creative Commons
% Attribution-Noncommercial License.
% (http://creativecommons.org/licenses/by-nc/3.0/)

% description = 'd=50, 10000 samples'

% initialize

%BIN THE DATA
% binnedspikelist=bin(spikelist,binsize,1000);
%binnedspikes=samps;
d = N; % number of units
nsamples = 10000; % number of training samples
maxlinesearch = 10000; % this number is excessive just to be safe!!!!!! learning works fine if this is just a few hundred
independent_steps = 10*d; % the number of gibbs sampling steps to take between samples

run_checkgrad = 0;

minf_options = [];
%options.display = 'none';
minf_options.maxFunEvals = maxlinesearch;
minf_options.maxIter = maxlinesearch;
if run_checkgrad
   d = 5;
   nsamples = 2;
   minf_options.DerivativeCheck = 'on';
% else
   % make the weight matrix repeatable
%    rand('twister',355672);
%    randn('state',355672);
end

% choose a random coupling matrix to generate the test data
% J = randn( d, d ) / sqrt(d) * 3.;
% J = J + J';
% J = J/2;
% J = J - diag(diag(J)); % set the diagonal so all the units are 0 bias
% J = J - diag(sum(J));

% fprintf( 'Generating %d training samples\n', nsamples );
% burnin = 100*d;
% % and generate the test data ...
% t_samp = tic();
% Xall = sample_ising( J, nsamples, burnin, independent_steps );
% t_samp = toc(t_samp);
% fprintf( 'training sample generation in %f seconds \n', t_samp );

% randomly initialize the parameter matrix we're going to try to learn
% note that the bias units lie on the diagonal of J
Jnew = randn( d, d ) / sqrt(d) / 100;
Jnew = Jnew + Jnew';
Jnew = Jnew/2;

% perform parameter estimation
fprintf( '\nRunning minFunc for up to %d learning steps...\n', maxlinesearch );
t_min = tic();

%%%%%%%%%%% choose one of these two Ising model objective functions %%%%%%%%%%%%%
% K_dK_ising is slightly faster, and includes connectivity only to states
% which differ by a single bit flip.
%Jnew = minFunc( @K_dK_ising, Jnew(:), minf_options, binnedspikes' );
% K_dK_ising_allbitflipextension corresponds to a slightly modified choice
% of connectivity for MPF. This modified connectivity includes an
% additional connection between each state and the state which is reached
% by flipping all bits.  This connectivity pattern performs better in cases
% (like neural spike trains) where activity is extremely sparse.
Jnew = minFunc( @K_dK_ising_allbitflipextension, Jnew(:), minf_options, binnedspikes' );

Jnew = reshape(Jnew, [d d]);
t_min = toc(t_min);
fprintf( 'parameter estimation in %f seconds \n', t_min );

% fprintf( '\nGenerating samples using learned parameters for comparison...\n' );
% Xnew = sample_ising( Jnew, nsamples, burnin, independent_steps );
% fprintf( 'sample generation with learned parameters in %f seconds \n', t_samp );

% generate correlation matrices for the original and recovered coupling matrices
% mns = mean( Xall, 2 );
% Xt = Xall - mns(:, ones(1,nsamples));
% sds = sqrt(mean( Xt.^2, 2 ));
% Xt = Xt./sds(:, ones(1,nsamples));
% Corr = Xt*Xt'/nsamples;
% mns = mean( Xnew, 2 );
% Xt = Xnew - mns(:, ones(1,nsamples));
% sds = sqrt(mean( Xt.^2, 2 ));
% Xt = Xt./sds(:, ones(1,nsamples));
% Corrnew = Xt*Xt'/nsamples;
% 
% Jdiff = J - Jnew;
% Corrdiff = Corr - Corrnew;
% jmn = min( [J(:); Jnew(:); Jdiff(:)] );
% jmx = max( [J(:); Jnew(:); Jdiff(:)] );
% cmn = min( [Corr(:); Corrnew(:); Corrdiff(:)] );
% cmx = max( [Corr(:); Corrnew(:); Corrdiff(:)] );

% show the original, recovered and differences in coupling matrices
% figure();
% subplot(2,3,1);
% imagesc( J, [jmn, jmx] );
% axis image;
% colorbar;
% title( '{J}_{ }' );
% subplot(2,3,2);
% imagesc( Jnew, [jmn, jmx] );
% axis image;
% colorbar;
% title( '{J}_{new}' );
% subplot(2,3,3);
% imagesc( Jdiff, [jmn, jmx] );
% axis image;
% colorbar;
% title( '{J}_{ } - {J}_{new}' );

% show the original, recovered and differences in correlation matrices
% subplot(2,3,4);
% imagesc( Corr, [cmn,cmx] );
% axis image;
% colorbar;
% title( '{C}_{ }' );    
% subplot(2,3,5);
% imagesc( Corrnew, [cmn,cmx] );
% axis image;
% colorbar;
% title( '{C}_{new}' );    
% subplot(2,3,6);
% imagesc( Corrdiff, [cmn,cmx] );
% axis image;
% colorbar;
% title( '{C}_{ } - {C}_{new}' );    
% 
% figure();
% plot( Corr(:), Corrnew(:), '.' );
% refline(1,0);
% axis([cmn,cmx,cmn,cmx]);
% axis image;
% xlabel( '{C}_{ }' );
% ylabel( '{C}_{new}' );
% title( 'scatter plot of correlations for original and recovered parameters' );
Jnew=-Jnew;
%Plots of recovered matrix after neutralizing diagonal.
%Means (diagonal) and average of couplings over neurons

diagonal=diag(Jnew);
%offmean=(sum(Jnew(:))-sum(diag(Jnew)))/(N^2-N); %can be improved by removing first row and column
%Jnew(logical(eye(size(Jnew)))) = NaN;

%PLOTTING START
% figure();
% subplot(3,1,1);
% imagesc(Jnew(2:N,2:N));
% axis square;
% colorbar;
% %fprintf('%8.2E',a)
% %title(sprintf('Binsize= %d\n Binned spike count=%d\nsW=%f', binsize,sum(binnedspikes(:)),sW));
% 
% 
% subplot(3,1,2);
% plot(diagonal(2:end));
% title('Means (diagonal)');
% W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
% W=((W-min(W(:)))./(max(W(:))-min(W(:)))-0.5)*2; %rescaling W between -1 and 1
% %Jnew=((Jnew-min(Jnew(:)))./(max(Jnew(:))-min(Jnew(:)))-0.5)*2; %rescaling Jnew between -1 and 1
% 
% couplings=Jnew(1,:);
% for i=2:N
%     couplings=couplings+circshift(Jnew(i,:),1-i,2);
% end
% couplings=couplings/N;
% couplings=((couplings-min(couplings(:)))./(max(couplings(:))-min(couplings(:)))-0.5)*2; %rescaling couplings between -1 and 1
% couplings=circshift(couplings,N/2-1,2);
% actualcouplings=W(25,:);
% 
% subplot(3,1,3);
% plot(couplings,'-o');
% hold on;
% plot(actualcouplings);
% hold off;
% title('Mean couplings');
% couplings(isnan(couplings))=[];
% actualcouplings(isnan(actualcouplings))=[];
% meanerr=norm(couplings-actualcouplings);

%PLOTTING END


%Put diagonal back into Jnew
%Jnew(eye(N)==1) = diagonal;

%Plot of original and recovered matrices
% figure();
% subplot(2,1,1);
% imagesc(W);
% colorbar;
% title('Original weight matrix');
% subplot(2,1,2);
% imagesc(-Jnew(2:N-1,2:N-1));
% colorbar;
% title(sprintf('Inferred Ising coupling matrix (sW= %.4f)', sW));


%figure(2);
% plot(criticalcurve(:,1),criticalcurve(:,2),'-o');
% xlim([0 .08]);
% hold on;
% plot(criticalcurve(:,1),criticalcurve(:,3),'o');
% hold off;

% [ax,p1,p2] = plotyy(criticalcurve(:,1),criticalcurve(:,2),criticalcurve(:,1),criticalcurve(:,3));
% xlim([0 .08]);

%Scatter plot of original and recovered parameters
% figure();
% plot( W(:), Jnew(:), '.' );
% refline(1,0);
% xlabel( '{J}_{ }' );
% ylabel( '{J}_{new}' );
% title( 'Scatter plot of original and recovered parameters' );
clear i t_min offmean nsamples independent_steps maxlinesearch minf_options run_checkgrad actualcouplings
%Jnew(logical(eye(size(Jnew))))=NaN;
%figure; imagesc(Jnew); axis square; colorbar
