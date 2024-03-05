clc; clear;
close all;

load('fe_model.mat')

% a.
yShim = 1;

dirNodes = [10735 13699 16620 19625 22511 4747];
centerNode = 1305;
centerDofs = centerNode*6-5:centerNode*6;

ndof = size(M, 1);

Fvector = zeros(ndof, 1);

[DofN, DofD, ndirNodes] = DofCalculator(dirNodes,ndof);

uCenteredMemory = zeros(6);

for j = 1:6
    uD = zeros(ndirNodes*6, 1);
    uD((j-1)*6+2, 1) = yShim;
    uCenteredMemory(:, j) = SolveSystem(K, DofD, DofN, uD, Fvector, ndof, centerDofs);
end

% b.
b = [0 
    0
    0
    500e-6
    -200e-6
    0];
A = uCenteredMemory;

X = A\b;
