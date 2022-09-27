addpath(genpath('nsb_entropy'));
dist1=normrnd(-100,2,1,100000);
dist2=normrnd(100,2,1,100000);

[counts1, edges1]=histcounts(dist1,100);
p1=counts1/sum(counts1);        
sum(-(p1(p1>0).*(log2(p1(p1>0)))));
diff_entropy(counts1, edges1(2)-edges1(1));
s1nsb(counts1)

[counts2, edges2]=histcounts(dist2,100);
p2=counts2/sum(counts2);        
sum(-(p2(p2>0).*(log2(p2(p2>0)))));
diff_entropy(counts2, edges2(2)-edges2(1));
s1nsb(counts2)

[counts, edges]=histcounts([dist1,dist2],200);
p=counts/sum(counts);        
sum(-(p(p>0).*(log2(p(p>0)))));
diff_entropy(counts, edges(2)-edges(1));
s1nsb(counts)%+log2(600)

%% NSB and Shannon entropies as a function of binsize
dist=normrnd(0,1,1,1e3);
bw_ent=[];
for bincount=10.^(1:5)
    [counts,edges]=histcounts(dist,bincount);
    binwidth=edges(2)-edges(1);
%     figure
%     plot(counts)
    bw_ent=[bw_ent; [binwidth, shannon_entropy(counts),s1nsb(counts)]];
end
figure
plot(log(bw_ent(:,1)),bw_ent(:,2),'o');
hold on
plot(log(bw_ent(:,1)),bw_ent(:,3),'o');
refline(-1,log(2*pi*exp(1))/2);
hold off
xlabel('log_2 \Deltax');
ylabel('H_{Shannon}');
figure
plot(log(bw_ent(:,1)),bw_ent(:,2)+log(bw_ent(:,1)),'-o');
hold on
plot(log(bw_ent(:,1)),bw_ent(:,3)+log(bw_ent(:,1)),'-o');
hold off

%% NSB and Shannon entropies as a function of sample size from a Gaussian distribution
[~,edges]=histcounts(normrnd(0,1,1,1e6),1e3); %to fix the bin edges in addition to the number.
binsize=edges(2)-edges(1);
nsamp_ent=[];
for nsamp=round(10.^(1:.2:5))
    shannon_list=[]; nsb_list=[];
    for i=1:100
        dist=normrnd(0,1,1,nsamp);
        counts=histcounts(dist,edges);
        shannon_list=[shannon_list; shannon_entropy(counts)];
        nsb_list=[nsb_list; s1nsb(counts)];
    end
    nsamp_ent=[nsamp_ent; [nsamp, nanmean(shannon_list), nanstd(shannon_list), nanmean(nsb_list), nanstd(nsb_list)]];
end

figure
errorbar(nsamp_ent(:,1),nsamp_ent(:,2),nsamp_ent(:,3),'-o');
hold on
errorbar(nsamp_ent(:,1),nsamp_ent(:,4),nsamp_ent(:,5),'-o');
%refline(0,log(2*pi*exp(1))/2-log(binsize));

legend('Naive entropy','NSB entropy','ln(2\pie\sigma^2)/2-ln(binwidth)')
set(gca, 'xscale','log');
xlabel('Sample size');
ylabel('Entropy (nats)');
title('Entropy of sample from Gaussian distribution (1e3 bins)');

plot([1e3 1e3], ylim, '-');
hold off

%% NSB and Shannon entropies as a function of sample size from a uniform distribution
[~,edges]=histcounts(rand(1,1e6),1e3); %to fix the bin edges in addition to the number.
binsize=edges(2)-edges(1);
nsamp_ent=[];
for nsamp=round(10.^(1:.2:5))
    shannon_list=[]; nsb_list=[];
    for i=1:100
        dist=rand(1,nsamp);
        counts=histcounts(dist,edges);
        shannon_list=[shannon_list; shannon_entropy(counts)];
        nsb_list=[nsb_list; s1nsb(counts)];
    end
    nsamp_ent=[nsamp_ent; [nsamp, nanmean(shannon_list), nanstd(shannon_list), nanmean(nsb_list), nanstd(nsb_list)]];
end

figure
errorbar(nsamp_ent(:,1),nsamp_ent(:,2),nsamp_ent(:,3),'-o');
hold on
errorbar(nsamp_ent(:,1),nsamp_ent(:,4),nsamp_ent(:,5),'-o');
%refline(0,log(1e3));
hold off
legend('Naive entropy','NSB entropy','ln(k)')
set(gca, 'xscale','log');
xlabel('Sample size');
ylabel('Entropy (nats)');
title('Entropy of sample from uniform distribution (1e3 bins)');

hold on
plot([1e3 1e3], ylim, '-');
hold off
%% Entropy of a mixture of Gaussians as a function of separation
ent_sep=[];
for mu=0:.5:10
    dist1=normrnd(-mu,1,1,100000);
    dist2=normrnd(mu,1,1,100000);
    [counts, edges]=histcounts([dist1,dist2],1000);
    binsize=edges(2)-edges(1)
    ent_sep=[ent_sep; [mu, shannon_entropy(counts)+log(binsize), s1nsb(counts)+log(binsize)]];
end

%ent_sep(:,2)=ent_sep(:,2)-log(binsize);
%
plot(ent_sep(:,1),ent_sep(:,2)-log(2*pi*exp(1))/2,'o')
hold on
plot(ent_sep(:,1),ent_sep(:,3)-log(2*pi*exp(1))/2,'o')
hold off
refline(0,log(2));
ylim([-.01 .8]);
xlabel('\mu');
ylabel('\DeltaH');
title('Increase in entropy of a mixture of Gaussians as a function of separation');
