function [Gamma, f] = moyenneurDSPM(X, N, M, NFFT)
    ana = X(1:N);
    window = rectwin(M);
    [Gamma, f] = pwelch(ana,window,0,NFFT, 1, "twosided");
end