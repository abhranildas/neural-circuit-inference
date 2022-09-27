NSB Entropy Estimation
======================

Christian B. Mendl, (c) 2009 - 2011
(http://christian.mendl.net)

This is a compact Matlab implementation of the algorithm described in the reference "Entropy and Inference, Revisited".

Usage example:

s = s1nsb([4 2 3 0 2 4 0 0 2])

calculates the NSB entropy estimate for the experimentally observed counts n_i = (4 2 3 0 2 4 0 0 2).


ds = ds2nsb([4 2 3 0 2 4 0 0 2])

calculates the corresponding variance.


References:
- Ilya Nemenman, Fariel Shafee, and William Bialek: "Entropy and Inference, Revisited" In T. G. Dietterich, S. Becker, and Z. Ghahramani, editors, Advances in Neural Information Processing Systems 14, Cambridge, MA (2002). MIT Press. [http://arxiv.org/abs/physics/0108025]
- Ilya Nemenman: "Inference of entropies of discrete random variables with unknown cardinalities" (2002) [http://arxiv.org/abs/physics/0207009]
- Ilya Nemenman, William Bialek, and Rob de Ruyter van Steveninck: "Entropy and information in neural spike trains: Progress on the sampling problem" Physical Review E 69, 056111 (2004)
- C++ and Matlab implementation by Ilya Nemenman can be found at http://nsb-entropy.sourceforge.net/
