function [Xhistory,historyBasis,historyMat] = makeBasis_History(spkTrain)
ihbasprs.ncols = 11;
ihbasprs.hpeaks = [1 70];
ihbasprs.b = 1;
%dt = .1; % For pictorial purpose
dt = 1; % For computing purpose
[~,~,historyBasis] = makeBasis_PostSpike(ihbasprs,dt);
historyBasis(1,:) = 0;
% set(figure,'color','white');
% plot(iht, ihbasis);axis tight;box off; set(gca,'tickdir','out');
% xlabel('Time after spike (ms)','fontsize',20);
% title('Pose-spike filter basis','fontsize',20);

histL = size(historyBasis,1);
if size(spkTrain,2) ~= 1
    spkTrain = spkTrain'; % T by 1
end
T = size(spkTrain,1);
historyMat = zeros(T,histL);
for ii = 1:histL
    historyMat(ii:T,ii) = spkTrain(1:T-ii+1); %T by histL
end
Xhistory = historyMat*historyBasis;