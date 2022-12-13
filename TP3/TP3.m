%pkg load signal;

clear variables;
close all;
clc;

%% TP3: Détection quadratique

Fs = 500  % Hz (fréquence d'échantillonnage)

B = 160   % Hz (Bande passante du bruit)
nu0 = 100 % Hz Fréquence du signal sinusoïdal

order = 6 % Ordre du filtre butterworth (butter)

T = 100   %s Temps d'enregistrement

%%%%%%%%%%%%%%%%%% 1. Etude du bruit seul %%%%%%%%%%%%%%%%%%

t = 0:1/Fs:T-1/Fs;   % Vecteur temps de 0 Ã  T secondes

fprintf("\n======= GENERATION DU SIGNAL (signal S) =========\n");

  % Message
A0 = 1;
phi = rand() * 2*pi;  % Phase aléatoire
M = 0;

S = M*A0*cos(2*pi*nu0*t + phi);

figure()
plot(t, S);
title("Signal message");

fprintf("Moyenne de S(t): %d\n", mean(S));
fprintf("Variance de S(t): %d\n", std(S)^2);
fprintf("Ecart-type de S(t): %d\n", std(S));
fprintf("Puissance moyenne de S(t): %d\n", mean(S.^2));
fprintf("Kurtosis de S(t): %f\n", kurtosis(S));


% Bruit gaussien de bande B, centré d'écart-type au choix
fprintf("\n======= GENERATION DU BRUIT (signal B) =========\n");
figure();
sigmaB = sqrt(5);
Xp = struct('sigma', sigmaB, 'Fs', Fs, 'B', B, 'T', T);
[B, Xp] = CGN_octave(Xp);

fprintf("Moyenne de B(t): %d\n", mean(B.data));
fprintf("Variance de B(t): %d\n", std(B.data)^2);
fprintf("Ecart-type de B(t): %d\n", std(B.data));
fprintf("Puissance moyenne de B(t): %d\n", std(B.data)^2);
fprintf("Kurtosis de B(t): %f\n", kurtosis(B.data));


%%%%%%%%%%%%%%%%%%% 1.1 Addition du bruit %%%%%%%%%%%%%%%
fprintf("\n======= ADDITION DU BRUIT (signal X) =========\n");

X = B;
X.data = S + B.data;

fprintf("Moyenne de X(t): %d\n", mean(X.data));
fprintf("Variance de X(t): %d\n", std(X.data)^2);
fprintf("Ecart-type de X(t): %d\n", std(X.data));
fprintf("Puissance moyenne de X(t): %d\n", std(X.data)^2);
fprintf("Kurtosis de X(t): %f\n", kurtosis(X.data));


%%%%%%%%%%%%%%%%%%% 1.2 Filtrage passe bande F1 %%%%%%%%%%%%%%
fprintf("\n======= FILTRAGE PASSE BANDE dnu (signal Y) =========\n");

dnu = 16  % Hz

figure();
Fp = struct('Fs', Fs,'F0', nu0,'Dnu', dnu,'order', order,'class', 'bandpass');
[Y, Fp] = BPF(X, Fp);

fprintf("Moyenne de Y(t): %d\n", mean(Y.data));
fprintf("Variance de Y(t): %d\n", std(Y.data)^2);
fprintf("Ecart-type de Y(t): %d\n", std(Y.data));
fprintf("Puissance moyenne de Y(t): %d\n", std(Y.data)^2);
fprintf("Kurtosis de Y(t): %f\n", kurtosis(Y.data));

fprintf("Gamma_0 de Y(t): %d\n", std(Y.data)^2/(2*dnu));

%%%%%%%%%%%%%%%%%% 1.3 Filtrage passe bande %%%%%%%%%%%%%%%%%%%
fprintf("\n======= MISE AU CARRE (signal Z) ========\n");

Z = struct('data', Y.data.^2, 'time', Y.time, 'Fs', Y.Fs);

fprintf("Moyenne de Z(t): %d\n", mean(Z.data));
fprintf("Variance de Z(t): %d\n", std(Z.data)^2);
fprintf("Ecart-type de Z(t): %d\n", std(Z.data));
fprintf("Puissance moyenne de Z(t): %d\n", std(Z.data)^2);
fprintf("Kurtosis de Z(t): %f\n", kurtosis(Z.data));

close all;

product = [2,20,100];
for i=1:3
  fprintf("\n======= FILTRAGE INTEGRATEUR (signal W) ========\n");
  
  RC = product(i)/dnu;
  fprintf("-----> Produit RC*dnu = %d\n", product(i));
  
  figure()
  RCFp = struct('Fs', Fs, 'RC', RC);
  [W, RCFp] = RCF(Z, RCFp);

  % fprintf("RC: %f", mean(RC));
  % fprintf("Moyenne de YB(t): %f\n", mean(Wb.data));
  % fprintf("Variance de YB(t): %f\n", std(Wb.data)^2);
  % fprintf("Kurtosis de YB(t): %f\n", kurtosis(Wb.data));
  
  WC = W.data( W.time > round(RC*5));
  
  fprintf("Moyenne corrigée de W(t): %f\n", mean(WC));
  fprintf("Variance corrigée de W(t): %f\n", std(WC)^2);
  fprintf("Ecart-type corrigée de W(t): %f\n", std(WC));
  fprintf("Kurtosis corrigée de W(t): %f\n", kurtosis(WC));
  fprintf("Puissance moyenne corrigée de W(t): %f\n", mean(WC.^2));
  
end


% product = 20;

% RC = product/dnu;
% fprintf("-----> Produit RC*dnu = %d\n", product);
% 
% figure()
% RCFp = struct('Fs', Fs, 'RC', RC);
% [Wb, RCFp] = RCF(Z, RCFp);

% WbC = Wb.data( Wb.time > round(RC*5));
% 
% fprintf("RC: %f", mean(RC));
% fprintf("Moyenne de YS(t): %f\n", mean(Wb.data));
% fprintf("Variance de YS(t): %f\n", std(Wb.data)^2);
% fprintf("Kurtosis de YS(t): %f\n", kurtosis(Wb.data));


close all;















