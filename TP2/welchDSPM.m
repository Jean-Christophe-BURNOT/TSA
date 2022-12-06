function [Gamma, f] = welchDSPM(X, N, Nom_fenetre, M, NOVERLAP, NFFT)
  ana = X(1:N);
  WIN = eval([Nom_fenetre, "(M);"]);
  [Gamma, f] = pwelch(ana, WIN, NOVERLAP, NFFT, 1, "twosided");
end