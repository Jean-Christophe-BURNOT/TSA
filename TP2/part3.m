close all
clear variables;
clc;

pkg load signal

%Code de la 3em partie du TP2 de TSA

figure(1);
clf;

N = 20e3;
M = round(819/4096*N);
NFFT = 2*M;

Nom_fenetre = "hanning";
NOVERLAP = 0.5;             % en pourcentages

X=genbrfil();
%[Gth,Gbiais,fth] = sptheo(20e3,"simple");
%[Gth,Gbiais,fth] = sptheo(20e3,"moyenne");
[Gth,Gbiais,fth] = sptheo(20e3,"welch",Nom_fenetre);


%[Gamma, f] = simpleDSPM(X, nd, nf, NFFT);
%[Gamma, f] = moyenneurDSPM(X, N, M, NFFT);
[Gamma, f] = welchDSPM(X, N, Nom_fenetre, M, NOVERLAP, NFFT);

plot(f,10*log10(Gamma),  fth, Gth,  fth, Gbiais);

grid on;

xlim([0, 0.5]);
ylim([-180, 10]);

legend("Expérimental","Th biaisé","Th idéal");
%title(sprintf("Graphique pour N=%d, M=%d, et NFFT=%d", N, M, NFFT));
title(sprintf("N=%d, M=%d, et NFFT=%d, Fenetre %s, recouvrement %i%%", N, M, NFFT, Nom_fenetre, NOVERLAP*100));
xlabel("Fréquence réduite f");
ylabel("Amplitude (dB)");
