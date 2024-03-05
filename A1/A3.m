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
u_Modes = zeros(ndof,5);
u_Modes(DofN,:) = MODES;
modesMeta = zeros(ndof/6,6,5);
for j = 1:5
    i = 1:6:ndof;
    modesMeta(:, 1,j) = u_Modes(i,j);
    i = 2:6:ndof;
    modesMeta(:, 2,j) = u_Modes(i,j);
    i = 3:6:ndof;
    modesMeta(:, 3,j) = u_Modes(i,j);
    i = 4:6:ndof;
    modesMeta(:, 4,j) = u_Modes(i,j);
    i = 5:6:ndof;
    modesMeta(:, 5,j) = u_Modes(i,j);
    i = 6:6:ndof;
    modesMeta(:, 6,j) = u_Modes(i,j);
end
fillhdf('template.h5','A3_1_1.h5',modesMeta(:,:,1));
fillhdf('template.h5','A3_2_1.h5',modesMeta(:,:,2));
fillhdf('template.h5','A3_3_1.h5',modesMeta(:,:,3));
fillhdf('template.h5','A3_4_1.h5',modesMeta(:,:,4));
fillhdf('template.h5','A3_5_1.h5',modesMeta(:,:,5));
%% b. Unconstrained

K = (K+K')/2;
M = (M+M')/2;

neig = 20;

[MODES_UC, EIGENVAL_UC] = eigs(K,M,neig,'sm') ; 
EIGENVAL_UC = diag(EIGENVAL_UC) ; 
FREQ_UC = sqrt(EIGENVAL_UC)/(2*pi);  

[FREQ_UC,imodes] = sort(FREQ_UC) ;
MODES_UC= MODES_UC(:,imodes);
u_Modes_UC = zeros(ndof,10);
h = 1:1:10;
u_Modes_UC(DofN,h) = MODES_UC(:,h);
modesMeta_UC = zeros(ndof/6,6,10);
for j = 1:10
    i = 1:6:ndof;
    modesMeta_UC(:, 1,j) = u_Modes_UC(i,j);
    i = 2:6:ndof;
    modesMeta_UC(:, 2,j) = u_Modes_UC(i,j);
    i = 3:6:ndof;
    modesMeta_UC(:, 3,j) = u_Modes_UC(i,j);
    i = 4:6:ndof;
    modesMeta_UC(:, 4,j) = u_Modes_UC(i,j);
    i = 5:6:ndof;
    modesMeta_UC(:, 5,j) = u_Modes_UC(i,j);
    i = 6:6:ndof;
    modesMeta_UC(:, 6,j) = u_Modes_UC(i,j);
end
fillhdf('template.h5','A3_1_2.h5',modesMeta(:,:,1));
fillhdf('template.h5','A3_2_2.h5',modesMeta(:,:,2));
fillhdf('template.h5','A3_3_2.h5',modesMeta(:,:,3));
fillhdf('template.h5','A3_4_2.h5',modesMeta(:,:,4));
fillhdf('template.h5','A3_5_2.h5',modesMeta(:,:,5));
fillhdf('template.h5','A3_6_2.h5',modesMeta(:,:,6));
fillhdf('template.h5','A3_7_2.h5',modesMeta(:,:,7));
fillhdf('template.h5','A3_8_2.h5',modesMeta(:,:,8));
fillhdf('template.h5','A3_9_2.h5',modesMeta(:,:,9));
fillhdf('template.h5','A3_10_2.h5',modesMeta(:,:,10));