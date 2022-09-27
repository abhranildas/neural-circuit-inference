load W_rand_symm
inference_data=struct;
dataindex=size(inference_data,2)+1;

load('binnedspikes_rand_symm/sW 0.0100.mat')
maxdatasize=size(binnedspikes,1);

for datasize=round(maxdatasize*10.^(0:-.25:-5))   
    fprintf('data fraction: %.1e\n', datasize/maxdatasize)
    
    J=glm_inf_binned(binnedspikes(1:datasize,:));
    err=inference_error(J,W,'full',2,2);

    inference_data(dataindex).spikecount=sum(sum(binnedspikes(1:datasize,:)));
    inference_data(dataindex).J=J;
    inference_data(dataindex).err=err;
    
    dataindex=dataindex+1;
    save('inference_data_random_glm_cumulative_2.mat', 'inference_data');
end