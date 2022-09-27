function logp=ising_likelihood(binnedspikes,J)
    s=size(binnedspikes,1);
    Z=sum(exp(dot(binnedspikes*J,binnedspikes,2)));
    logp=sum(dot(binnedspikes*J,binnedspikes,2))-s*log(Z);
end