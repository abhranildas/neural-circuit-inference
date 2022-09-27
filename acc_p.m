function a=acc_p(x,i,J,h)
N=numel(x);
x(x==0)=-1;
a=exp(-2*x(i)*(sum(J(i,:).*x)+h(i)));