close all
clear variables;
clc;

pkg load signal

%Code de la 3em partie du TP2 de TSA

figure(1);
clf;

N = 4096;
M = round(N/5)
NFFT = 2*M;


X=genbrfil();
[Gth,Gbiais,fth] = sptheo(20e3,"moyenne");

[Gamma, f] = moyenneurDSPM(X, N, M, NFFT);

plot(f,10*log10(Gamma),  fth, Gth,  fth, Gbiais);

xlim([0, 0.5]);
ylim([-50, 10]);

legend("Expérimental","Th biaisé","Th idéal");
title(["Graphique avec ", sprintf("N=%d, M=%d, et NFFT=%d", N, M, NFFT)]);
xlabel("Fréquence réduite f");
ylabel("Amplitude (dB)");
