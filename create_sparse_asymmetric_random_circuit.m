%% Sparse asymmetric random inhibitory circuit
N=100;
load W100
%imagesc(W); colorbar

% create fully connected random matrix
W_rand=unifrnd(min(W(:)),max(W(:)),N);
%figure; imagesc(W_rand); colorbar

% retain only 10% of synapses
for i=1:N
    for j=1:N
        if rand>0.1
            W_rand(i,j)=0;
        end
    end
end
figure; imagesc(W_rand); colorbar

%% Sparse asymmetric random E+I circuit
N=100;
load W100
%imagesc(W); colorbar

% create fully connected random matrix
W_rand=unifrnd(min(W(:)),-min(W(:)),N);
%figure; imagesc(W_rand); colorbar

% retain only 10% of synapses
for i=1:N
    for j=1:N
        if rand>0.1
            W_rand(i,j)=0;
        end
    end
end
figure; imagesc(W_rand); colorbar