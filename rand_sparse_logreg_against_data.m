load W_rand_sparse
%load W_rand_symm
load thresholds_rand_sparse
%load thresholds_rand_symm

%inference_data=struct;
load inference_data_rand_sparse_logreg
dataindex=size(inference_data_l,2)+1;
N=100;

for i=7    
    sW=thresholds(i,1);
    
    load(sprintf('binnedspikes_rand_sparse/sW %.3f.mat',sW));
    %load(sprintf('binnedspikes_rand_symm/sW %.4f.mat',sW));
    
    binnedspikes0=bin(binnedspikes,100,0,0);
    %binnedspikes0=binnedspikes(:,subindex); % for 50% subsampling
    
    maxdatasize=size(binnedspikes0,1);    
    for datasize=round(maxdatasize*10.^(-4:-.25:-5))
        for lambda=0:5:20
            binnedspikecountlist=[];
            Jlist=[];
            err_list=[];
            var_err_list=[];
            bias_err_list=[];        
            for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
                fprintf('sW: %.4f, data fraction: %.1e, lambda: %d, startpoint: %.1f\n', [sW,datasize/maxdatasize,lambda,startpoint/(maxdatasize-datasize+1)])
                binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
                binnedspikecount=sum(binnedspikes(:));
                binnedspikecountlist=[binnedspikecountlist,binnedspikecount];
                J=logreg_fullJ(binnedspikes,lambda);
                
                Jlist=cat(3,Jlist,J);
                err=inference_error(J,W,'full',2,2);
                err_list=[err_list,err];                
            end
            inference_data_l(dataindex).sW=sW;
            inference_data_l(dataindex).meanspikecount=mean(binnedspikecountlist);
            inference_data_l(dataindex).spikecounts=binnedspikecountlist;
            inference_data_l(dataindex).lambda=lambda;
            inference_data_l(dataindex).Jlist=Jlist;
            
            inference_data_l(dataindex).err_list=err_list;
            inference_data_l(dataindex).err_mean=mean(err_list);
            inference_data_l(dataindex).err_sem=std(err_list)/sqrt(numel(err_list));
            
            dataindex=dataindex+1;
            save('inference_data_rand_sparse_logreg.mat', 'inference_data_l', 'inference_data_l_opt_maxdata', 'inference_data_l_opt_rmax');
        end
    end 
end