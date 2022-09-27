function [Lattice] = generate_lattice(V1, V2, Center, Min_bnd, Max_bnd)
M = max(Max_bnd(1)-Center(1),Max_bnd(2)-Center(2));
m = min(norm(V1,2),norm(V2,2));
num_vectors = 2*ceil(M/m)+1;

[a,b] = meshgrid(-num_vectors:num_vectors, -num_vectors:num_vectors);
a = reshape(a,(2*num_vectors+1)^2,1);
b = reshape(b,(2*num_vectors+1)^2,1);
Lattice(:,1) = a*V1(1) + b*V2(1) + Center(1);
Lattice(:,2) = a*V1(2) + b*V2(2) + Center(2);

valid_ind1 = all([Lattice(:,1)>Min_bnd(1) Lattice(:,1)<Max_bnd(1)],2);
valid_ind2 = all([Lattice(:,2)>Min_bnd(2) Lattice(:,2)<Max_bnd(2)],2);
valid_ind = all([valid_ind1,valid_ind2],2);

Lattice = Lattice(valid_ind,:);
