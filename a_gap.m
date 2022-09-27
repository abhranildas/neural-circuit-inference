function n=a_gap(a,basis,base_w,L)
    a_basis=basis*base_w;
    a_basis=a_basis(1:L);
    n=norm(a'-a_basis);