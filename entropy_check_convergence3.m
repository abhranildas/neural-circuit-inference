set(0,'DefaultFigureWindowStyle','docked');
load('thresholds_unpinned.mat');
%entlist_data=thresholds(1,1);
entlist_data=thresholds(1:end-1,1);
for sublength=10
    sublength    
    figure
    hold on
    for subvolume=10.^(0:-.5:-4)
        subvolume
        entlist=[];
        for temp=1:11
            sW=thresholds(temp,1)
            load(sprintf('binnedspikes_up_sb/sW %.4f.mat',sW));
            binnedspikes=logical(binnedspikes(1:round(size(binnedspikes)*subvolume),:));  
            %Concatenate:
            SubStates_dec=zeros(100*size(binnedspikes,1),1);
            for startcol=1:100
                %startcol
                startidx=(startcol-1)*size(binnedspikes,1)+1;
                endidx=(startcol)*size(binnedspikes,1);
                colidx=mod(startcol:startcol+sublength-1,100);
                colidx(colidx==0)=100;
                SubStates_dec(startidx:endidx)=bi2de(binnedspikes(:,colidx));    
            end
            counts=hist(SubStates_dec,unique(SubStates_dec));
            
            %SubStates_dec=sortrows(SubStates_dec);
            %S = [1;any(diff(SubStates_dec),2)];
            %[L,S] = regexp(sprintf('%i',S'),'1(0)+','start','end');
            %UniqueSubStates = SubStates(S,:); % Repeated Rows.
            %counts = (S-L+1)'; % How often each repeated row appears.
            
            entlist=[entlist; [sW,shannon_entropy(counts)]];
        end
        plot(entlist(:,1),entlist(:,2),'-o');
        entlist_data=[entlist_data, entlist(:,2)];
        save entropy_convergence_sb_10.mat entlist_data
    end
    hold off

    xlabel('Weight strength \omega');
    ylabel(sprintf('entropy of %d-node substates (bits)',sublength));
    %title(sprintf('Network substate length = %d',sublength));
    legend('10^{0}','10^{-1}','10^{-2}','10^{-3}','10^{-4}');
    set(gca,'FontSize',13)
end

