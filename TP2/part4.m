close all;
clear variables;
clc;
%% Pour charger la bibliothèque signal
pkg load signal;

%% Charge le vecteur S
load sig

%% Première fonction
N = 100000;
NFFT = 2^17;
figure()
%appel de la fonction simple
[Gamma1,VecteurFreq1, N] = simpleDSPM(s,1,N, NFFT);
semilogy(VecteurFreq1,Gamma1)
axis([0 0.5 10 10^7])
figure()

%% Deuxième fonction
N = 100000;
M = 5000;
NFFT = 2^17;
[Gamma2, VecteurFreq2] = moyenneurDSPM(s, N, M, NFFT);
semilogy(VecteurFreq2,Gamma2)
axis([0 0.5 10 10^7])

%% Troisième fonction
N = 100000;
M = 5000;
NOVERLAP = 0.5;
NFFT = 2^17;
[Gamma3,VecteurFreq3] = welchDSPM(s,N,'hanning',M,NOVERLAP,NFFT);
figure();
semilogy(VecteurFreq3,Gamma3)
grid on;
axis([0 0.5 10 10^7])
