set(0,'DefaultFigureWindowStyle','docked');
addpath(genpath('nsb_entropy'));
load('thresholds.mat');
%Mega_Unfr_Ent_List=[];
entlist=[];
for sW=.01;%temp=[2 6 8 9 10 12 17 20 21 22 23 25 26 27]
    %sW=thresholds(temp,1);
    load(sprintf('binnedspikes_unpinned/sW %.4f.mat',sW));
    %binnedspikes=binnedspikes(1:2149074,:); %truncate to min length (sb with lowest w)
    
%     binnedspikes0=binnedspikes;
%     load(sprintf('binnedspikes_sb/sW %.3f.mat',sW));
%     binnedspikes=binnedspikes(1:2149074,:); %truncate to min length (sb with lowest w)
%     binnedspikes=[binnedspikes;binnedspikes0];
    
    States=logical(binnedspikes);
    SubLength=15;%round(log2(size(States,1)))
    %UnFr_Ent_List=[];
    for StartCol=1:size(States,2)
        StartCol
        SubStates=States(:,mod(StartCol-1:StartCol+SubLength-2,size(States,2))+1);
        [UniqueSubStates, ~, idx]=unique(SubStates,'rows');
        %Fraction of substates unique
        %UnFr=size(UniqueSubStates,1)/size(SubStates,1);
        %Entropy of substates
        counts=histc(idx,1:size(UniqueSubStates,1));
        %counts=single(counts'); save(sprintf('nsb_entropy/mathematica/pooled/%.3f.mat',sW), '-v7', 'counts');
        %entlist=[entlist; [sW,shannon_entropy(counts)]];
        entlist=[entlist; [StartCol,shannon_entropy(counts)]];
        %Populate all possible states by 1 and then add actual sample
        %counts=counts+1;
        %counts=padarray(counts, [2^SubLength-numel(counts), 0], 1, 'post');
        %p=counts/sum(counts);
        %Entropy=s1nsb(counts)
        %UnFr_Ent_List=[UnFr_Ent_List; [UnFr,Entropy]];
    end
%     UnFr_Ent_List
%     Mean_UnFr_Ent=mean(UnFr_Ent_List);
%     Mega_Unfr_Ent_List=[Mega_Unfr_Ent_List;[sW, Mean_UnFr_Ent]];
end
entlist(:,1)=mod(entlist(:,1)+10,99);
entlist=sortrows(entlist,1);
figure
plot(entlist(:,1),entlist(:,2),'-o');
%xlim([1 99]);
title('Entropy of 21-node subpopulation states (\omega=.001)');
xlabel('Index of middle node');
ylabel('Naive entropy');
%counts=single(counts'); save('nsb_entropy/mathematica/test.mat', '-v7', 'counts');

% plot(Mega_Unfr_Ent_List(:,1),Mega_Unfr_Ent_List(:,2),'-o');
% xlabel('Weight strength \omega');
% ylabel('Fraction of substates that are unique');
% figure
% plot(Mega_Unfr_Ent_List(:,1),Mega_Unfr_Ent_List(:,3),'-o');
% xlabel('Weight strength \omega');
% ylabel('Entropy of substate distribution');
% 
% figure
% area(sort(p,'descend'),'FaceColor','r','EdgeColor','r','FaceAlpha',.5,'EdgeAlpha',.5);
% xlim([-size(p,1)/10 size(p,1)]);
% xlabel('Substates (in descending order of count)');
% ylabel('Relative frequency of substate');
% title('Weight strength \omega=.001');