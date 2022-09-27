load('ising_inference_data_full.mat');
Jnew=inference_data_full(75 ).Jnewlist(2:end,2:end);

%Align all rows
for i=1:size(Jnew,1)
        Jnew(i,:)=circshift(Jnew(i,:),[0,1-i]);
end

imagesc(Jnew)
pca(Jnew)
