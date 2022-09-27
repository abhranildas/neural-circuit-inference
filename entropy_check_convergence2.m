for sublength=[3 5 7 10]
    sublength
    figure
    hold on
    for subvolume=10.^(-4:0);
        entlist=[];
        for sW=[.001 .005 .01 .015 .02 .025 .03 .035 .04 .045 .05]
            load(sprintf('binnedspikes100_1e8/sW %.4f.mat',sW));
            binnedspikes=binnedspikes(1:round(size(binnedspikes)*subvolume),:);
            SubStates=logical(binnedspikes(:,50-sublength:50+sublength));
            [UniqueSubStates, ~, idx]=unique(SubStates,'rows');
            counts=histc(idx,1:size(UniqueSubStates,1));
            entlist=[entlist; [sW,shannon_entropy(counts)]];
        end
        plot(entlist(:,1),entlist(:,2),'-o');
    end
    hold off

    xlabel('Weight strength \omega');
    ylabel('Naive entropy');
    title(sprintf('Network substate length = %d',sublength));
end

legend('Data fraction = 10^{-4}','Data fraction = 10^{-3}','Data fraction = 10^{-2}','Data fraction = 10^{-1}','Data fraction = 10^{0}');