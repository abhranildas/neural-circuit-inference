function p=ising_prob(x,J,h)
N=numel(x);
H=0;
for i=1:N
    for j=[1:i-1, i+1:N] %skip j=i
        H=H+J(i,j)*x(i)*x(j);
    end
    H=H+h(i)*x(i);
end
p=exp(H);