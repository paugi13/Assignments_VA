clc; clear;
close all;

load('fe_model.mat')

% 1. Gravity effects for a given axis

% a.
g = 9.81*1000;

dirNodes = [4747 10735 13699 16620 19625 22511];
centerNode = 1305;
centerDofs = centerNode*6-5:centerNode*6;

ndof = size(M, 1);

Fvector = zeros(ndof, 1);
accVector = Fvector;

selectedDof = 3;

i = selectedDof;

while i < ndof
    accVector(i, 1) = g;
    i = i+6;
end

Fvector = M*accVector;

[DofN, DofD, ndirNodes] = DofCalculator(dirNodes,ndof);

uD = zeros(ndirNodes*6, 1);

KDD = K(DofD, DofD);
KNN = K(DofN, DofN);
KDN = K(DofD, DofN);
KND = K(DofN, DofD);
FN = Fvector(DofN);

uN = KNN\(FN-KND*uD);

u = zeros(ndof, 1);
u(DofN) = uN;
u(DofD) = uD;

uCentered = u(centerDofs);
FD = KDD*uD+KDN*uN;

FextD = Fvector(DofD);
rf = FD - FextD;

% c. Total mass

i = selectedDof;
mTotal = 0;
while i < ndof
%     m1 = M(i, i);
    m2 = M(i, i);
%     m3 = M(i+3, i+3);
    mTotal = mTotal  + m2 ;
    i = i+6;
end

weight = mTotal*g;
i = selectedDof;
rWeight = 0;

while i < size(rf, 1)
    rWeight = rWeight + rf(i);
    i = i + 6;
end

uMeta = zeros(ndof/6, 6);
j = 1:6:ndof;
uMeta(:, 1) = u(j);
j = 2:6:ndof;
uMeta(:, 2) = u(j);
j = 3:6:ndof;
uMeta(:, 3) = u(j);
j = 4:6:ndof;
uMeta(:, 4) = u(j);
j = 5:6:ndof;
uMeta(:, 5) = u(j);
j = 6:6:ndof;
uMeta(:, 6) = u(j);

save('ResultsA1', 'rf');

%     subK = K(dirNodes(i)*6+1:dirNodes(i)*6+6, dirNodes(i)*6+1:dirNodes(i)*6+6);
%     KDD(j:j+5, j:j+5) = KDD;




