%% TP4: Filtrage de Wiener
clear variables;
close all;
clc;

[s,Fs]= audioread("ProtestMonoBruit.wav");
x = 0 : 1/Fs : 1/Fs * (length(s)-1);

% Affichage du signal
figure();
plot(x,s);
title("Signal brut");
xlabel("temps (s)");
ylabel("Amplitude");

%sound(s, Fs);

%% Calcul de l'autocorrelation du signal

% on se limite aux intervalles [60s, 70s]
t = x( (60 <= x) & (x <= 70) );
S = s( (60 <= x) & (x <= 70) );

K = 200;

[R, lags] = xcorr(S, K, 'biased');

figure();

stem(lags, R);
title(sprintf("Autocorrelation K=%d", K));
xlabel("Retard (k)");
ylabel("Amplitude");
grid on;

% Taille de la matrice
M = 20;

% CrÃ©ation de la matrice d'intercorrÃ©lation
gamma = R( (0<= lags) & (lags <= M) );
G = toeplitz(gamma);

y = zeros(M+1, 1);
y(1) = 1;

% On rÃ©soud le systÃ¨me G * h = y
% en "inversant" la matrice G
Gi = pinv(G);

res = Gi * y;
sigma = sqrt(1/res(1));
%sigma = std(S);
h = -sigma^2 * res(2 : end);

fprintf("Sig mat: %f, Sig std: %f", sigma, std(S));

figure()
stem(h);
title("Coefficients h[k]");
xlabel("Indice (k)");
ylabel("Amplitude");

%% PrÃ©diction d'un Å?n
n = round(length(S)/2);

prevs = S( n - (length(h)-1) : n );

spn = sum( h .*  flip(prevs));

%% PrÃ©diction du signal

Sp = [zeros(M,1); conv(S, [0; h], "valid")];

figure();
subplot(2,1,1);

stem(t, S);
hold on;
stem(t, Sp);
title("Comparaison des signaux");
legend("Brut", "PrÃ©dit");
xlabel("Temps (s)");

subplot(2,1,2);
stem(t, abs(S-Sp));
title("Erreur d'estimation");
xlabel("Temps (s)");


% Correction
seuil = 5*sigma;

%cracks = abs(S - Sp) > seuil;
%Sc = Sp .* cracks + S .* (1 - cracks);

Sc = zeros(length(t),1);
for i=1:length(t)
    if abs(S(i) - Sp(i)) > seuil
        Sc(i) = Sp(i);
    else
        Sc(i) = S(i);
    end
end

figure();
stem(t, S);
hold on;
stem(t, Sc);
title("Signal corrigé");
legend("Brut","Corrigé");
xlabel("Temps (s)");
xlim([62.06, 62.061]);

figure();
stem(t, abs(S-Sp));
hold on;
plot(t, seuil*ones(size(t)));
title("Signal corrigé");
legend("Erreur", "Seuil");
xlabel("Temps (s)");
xlim([62.06, 62.061]);
