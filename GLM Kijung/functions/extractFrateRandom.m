function [Frate1DRandom] = extractFrateRandom(Frate1D,Nsamples)
Ncell = numel(Frate1D);
Ntr = size(Frate1D{1},2);
options = statset('maxIter',1e4);
for gcell = 1:Ncell
    [pks,locs] = findpeaks(Frate1D{gcell});
    frate = Frate1D{gcell}/sum(Frate1D{gcell});
    sample = interp1(cumsum(frate),1:Ntr,1/1e4:1/1e4:1);
    
    S.mu = locs';
    S.Sigma = 7*ones(1,1,numel(pks));
    S.PComponents = ones(1,numel(pks))/numel(pks);
    obj = gmdistribution.fit(sample',numel(pks),'Start',S,'CovType','diagonal','options',options);
    V = obj.Sigma;
    
    SD{gcell,1} = sqrt(V(:));
    H{gcell,1} = pks';
    L{gcell,1} = diff([0; locs']);
    Nfield{gcell,1} = numel(pks);
end

SD = sort(cell2mat(SD));
H = sort(cell2mat(H));
L = sort(cell2mat(L));

[fSD,xSD] = ecdf(SD);
[fH,xH] = ecdf(H);
[fL,xL] = ecdf(L);
for gcell = 1:Ncell
    for ii = 1:Nsamples
        nSD = interp1(fSD,xSD,rand(Nfield{gcell},1));
        nH = interp1(fH,xH,rand(Nfield{gcell},1));
        nL = interp1(fL,xL,rand(Nfield{gcell},1));
        
        obj = gmdistribution(cumsum(nL),ones(1,1,Nfield{gcell}).*reshape(nSD.^2,1,1,Nfield{gcell}),nH);
        frate = pdf(obj,(1:Ntr)');
        Frate1DRandom{gcell}(ii,:) = frate*(max(nH)/max(frate));
        
    end 
end