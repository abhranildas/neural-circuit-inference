load('W100.mat');
Wl=W(2:end,2:end);
Wl(logical(eye(99)))=NaN;

load('W_sb.mat');
Ws=W(2:end,2:end);
Ws(logical(eye(99)))=NaN;
    
load ising_inference_data_full.mat
lc_index=[1 16 31 46 60 75 90 104 119 133 148];
model_dists=[];
for ii=1:11    
    Jl=inference_data_full(lc_index(ii)).Jnewlist;
    Js=inference_data_sb(ii).Jnew;
    
    Jl=Jl(2:end,2:end);
    Jl(logical(eye(99)))=NaN;
    
    Js=Js(2:end,2:end);
    Js(logical(eye(99)))=NaN;
    
    [err_ll,~]=finderror_lsq(100,Wl,Jl,'full',2);
    [err_sl,~]=finderror_lsq(100,Ws,Jl,'full',2);  
    
    [err_ls,~]=finderror_lsq(100,Wl,Js,'full',2);
    [err_ss,~]=finderror_lsq(100,Ws,Js,'full',2);
    
    [err_J,~]=finderror_lsq(100,Jl,Js,'full',2);
    
    model_dists=[model_dists; [inference_data_full(lc_index(ii)).sW/2, err_ll, err_sl, err_sl-err_ll, err_ls, err_ss, err_ss-err_ls, err_J]];
end

figure
hold on
plot(model_dists(:,1),model_dists(:,2),'-o')
plot(model_dists(:,1),model_dists(:,3),'-o')
plot(model_dists(:,1),model_dists(:,4),'-o')
hold off

xlabel 'Weight strength \omega'
ylabel 'L_2-distance between models'

legend({'$|W_{lc}-\hat{W}_{lc}|_{L_2}$',...
    '$|W_{sb}-\hat{W}_{lc}|_{L_2}$',...
    '$|W_{sb}-\hat{W}_{lc}|_{L_2}-|W_{lc}-\hat{W}_{lc}|_{L_2}$'},'Interpreter','latex');

set(gca,'FontSize',13)

figure
hold on
plot(model_dists(:,1),model_dists(:,5),'-o')
plot(model_dists(:,1),model_dists(:,6),'-o')
plot(model_dists(:,1),model_dists(:,7),'-o')
hold off

xlabel 'Weight strength \omega'
ylabel 'L_2-distance between models'

legend({'$|W_{lc}-\hat{W}_{sb}|_{L_2}$',...
    '$|W_{sb}-\hat{W}_{sb}|_{L_2}$',...
    '$|W_{sb}-\hat{W}_{sb}|_{L_2}-|W_{lc}-\hat{W}_{sb}|_{L_2}$'},'Interpreter','latex');

set(gca,'FontSize',13)

figure

plot(model_dists(:,1),model_dists(:,4),'-o');
hold on
plot(model_dists(:,1),model_dists(:,7),'-o');
hold off
xlabel 'Weight strength \omega'
ylabel 'L_2-distance between models'

legend({'$|W_{sb}-\hat{W}_{lc}|_{L_2}-|W_{lc}-\hat{W}_{lc}|_{L_2}$',...
    '$|W_{sb}-\hat{W}_{sb}|_{L_2}-|W_{lc}-\hat{W}_{sb}|_{L_2}$'},'Interpreter','latex');

set(gca,'FontSize',13)

figure

plot(model_dists(:,1),model_dists(:,8),'-o');
xlabel 'Weight strength \omega'
ylabel 'L_2-distance between models'
set(gca,'FontSize',13)