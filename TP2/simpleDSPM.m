function [Gamma, f, N] = simpleDSPM(X, nd, nf, NFFT)

ana = X(nd:nf);
N = nf - nd; %Indices de début et de fin de sélection

% On fait la transformé de fourrier N-points
Xf = fft(ana, NFFT);
f = [0 : 1/NFFT : 1-1/NFFT];

% On calcule la DSPM (DSE divisée par nombre d'échantillons)
Gamma = (1/N).*abs(Xf).^2;
end