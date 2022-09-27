%% change inference error stored in a struct to new definition

load W100

for i=1:numel(inference_data)
    i
    err_list_newest=nan(1,size(inference_data(i).Jlist,3));
    var_err_list_newest=nan(1,size(inference_data(i).Jlist,3));
    bias_err_list_newest=nan(1,size(inference_data(i).Jlist,3));
    for j = 1:size(inference_data(i).Jlist,3)
        J=inference_data(i).Jlist(:,:,j);
        [err, var_err, bias_err]=inference_error(J,W);
        err_list_newest(j)=err;
        var_err_list_newest(j)=var_err;
        bias_err_list_newest(j)=bias_err;
    end
    inference_data(i).err_list_newest=err_list_newest;
    inference_data(i).var_err_list_newest=var_err_list_newest;
    inference_data(i).bias_err_list_newest=bias_err_list_newest;
    
    inference_data(i).err_mean_newest=mean(err_list_newest);
    inference_data(i).var_err_mean_newest=mean(var_err_list_newest);
    inference_data(i).bias_error_mean_newest=mean(bias_err_list_newest);
    
    inference_data(i).err_sem_newest=std(err_list_newest)/sqrt(numel(err_list_newest));
    inference_data(i).var_err_sem_newest=std(var_err_list_newest)/sqrt(numel(var_err_list_newest));
    inference_data(i).bias_err_sem_newest=std(bias_err_list_newest)/sqrt(numel(bias_err_list_newest));
end

%% calculate variance and bias error for J_merged in subsampling struct
load W100
for i=1:numel(subsamples)
    i
    J=subsamples(i).J_merged;
    [err, var_err, bias_err]=inference_error(J,W);
    subsamples(i).merged_err=err;
    subsamples(i).merged_var_err=var_err;
    subsamples(i).merged_bias_err=bias_err;
end
%% visualize bias angle surface
plot3(data(:,1),data(:,2),atand(data(:,5)./data(:,4))/90,'.','MarkerSize',12,'MarkerEdgeColor','black','MarkerFaceColor','black')
set(gca,'yscale','log')
%set(gca,'zscale','log')
ylim([1e6 1e8])
set(gca,'xdir','reverse')
xlabel 'r'
ylabel 'data vol.'
zlabel 'prop. of bias \theta_b'
set(gca, 'fontsize', 13)
grid on

%% err vs data
% at lowest r
plot(data(1:21,2),data(1:21,3).^2,'-o')
hold on
plot(data(1:21,2),data(1:21,5).^2,'-o')
set(gca,'xscale','log')
%set(gca,'yscale','log')
xlim([1e6 1e8])
xlabel 'data vol.'
ylabel 'squared inference error'
set(gca,'fontsize',13)
legend('total sq. error \Delta^2', 'sq. bias error \Delta_b^2')

% at highest r
figure
plot(data(211:end,2),data(211:end,3).^2,'-o')
hold on
plot(data(211:end,2),data(211:end,5).^2,'-o')
set(gca,'xscale','log')
%set(gca,'yscale','log')
xlim([1e6 1e8])
xlabel 'data vol.'
ylabel 'squared inference error'
set(gca,'fontsize',13)
xlabel 'data vol.'
ylabel 'inference error'
set(gca,'fontsize',13)
legend('total sq. error \Delta^2', 'sq. bias error \Delta_b^2')