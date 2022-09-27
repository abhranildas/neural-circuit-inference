function H=diff_entropy(counts,binwidth)
p=counts/sum(counts);
f=p/binwidth;
H=-sum(f(f>0).*log(f(f>0)))*binwidth;