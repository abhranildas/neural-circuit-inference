function couplings=meancoupling_noshift(J)
couplings=J(1,:);
for i=2:size(J,1)
    couplings=couplings+circshift(J(i,:),1-i,2);
end
couplings=couplings/(size(J,1));