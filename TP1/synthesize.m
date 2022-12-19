function [X1, X2, X3, A, B] = synthesize(N, B, m, s)
    
    Fs = 1e3; % 1kHz

    X1 = randn(N,1);            % Bruit gaussien centr� r�duis
    fc = B/(Fs/2);              % Fr�quence normalis�e pour filtre
    [B, A] = butter(8, fc);     % G�n�ration du filtre
    X2 = filter(B, A, X1);      % Filtrage
    X2 = (X2-mean(X2))/std(X2); % On centre r�duis X2
    
    % On inverse l'op�ration de centrage-r�duction
    X3 = s*X2 + m;      % Dilatation d�calage du bruit centr� r�duis
end

