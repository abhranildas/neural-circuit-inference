set(0,'DefaultFigureWindowStyle','docked');
sublength=10;
startcol=1;
sW_statdist=[];
sW_ents=[];
load('thresholds_unpinned.mat');
subpop=randsample(100,sublength)';
datapart=1;
dists=struct;
for temp=1:11  
    sW=thresholds(temp,1)%[.001 .005 .01 .015 .02 .025 .03 .035 .04 .045 .05]
    %ii=numel(dists)+1;
    dists(temp).sW=sW;
    load(sprintf('binsize_50_up_1e8/sW %.4f.mat',sW));
    %binnedspikes=logical(binnedspikes);
    %load(sprintf('binnedspikes_pinned/sW %.4f.mat',sW));
    %load(sprintf('binnedspikes_GLM_exp/sW %.4f.mat',sW));
    %For unpinned:    
    %SubStates=logical(binnedspikes(1:round(size(binnedspikes,1)*datapart),startcol:startcol+sublength-1));
    
    counts=zeros(2^sublength,1);
    
    %Concatenate:
%     SubStates=zeros(100*size(binnedspikes,1),sublength,'logical');
    for startcol=1:100
        startcol        
        %SubStates=[SubStates; logical(binnedspikes(:,startcol:startcol+sublength-1))];
        startidx=(startcol-1)*size(binnedspikes,1)+1;
        endidx=(startcol)*size(binnedspikes,1);
        colidx=mod(startcol:startcol+sublength-1,100);
        colidx(colidx==0)=100;
        dec_states=bi2de(binnedspikes(:,colidx));
        counts=counts+histcounts(dec_states,0:2^sublength)';
        %SubStates(startidx:endidx,:)=binnedspikes(:,colidx);    
    end
    
    clear binnedspikes

    %For pinned:
    %SubStates=logical(binnedspikes(:,47:53));
    
    %For random sample:
    %SubStates=logical(binnedspikes(:,subpop));
    
