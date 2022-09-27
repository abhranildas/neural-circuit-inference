load W100

for i=1:numel(inference_data)
    err_list_newest=[];
    %var_err_list_newest=[];
    %bias_err_list_newest=[];
    for j=1:size(inference_data(i).Jlist,3)
        [i j]
        J=inference_data(i).Jlist(:,:,j);
        %[err,var_err,bias_err]=inference_error(J,W);
        err=inference_error(J,W);
        err_list_newest=[err_list_newest,err];
        %var_err_list_newest=[var_err_list_newest,var_err];
        %bias_err_list_newest=[bias_err_list_newest,bias_err];
    end
    
    inference_data(i).err_list_newest=err_list_newest;
    inference_data(i).err_mean_newest=mean(err_list_newest);
    inference_data(i).err_sem_newest=std(err_list_newest)/sqrt(numel(err_list_newest));
    
    %inference_data(i).var_err_list_newest=var_err_list_newest;
    %inference_data(i).var_err_mean_newest=mean(var_err_list_newest);
    %inference_data(i).var_err_sem_newest=std(var_err_list_newest)/sqrt(numel(var_err_list_newest));
    
    %inference_data(i).bias_err_list_newest=bias_err_list_newest;
    %inference_data(i).bias_err_mean_newest=mean(bias_err_list_newest);
    %inference_data(i).bias_err_sem_newest=std(bias_err_list_newest)/sqrt(numel(bias_err_list_newest));
end
