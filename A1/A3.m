clc; clear;
close all;

load('fe_model.mat')

neig = 5;


[MODES, EIGENVAL] = eigs(K,M,neig,'sm') ; 
EIGENVAL = diag(EIGENVAL) ; 
FREQ = sqrt(EIGENVAL) ;  

[FREQ,imodes] = sort(FREQ) ;
MODES= MODES(:,imodes); 