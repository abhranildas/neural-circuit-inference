set(0,'DefaultFigureWindowStyle','docked');
load('thresholds_unpinned.mat');
Mega_Unfr_Ent_List=[];
for temp=1
    sW=thresholds(temp,1)
    load(sprintf('binnedspikes_unpinned/sW %.4f.mat',thresholds(temp,1)));
    States=logical(binnedspikes(:,2:end));
    SubLength=round(log2(size(States,1)))
    UnFr_Ent_List=[];
    for StartCol=1:10:size(States,2)
        SubStates=States(:,mod(StartCol-1:StartCol+SubLength-2,size(States,2))+1);
        [UniqueSubStates, ~, idx]=unique(SubStates,'rows');
        %Fraction of substates unique
        UnFr=size(UniqueSubStates,1)/size(SubStates,1);
        %Entropy of substates
        counts=histc(idx,1:size(UniqueSubStates,1));
        %Populate all possible states by 1 and then add actual sample
        counts=counts+1;
        counts=padarray(counts, [2^SubLength-numel(counts), 0], 1, 'post');
        p=counts/sum(counts);        
        %Entropy=-sum(p.*log2(p))
        Entropy=-sum(p.*log(p)/log(2^SubLength))
        UnFr_Ent_List=[UnFr_Ent_List; [UnFr,Entropy]];
    end
    UnFr_Ent_List
    Mean_UnFr_Ent=mean(UnFr_Ent_List);
    Mega_Unfr_Ent_List=[Mega_Unfr_Ent_List;[sW, Mean_UnFr_Ent]];
end

plot(Mega_Unfr_Ent_List(:,1),Mega_Unfr_Ent_List(:,2),'-o');
xlabel('Weight strength \omega');
ylabel('Fraction of substates that are unique');
figure
plot(Mega_Unfr_Ent_List(:,1),Mega_Unfr_Ent_List(:,3),'-o');
xlabel('Weight strength \omega');
ylabel('Entropy of substate distribution');

figure
area(sort(p,'descend'),'FaceColor','r','EdgeColor','r','FaceAlpha',.5,'EdgeAlpha',.5);
xlim([-size(p,1)/10 size(p,1)]);
xlabel('Substates (in descending order of count)');
ylabel('Relative frequency of substate');
title('Weight strength \omega=.001');