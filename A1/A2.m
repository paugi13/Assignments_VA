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
uMeta = zeros(ndof/6, 6,6);
u = zeros(ndof,6);

for j = 1:6
    uD = zeros(ndirNodes*6, 1);
    uD((j-1)*6+2, 1) = yShim;
    [uCenteredMemory(:, j), u(:,j)] = SolveSystem(K, DofD, DofN, uD, Fvector, ndof, centerDofs);
    i = 1:6:ndof;
    uMeta(:, 1,j) = u(i,j);
    i = 2:6:ndof;
    uMeta(:, 2,j) = u(i,j);
    i = 3:6:ndof;
    uMeta(:, 3,j) = u(i,j);
    i = 4:6:ndof;
    uMeta(:, 4,j) = u(i,j);
    i = 5:6:ndof;
    uMeta(:, 5,j) = u(i,j);
    i = 6:6:ndof;
    uMeta(:, 6,j) = u(i,j);
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

fillhdf('template.h5','A2_1.h5',uMeta(:,:,1));
fillhdf('template.h5','A2_2.h5',uMeta(:,:,2));
fillhdf('template.h5','A2_3.h5',uMeta(:,:,3));
fillhdf('template.h5','A2_4.h5',uMeta(:,:,4));
fillhdf('template.h5','A2_5.h5',uMeta(:,:,5));
fillhdf('template.h5','A2_6.h5',uMeta(:,:,6));
