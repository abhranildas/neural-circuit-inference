function binned=bin(spikes,binsize,binarize,maxspikes)
    newlength=size(spikes,1)-rem(size(spikes,1),binsize);
    binned=zeros(newlength/binsize,size(spikes,2));
    spikecount=0;
    for i=1:size(binned,1)
        binned(i,:)= sum(spikes(binsize*(i-1)+1:binsize*i,:),1);
        if binarize
            binned(i,:)=binned(i,:)~=0;
        end        
        if maxspikes
            spikecount=spikecount+sum(binned(i,:));
            if spikecount>maxspikes
                binned(i+1:end,:)=[];
                break
            end
        end
    end
end