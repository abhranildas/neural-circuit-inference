function J=circular_shift(J)
for i=1:size(J,1)
    J(i,:)=circshift(J(i,:),[0,1-i]);
end
J=circshift(J,(round(size(J,1)/2)-1),2);