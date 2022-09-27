function B=ccg_graph_symm(R,lags)
[~,I_mat]=max(abs(R),[],3);
B=abs(lags(I_mat))<1;