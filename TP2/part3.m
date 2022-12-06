close all
clear variables;
clc;

pkg load signal

%Code de la 3em partie du TP2 de TSA

figure(1);
clf;

N = 4096;
M = N/2;
NFFT = 2*M;

Nom_fenetre = "rectwin";
NOVERLAP = 0;             % en pourcentages

X=genbrfil();
[Gth,Gbiais,fth] = sptheo(20e3,"welch", Nom_fenetre);

[Gamma, f] = welchDSPM(X, N, Nom_fenetre, M, NOVERLAP, NFFT);

plot(f,10*log10(Gamma),  fth, Gth,  fth, Gbiais);

xlim([0, 0.5]);
ylim([-60, 10]);

legend("Expérimental","Th biaisé","Th idéal");
title(["Graphique avec ", sprintf("N=%d, M=%d, et NFFT=%d", N, M, NFFT), " Fenetre Hamming, recouvrement 50%"]);
xlabel("Fréquence réduite f");
ylabel("Amplitude (dB)");
