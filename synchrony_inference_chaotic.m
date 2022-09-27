max_lag=300;
lags=(-max_lag:max_lag)/100;

load W_chaotic_sparse
inference_data=struct;
dataindex=size(inference_data,2)+1;

rlist=10.^linspace(-2,2,10);

for i=6
    r=rlist(i);%10.^linspace(-2,2,10)
    load(sprintf('data_chaotic_net_sparse/r %.2f.mat',r));
    %binnedspikes=cast(bin(binnedspikes,3,0,0),'single');
    h=cast(h,'single');
    
    maxdatasize=size(h,1);    
    for datasize=round(maxdatasize*10.^(-.25:-.25:-5))
        Rlist=[];
        Blist=logical([]);
        for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
            fprintf('r: %.2f, data fraction: %.1e, startpoint: %.1f\n', [r,datasize/maxdatasize,startpoint/(maxdatasize-datasize+1)])
            
            R=spike_ccg(h(startpoint:startpoint+datasize-1,:),max_lag);
            %B=ccg_graph_asymm(R);
            B=ccg_graph_chaotic_sparse(R,lags);
            
            Rlist=cat(4,Rlist,R);
            Blist=cat(3,Blist,B);
        end
        
        inference_data(dataindex).r=r;
        inference_data(dataindex).datasize=datasize;
        inference_data(dataindex).Rlist=Rlist;
        inference_data(dataindex).Blist=Blist;
        
        dataindex=dataindex+1;
        save('inference_data_chaotic_sparse_CCG_2.mat', 'inference_data', '-v7.3');
    end 
end

%% flip through CCG's
for j=2:100
    subplot(2,1,1)
    plot(lags,permute(R(1,j,:),[3 1 2]))
    title(W(1,j))
    subplot(2,1,2)
    plot(lags(1:end-1),diff(permute(R(1,j,:),[3 1 2])))
    pause
end

%% Combine CCG graph with GLM weights
for i=1:11
    %inference_data_sync(i).Blist=logical(inference_data_sync(i).Blist);
    %inference_data_sync(i).Jlist=inference_data_sync(i).Jlist.*inference_data_sync(i).Blist;
    J=inference_data_sync(i).Jlist;
    [err,var_err,bias_err]=inference_error(J,W,'full',2,2);
    inference_data_sync(i).errlist=[err];
    inference_data_sync(i).var_err_list=[var_err];
    inference_data_sync(i).bias_err_list=[bias_err];
end
    
    