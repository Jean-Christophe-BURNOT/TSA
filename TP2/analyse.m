close all;
clc;

pkg load signal;
load sig;;;

figure(1);
clf;

X = s;

N = length(X);
M = round(0.2*N);
NFFT = 2*M;

Nom_fenetre = "hanning";
NOVERLAP = 0.5;             % en pourcentages

%[Gamma, f] = simpleDSPM(X, nd, nf, NFFT);
%[Gamma, f] = moyenneurDSPM(X, N, M, NFFT);
[Gamma, f] = welchDSPM(X, N, Nom_fenetre, M, NOVERLAP, NFFT);

semilogy(f,Gamma);

grid on;
ylim([10, 10e7]);
xlim([0, 0.5]);

%title(sprintf("Graphique pour N=%d, M=%d, et NFFT=%d", N, M, NFFT));
title(sprintf("N=%d, M=%d, et NFFT=%d, Fenetre %s, recouvrement %i%%", N, M, NFFT, Nom_fenetre, NOVERLAP*100));
xlabel("Fréquence réduite f");
ylabel("Amplitude (dB)");
