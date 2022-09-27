function R=spike_ccg(spikes,max_lag)

means=mean(spikes);
sds=std(spikes);
N=size(spikes,2);

R=nan(100,100,2*max_lag+1,'single');
for i=1:N
    for j=i+1:N
        %[i j]
        %tic
        x=gpuArray(spikes(:,i));
        y=gpuArray(spikes(:,j));
        r=gather(xcorr(x,y,max_lag,'unbiased'));
        %r=xcorr(spikes(:,i),spikes(:,j),max_lag,'unbiased');
        R(i,j,:)=(r-means(i)*means(j))/(sds(i)*sds(j));
        %toc
    end
end

% anti-symmetrize:
for i=1:N
    for j=1:i-1
        R(i,j,:)=flip(R(j,i,:));
    end
end