%     SubStates=sortrows(SubStates);
%     S = [1;any(diff(SubStates),2)];
%     [L,S] = regexp(sprintf('%i',S'),'1(0)+','start','end');
%     UniqueSubStates = SubStates(S,:); % Repeated Rows.
%     counts = (S-L+1)'; % How often each repeated row appears.
    
    %[UniqueSubStates, ~, idx]=unique(SubStates,'rows');
    %counts=histc(idx,1:size(UniqueSubStates,1));
    
%     counts_states=sortrows([counts,UniqueSubStates],-1);
%     counts=counts_states(:,1);
    p=counts/sum(counts);
    dists(temp).p=p;
    dists(temp).h=shannon_entropy(p);
    %ent=shannon_entropy(counts);
%     UniqueSubStates=counts_states(:,2:end);

    load(sprintf('binsize_50_up_sb_1e8/sW %.4f.mat',sW));
    %load(sprintf('binnedspikes_pinned_2/sW %.4f.mat',sW));
    %load(sprintf('binnedspikes_GLM_exp_sb/sW %.4f.mat',sW));
    %For unpinned:
    %SubStates_sb=logical(binnedspikes(1:round(size(binnedspikes,1)*datapart),startcol:startcol+sublength-1));
    
    counts_sb=zeros(2^sublength,1);
    %Concatenate:
%     SubStates_sb=logical(zeros(100*size(binnedspikes,1),sublength));
    for startcol=1:100
        startcol
        %SubStates=[SubStates; logical(binnedspikes(:,startcol:startcol+sublength-1))];
        startidx=(startcol-1)*size(binnedspikes,1)+1;
        endidx=(startcol)*size(binnedspikes,1);
        colidx=mod(startcol:startcol+sublength-1,100);
        colidx(colidx==0)=100;
        dec_states=bi2de(binnedspikes(:,colidx));
        counts_sb=counts_sb+histcounts(dec_states,0:2^sublength)';
%         SubStates_sb(startidx:endidx,:)=binnedspikes(:,colidx);    
    end
    
    clear binnedspikes

    %For pinned:
    %SubStates_sb=logical(binnedspikes(:,47:53));
    
    %For random sample:
    %SubStates_sb=logical(binnedspikes(:,subpop));
    
%     SubStates_sb=sortrows(SubStates_sb);
%     S = [1;any(diff(SubStates_sb),2)];
%     [L,S] = regexp(sprintf('%i',S'),'1(0)+','start','end');
%     UniqueSubStates_sb = SubStates_sb(S,:); % Repeated Rows.
%     counts_sb = (S-L+1)'; % How often each repeated row appears.
    
    %[UniqueSubStates_sb, ~, idx]=unique(SubStates_sb,'rows');
    %counts_sb=histc(idx,1:size(UniqueSubStates_sb,1));
    
%     counts_states_sb=sortrows([counts_sb,UniqueSubStates_sb],-1);
%     counts_sb=counts_states_sb(:,1);
    p_sb=counts_sb/sum(counts_sb);
    dists(temp).p_sb=p_sb;
    dists(temp).h_sb=shannon_entropy(p_sb);
    %ent_sb=shannon_entropy(counts_sb);
%     UniqueSubStates_sb=counts_states_sb(:,2:end);
    
%     SubStates_pool=[SubStates;SubStates_sb];    
%     [UniqueSubStates_pool, ~, idx]=unique(SubStates_pool,'rows');
%     counts_pool=histc(idx,1:size(UniqueSubStates_pool,1));
    
    %counts_states_sb=sortrows([counts_sb,UniqueSubStates_sb],-1);
    %counts_sb=counts_states_sb(:,1);
    
%     p_pool=counts_pool/sum(counts_pool);
%     dists(ii).h_pool=shannon_entropy(p_pool);
    
    %ent_pool=shannon_entropy(counts_sb);
    %UniqueSubStates_sb=counts_states_sb(:,2:end);

    %sW_ents=[sW_ents;[sW,shannon_entropy(counts),shannon_entropy(counts_sb),shannon_entropy(counts_pool)]];
%     p_cross=zeros(size(p));
%     for i=1:numel(p_cross)
%         %i
%         [~,indx]=ismember(UniqueSubStates(i,:),UniqueSubStates_sb,'rows');
%         %indx=find(ismember(UniqueSubStates(i,:),UniqueSubStates_sb),1)
%         if indx
%             p_cross(i)=p_sb(indx);
%         end
%     end
%     sum(p_cross==0)
    %dists(temp).p_cross=p_cross;
    
%     figure
%     plot(p_cross);
%     hold on
%     plot(p);
%     hold off
%     
%     statdist=sum(abs(p-p_cross))+1-sum(p_cross);
%     dists(temp).statdist=statdist;
    p_nz=(p~=0); %(p&p_sb); % p non-zero
    KLdiv=sum(p(p_nz).*log2(p(p_nz)./p_sb(p_nz)));
    LL=dot(p(p_nz),log(p_sb(p_nz)))*sum(counts);
%     JSdiv=(sum(p.*log2(2*p./(p+p_cross)))+sum(p_cross.*log2(2*p_cross./(p+p_cross)))+1-sum(p_cross))/2;
%     dists(temp).JSdiv=JSdiv;
    dists(temp).KLdiv=KLdiv;
    dists(temp).LL=LL;
%     sW_statdist=[sW_statdist;[sW,stat_dist]];
% 
%     figure
%     plot(p_cross)
%     hold on
%     plot(p)
%     hold off
%     legend('Model with sidebands','Model with local connections');
%     xlabel 'States (ranked by distribution of local connections model)'
%     ylabel 'Relative frequency of state'
%     set(gca, 'yscale', 'log');
%     title(sW)
%     title(sprintf('w=%.3f, Statistical distance=%f',[sW,stat_dist]));
end


figure
plot([dists.sW], [dists.KLdiv],'-o');
xlim([0 .025]);
xlabel 'Weight strength \omega'
% ylabel 'Statistical distance between the two distributions'

%Check how many times a unique substate occurs:
%sum(ismember(SubStates,UniqueSubStates(1,:),'rows')')

%% Plot distance between covariance matrices of data
load('thresholds_unpinned.mat');
errlist=[];
for temp=1:11
    sW=thresholds(temp,1)
    load(sprintf('binnedspikes_pinned/sW %.4f.mat',sW));
    cov1=cov(binnedspikes(:,2:end));
    cov1(logical(eye(size(cov1))))=NaN;
    load(sprintf('binnedspikes_sb/sW %.4f.mat',sW));
    cov2=cov(binnedspikes(:,2:end));
    cov2(logical(eye(size(cov2))))=NaN;
    [err,alph]=finderror_lsq(100,cov1,cov2,'full',2);
    cov2=alph*cov2;
    figure
    subplot(1,2,1)
    imagesc(cov1); axis square; colorbar
    subplot(1,2,2)
    imagesc(cov2); axis square; colorbar
    errlist=[errlist;[sW,err]];
end
figure
plot(errlist(:,1),errlist(:,2),'-o');