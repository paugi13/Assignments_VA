clc; clear;
close all;

load('fe_model.mat')

dirNodes = [4747 10735 13699 16620 19625 22511];
ndof = size(M, 1);
centerNode = 1305;
centerDofs = centerNode*6-5:centerNode*6;

[DofN, DofD, ndirNodes] = DofCalculator(dirNodes,ndof);

M_N = M(DofN, DofN);
K_N = K(DofN, DofN);

M_N = (M_N+M_N')/2; 
K_N = (K_N+K_N')/2; 

neig = 5;
[MODES, EIGENVAL] = eigs(K_N,M_N,neig,'sm') ; 
EIGENVAL = diag(EIGENVAL) ; 
FREQ = sqrt(EIGENVAL);  

[FREQ,imodes] = sort(FREQ) ;
phi = MODES(:,imodes); 
% phi = phi';

accVector = zeros(ndof, 1);
accVector(centerDofs(1)) = 9.81*1000;
Fvector = M*accVector;
Fvector(DofD) = [];

fSup = 2000*2*pi;
omega_vector = 0:50:fSup;
x_center_vector = zeros(length(omega_vector), 1);

for i=1:length(omega_vector)
    omega = omega_vector(i);
    
    Q = -(omega^2).*(phi'*M_N*phi) + phi'*K_N*phi;
    F_xi = phi'*Fvector;
    
    m_i_matrix = phi'*M_N*phi;
    omega_i_vector = FREQ;
    damp_ratio = 0.02;
%     b_i_vector = diag([0.02; 0.02; 0.02; 0.02; 0.02]);
    b_i_vector = diag(2*m_i_matrix*omega_i_vector*damp_ratio);
    
    Q = Q + b_i_vector*omega*1i;
    
    xi_i = Q\F_xi;
    
    X_hat = phi*xi_i;
    X_hat_total = zeros(ndof, 1);
    X_hat_total(DofN) = X_hat;
    x_center_vector(i) = X_hat_total(centerDofs(1));
end

Mod_X = abs(x_center_vector);
Angle_X = angle(x_center_vector);

figure 
hold on
plot(omega_vector/(2*pi), Mod_X);
xlabel('Frequency [Hz]')
ylabel('Amplitude [mm]')
grid on
hold off

figure 
hold on
plot(omega_vector/(2*pi), -Angle_X);
xlabel('Frequency [Hz]')
ylabel('Phase [rad]')
grid on
hold off