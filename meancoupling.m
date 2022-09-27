function couplings=meancoupling(J)
couplings_aligned=J(1,:);
for i=2:size(J,1)
    couplings_aligned=[couplings_aligned;circshift(J(i,:),1-i,2)];
end
couplings=nanmean(couplings_aligned);
couplings=circshift(couplings,(round(size(J,1)/2)-1),2);