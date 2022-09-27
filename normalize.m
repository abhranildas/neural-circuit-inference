function W_normalized=normalize(W)
    W(logical(eye(size(W)))) = NaN; %setting diagonal to NaN before rescaling.
    W_normalized=(W-min(W(:)))./(max(W(:))-min(W(:)))-1; %rescaling W between -1 and 0
end