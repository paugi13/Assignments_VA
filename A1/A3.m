clc; clear;
close all;

load('fe_model.mat')

neig = 5;

%% a. HARD-MOUNTED

dirNodes = [4747 10735 13699 16620 19625 22511];
ndof = size(M, 1);

[DofN, DofD, ndirNodes] = DofCalculator(dirNodes,ndof);

M_N = M(DofN, DofN);
K_N = K(DofN, DofN);

M_N = (M_N+M_N')/2; 
K_N = (K_N+K_N')/2; 

[MODES, EIGENVAL] = eigs(K_N,M_N,neig,'sm') ; 
EIGENVAL = diag(EIGENVAL) ; 
FREQ = sqrt(EIGENVAL)/(2*pi);  

[FREQ,imodes] = sort(FREQ) ;
MODES= MODES(:,imodes); 

%% b. Unconstrained

K = (K+K')/2;
M = (M+M')/2;

neig = 20;

[MODES_UC, EIGENVAL_UC] = eigs(K,M,neig,'sm') ; 
EIGENVAL_UC = diag(EIGENVAL_UC) ; 
FREQ_UC = sqrt(EIGENVAL_UC)/(2*pi);  

[FREQ_UC,imodes] = sort(FREQ_UC) ;
MODES_UC= MODES_UC(:,imodes); 