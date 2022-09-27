
A= 0.2*[[-0.5,500];[0,-1]];

niter=100; 
x=zeros(2,niter);
x(:,1) = [1;1];  


[v,d] = eigs(A) 

pause

for i=2:niter
    
    x(:,i) = x(:,i-1)+A*x(:,i-1);
    
end

plot((x.^2)')


