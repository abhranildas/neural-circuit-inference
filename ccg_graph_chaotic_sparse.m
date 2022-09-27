function B=ccg_graph_chaotic_sparse(R,lags)
[~,I_mat]=max(abs(diff(R,1,3)),[],3);
B=abs(lags(I_mat))<1/3;