function [X1, X2, X3, A, B] = synthesize(N, B, m, s)
    
    Fs = 1e3; % 1kHz

    X1 = randn(N,1);            % Bruit gaussien centré réduis
    fc = B/(Fs/2);              % Fréquence normalisée pour filtre
    [B, A] = butter(8, fc);     % Génération du filtre
    X2 = filter(B, A, X1);      % Filtrage
    X2 = (X2-mean(X2))/std(X2); % On centre réduis X2
    
    % On inverse l'opération de centrage-réduction
    X3 = s*X2 + m;      % Dilatation décalage du bruit centré réduis
end

