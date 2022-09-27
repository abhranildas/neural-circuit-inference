set(0,'DefaultFigureWindowStyle','docked');
load W100.mat
N=100;
%Pick inferred matrix for w=.05 with all data
% load('ising_inference_data_full.mat');
% Jnew=inference_data_full(148).Jnewlist(1:end,1:end);

%Fill in pinned row and column by mirroring.
% for i=1:N
%     mirror_el=mod(2*i-1,N);
%     if mirror_el==0
%         mirror_el=N;
%     end
%     Jnew(i,1)=Jnew(i,mirror_el);
%     Jnew(1,i)=Jnew(mirror_el,i);
% end

%Remove diagonal
%Jnew(logical(eye(size(Jnew))))=NaN;

%Calculate mean coupling
couplings=meancoupling_noshift(Jnew);
%couplings=circshift(couplings,N/2-1,2);

%Chop off positive part
couplings(couplings>0)=0;

%Scale minimum to that of original W: -.0011
couplings=couplings*abs(min(W(:))/min(couplings));

%Create new W by staggering this coupling
Wnew=zeros(N);
for i=1:N    
    Wnew(i,:)=circshift(couplings,[0 i-1]);   
end

%Symmetrize Wnew
Wnew=(Wnew+Wnew')/2;

%Replace diagonal with that of original W

Wnew(logical(eye(size(Wnew))))=diag(W);

W=Wnew;
save W_glm_sb.mat W