clc; clear;
close all;

load('fe_model.mat')
load('ResultsA1.mat')

% 1. Gravity effects for a given axis

% a.
g = 9.81*1000;

dirNodes = [10735 13699 16620 19625 22511 4747];
centerNode = 1305;
centerDofs = centerNode*6+1:centerNode*6+6;

ndof = size(M, 1);

Fvector = zeros(ndof, 1);
accVector = Fvector;

yDof = 2;
yShim = 0.001;

i = yDof;

while i < ndof
    accVector(i, 1) = g;
    i = i+6;
end

Fvector = M*accVector;

[DofN, DofD, ndirNodes] = DofCalculator(dirNodes,ndof);

% DofBodyRotated = zeros(DofN*2/6,1);

j = 4:6:size(DofN, 1);
DofBodyRotatedX = DofN(j, 1); % FIX
rotX = zeros(size(DofBodyRotatedX, 1), 1);
rotX(:, 1) = 0.05;
DofN(j) = [];

j = 4:5:size(DofN, 1);
DofBodyRotatedY = DofN(j, 1); % FIX
rotY = zeros(size(DofBodyRotatedY, 1), 1);
rotY(:, 1) = -0.02;
DofN(j) = [];

j = 2:6:size(DofD, 1);
DofBodyFreeSupport = DofD(j, 1); % LLIURE

DofD(j) = []; % FIX SUPORTS
dispSupport = zeros(size(DofD,1), 1);

gravityFN = zeros(size(DofN, 1), 1);
for j = 2:6:size(DofN,1)
    MassY = M(DofN(j),DofN(j));
    gravityFN(j) = MassY*g;
end

j = 2:6:size(rf, 1);
FYSupport = zeros(size(rf, 1)/6, 1);
FYSupport(:, 1) = rf(j);
DofNGlobal = [DofN; DofBodyFreeSupport];
FNGlobal = [gravityFN; FYSupport];
DofDGlobal = [DofD; DofBodyRotatedX; DofBodyRotatedY];
uDGlobal = [dispSupport; rotX; rotY];

% uD = zeros(ndirNodes*6, 1);
% i = yDof;
% while i < size(DofD, 1)
%     uD(i) = yShim;
%     i = i+6;
% end


KDD = K(DofDGlobal, DofDGlobal);
KNN = K(DofNGlobal, DofNGlobal);
KDN = K(DofDGlobal, DofNGlobal);
KND = K(DofNGlobal, DofDGlobal);
% FN = Fvector(DofNGlobal);

uNGlobal = KNN\(FNGlobal-KND*uDGlobal);

u = zeros(ndof, 1);
u(DofNGlobal) = uNGlobal;
u(DofDGlobal) = uDGlobal;

% uCentered = u(centerDofs);
% FD = KDD*uD+KDN*uN;
% 
% FextD = Fvector(DofD);
% rf = FD - FextD;
