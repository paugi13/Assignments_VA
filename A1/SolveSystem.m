function [uCentered, u] = SolveSystem(K, DofD, DofN, uD, Fvector, ndof, centerDofs)

KDD = K(DofD, DofD);
KNN = K(DofN, DofN);
KDN = K(DofD, DofN);
KND = K(DofN, DofD);
FN = Fvector(DofN);

uN = KNN\(FN-KND*uD);

FD = KDD*uD+KDN*uN;

FextD = Fvector(DofD);
rf = FD - FextD;


u = zeros(ndof, 1);
u(DofN) = uN;
u(DofD) = uD;

uCentered = u(centerDofs);
end