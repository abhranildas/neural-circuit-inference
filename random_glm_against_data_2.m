%load W_rand_sparse
%load W_rand_symm
load W_chaotic_sparse
%load thresholds_rand_sparse
%load thresholds_rand_symm

inference_data=struct;
%load inference_data_rand_symm_glm
dataindex=size(inference_data,2)+1;
N=100;

rlist=10.^linspace(-2,2,10);

for i=6
    %sW=thresholds(i,1);
    r=rlist(i);    
    %load(sprintf('binnedspikes_rand_sparse/sW %.3f.mat',sW));
    %load(sprintf('binnedspikes_rand_symm/sW %.4f %d.mat',[sW iter]));
    load(sprintf('data_chaotic_net_sparse/r %.2f.mat',r));
    
    %binnedspikes0=bin(binnedspikes,100,0,0);
    binnedspikes0=h;
    maxdatasize=size(binnedspikes0,1);
    for datasize=round(maxdatasize*10.^(-.25:-.25:-5))
        for lambda=0 %[0:5:50,60:10:100,150,200,250,300,400]
            %spikecounts=[];
            Jlist=[];
            err_list=[];
            for startpoint=1:round(maxdatasize/5):maxdatasize-datasize+1
                fprintf('r: %.4f, data fraction: %.1e, startpoint: %.1f\n', [r,datasize/maxdatasize,startpoint/(maxdatasize-datasize+1)])
                binnedspikes=binnedspikes0(startpoint:startpoint+datasize-1,:);
                %spikecounts=[spikecounts,sum(binnedspikes(:))];
                %J=glm_inf_binned(binnedspikes);
                J=logreg_fullJ(binnedspikes,lambda);
                Jlist=cat(3,Jlist,J);
                
                err=inference_error(J,W,'full',2,2);
                err_list=[err_list,err];
            end
            inference_data(dataindex).r=r;
            inference_data(dataindex).datasize=datasize;
            %inference_data(dataindex).meanspikecount=mean(spikecounts);
            %inference_data(dataindex).spikecounts=spikecounts;
            %inference_data(dataindex).lambda=lambda;
            inference_data(dataindex).Jlist=Jlist;
            
            inference_data(dataindex).err_list=err_list;
            inference_data(dataindex).err_mean=mean(err_list);
            inference_data(dataindex).err_sem=std(err_list)/sqrt(numel(err_list));
            
            dataindex=dataindex+1;
            %save('inference_data_rand_sparse_logreg.mat', 'inference_data');
            save('inference_data_chaotic_sparse_2.mat', 'inference_data');
        end
    end
end