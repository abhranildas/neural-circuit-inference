function h=shannon_entropy(counts)
    p=counts/sum(counts);        
    h=sum(-(p(p>0).*(log2(p(p>0)))));
end