%% Fuller comparison between models
set(0,'DefaultFigureWindowStyle','docked');
load('thresholds_unpinned.mat');
load inference_data_pinned_maxdata.mat

load('W100.mat');
W_lc=W(2:end,2:end);
W_lc(logical(eye(size(W_lc)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W_lc=(W_lc-min(W_lc(:)))./(max(W_lc(:))-min(W_lc(:)))-1; %rescaling W between -1 and 0

load('W_sb.mat');
W_sb=W(2:end,2:end);
W_sb(logical(eye(size(W_sb)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W_sb=(W_sb-min(W_sb(:)))./(max(W_sb(:))-min(W_sb(:)))-1; %rescaling W between -1 and 0

for temp=[1 6 11]
    sW=thresholds(temp,1)
    load(sprintf('binnedspikes_pinned/sW %.4f.mat',sW));
    figure    
%     subplot(3,1,1)
    plot(mean(binnedspikes(:,2:end)));
    hold on
    load(sprintf('binnedspikes_sb/sW %.4f.mat',sW));
    plot(mean(binnedspikes(:,2:end)));
    hold off
    legend('Local connections activity','Side-bands activity', 'Location', 'SouthEast');
    title(sprintf('w=%.4f',sW));
%     subplot(3,1,2)
%     Jnew_lc=inference_data_maxdata(temp).Jnew(2:end,2:end);
%     Jnew_lc(logical(eye(size(Jnew_lc))))=NaN;
%     [err,alph]=finderror_lsq(100,W_lc,Jnew_lc,'full',2);
%     Jnew_lc=alph*Jnew_lc;
%     plot(meancoupling(W_lc));
%     hold on
%     plot(meancoupling(Jnew_lc));
%     hold off
%     legend('Local connections ground-truth','Local-connections inferred', 'Location', 'SouthEast');
%     subplot(3,1,3)
%     Jnew_sb=inference_data_sb(temp).Jnew(2:end,2:end);
%     Jnew_sb(logical(eye(size(Jnew_sb))))=NaN;
%     [err,alph]=finderror_lsq(100,W_sb,Jnew_sb,'full',2);
%     Jnew_sb=alph*Jnew_sb;
%     plot(meancoupling(W_sb));
%     hold on
%     plot(meancoupling(Jnew_sb));
%     hold off
%     legend('Side-bands ground-truth','Side-bands inferred', 'Location', 'SouthEast');
end

%% Distance between mean activity patterns
load('thresholds_unpinned.mat');
pattern_dist=[];
for temp=1:11
    sW=thresholds(temp,1)
    load(sprintf('binnedspikes_pinned/sW %.4f.mat',sW));
    mean1=mean(binnedspikes(:,2:end));
    load(sprintf('binnedspikes_sb/sW %.4f.mat',sW));
    mean2=mean(binnedspikes(:,2:end));
    pattern_dist=[pattern_dist; [sW,norm(mean1-mean2)]];
end
figure
plot(pattern_dist(:,1),pattern_dist(:,2),'-o');
xlabel 'Weight strength \omega'
ylabel 'Distance between means'

%% Plot distance between inferred models
%load inference_data_up_maxdata.mat
%load inference_data_up_sb.mat

%load inference_data_subnetwork.mat

load('W100.mat');
W_lc=W(2:11,2:11);
W_lc(logical(eye(size(W_lc)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W_lc=(W_lc-min(W_lc(:)))./(max(W_lc(:))-min(W_lc(:)))-1; %rescaling W between -1 and 0

load('W_sb.mat');
W_sb=W(2:11,2:11);
W_sb(logical(eye(size(W_sb)))) = NaN; %setting diagonal to NaN before rescaling. Jnew diag is already set to NaN.
W_sb=(W_sb-min(W_sb(:)))./(max(W_sb(:))-min(W_sb(:)))-1; %rescaling W between -1 and 0


model_dists=[];
for ii=1:11
    Jl=inference_data1(ii).Jnew;
    Jl(logical(eye(size(Jl))))=NaN;
    %[~,alph]=finderror_lsq(100,W_lc,Jl,'full',2)
    %Jl=alph*Jl;
    Jl=Jl/abs(min(Jl(:)));
    
    Js=inference_data2(ii).Jnew;    
    Js(logical(eye(size(Js))))=NaN;   
    [~,alph]=finderror_lsq(100,Jl,Js,'full',2)
    Js=alph*Js;
    
    figure
    subplot(1,2,1)
    imagesc(Jl); axis square; colorbar; 
    
    subplot(1,2,2)
    imagesc(Js); axis square; colorbar;
    
    %model_dists=[model_dists; [inference_data_full(lc_index(ii)).sW/2, err_ll, err_sl, err_sl-err_ll, err_ls, err_ss, err_ss-err_ls, err_J]];
    model_dists=[model_dists; [inference_data1(ii).sW, error_lsq(1,Jl,Js,'full',2)]];
end
figure;
plot(model_dists(:,1),model_dists(:,2),'-o');
xlabel 'Weight strength \omega'
ylabel 'Distance between inferred models'