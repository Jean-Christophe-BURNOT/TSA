%% TP 1: Estimation de densités de probabilité

clear variables;
close all;

pkg load signal

Fs = 1e3;   % 1kHz

N = 1e3;    % 1000 échantillons
B = 100;    % 100Hz

fc = B;     % Fréquence de coupure du filtre

% Espéarance et écart-type du bruit X3
m = 5;      
s = 2;

% On charche dx optimal (on ne précise donc pas M)
[X1, X2, X3, Ac, Bc] = synthesize(N, B, m, s);

##% Affichage
##figure(1);
##subplot(2,4,1);
##x = 0 : 1/Fs : (length(X1)-1)/Fs;
##plot(x, X1, 'x');
##title("Echantillons X_1");
##xlabel("t (s)");
##grid on;
##
##subplot(2,4,2);
##x = 0 : 1/Fs : (length(X2)-1)/Fs;
##plot(x, X2, 'x');
##title("Echantillons X_2");
##xlabel("t (s)");
##grid on;
##
##subplot(2,4,3);
##x = 0 : 1/Fs : (length(X3)-1)/Fs;
##plot(x, X3, 'x');
##title("Echantillons X_3");
##xlabel("t (s)");
##grid on;
##
##subplot(2,4,4);
##[h,f] = freqz(Bc, Ac, N, Fs);
##plot(f, 20*log(abs(h)));
##title(sprintf("Gain du filtre (fc=%fHz)", fc));
##grid on;
##xlabel("\nu (Hz)");
##ylabel("Gain (dB)");
##
##% Gaussienne
gauss = @(x, mu, sig) (1/(sig*sqrt(2*pi)) * exp( -(x-mu).^2/(2*sig^2) ));

subplot(2,4,5);
[dp1, cbins1] = drawhist(X1);
plot(cbins1, gauss(cbins1, 0, 1));
legend('Estimée','Théorique');
grid on;

subplot(2,4,6);
[dp2, cbins2] = drawhist(X2);
plot(cbins2, gauss(cbins2, 0, 1));
legend('Estimée','Théorique');
grid on;

subplot(2,4,7);
[dp3, cbins3] = drawhist(X3);
plot(cbins3, gauss(cbins3, m, 2));
legend('Estimée','Théorique');
grid on;




% Calculer sigma avec méthode courbe 68.27%
##value = cbins3;
##proba = dp3;
##sig = 0;
##cond = 0;
##center = m;
##while (cond == 0) * (sig < 50);
##  sig += 0.001;
##  
##  bmin = center-sig;
##  bmax = center+sig;
##  
##  validx = ( bmin < value & value < bmax );
##  if sum(validx) != 0
##    x = value(validx);
##    y = proba(validx);
##    area = trapz(x, y);
##    cond = area >= 0.6827;
##  end
## end
##  
##printf("Value: %f\n", sig);
##printf("E: %f     S: %f", mean(X1), std(X1));

##proba = dp1;
##bins = cbins1;
##delta = 0;
##cond = 0;
##while (cond == 0) * (delta < 1);
##  delta += 0.001;
##  half = max(proba)/2;
##  validx = abs(proba - half) < delta;
##  cond = (sum(validx) == 2);
##end
##
##if cond == 0
##  error("Max delta reached, no candidates found");
##end
##
##candidates = bins(validx);
##sig = abs(candidates(2) - candidates(1)) / 2.355;
##printf("Value: %f\n", sig);

%Calcul des moyennes
% 1) pic le plus haut
% 2) médianne

% Mesure écart type
% abscisse à mi hauteur
% aire entre -sigma et +sigma

% Filtrage sélectif (B petit)
% Les échantillons proches dépendent de plus en plus les uns des
% autres, augmentation du rayon de correlation, échantillons plus
% indépendants, donc estimation mauvaise (car on supposait échantillons
% indépendants)

% Nombre de bins (M don dx)
% AUgmente, biais diminue mais écart-type (variance) augmente



% Variation du paramètre M
##
##figure(2);
##
##[X1, X2, X3, Ac, Bc] = synthesize(N, B, m, s);
##
##M_list = [1, 5, 10, 50, 100, 500, 1000];
##
##for i=1:8
##  subplot(2,4,i);
##  
##  if i != 8
##    M = M_list(i);
##    % Affichage de la densité empirique
##    [dp1, cbins1] = drawhist(X1, M);
##    
##    dx = (max(X1) - min(X1))/M;
##  else
##    % Affichage de la densité empirique
##    [dp1, cbins1] = drawhist(X1);
##    
##    dx = 3.49 * std(X1) * N ^ (-1/3);
##    M = ceil((max(X1) - min(X1)) / dx);
##  end
##  
##  % Affichagege de ala densité théorique
##  dp1_th = gauss(cbins1, 0, 1);
##
##  Ex = dp1_th;                     % Formules de TD
##  Vx = dp1_th/N .* (1/dx - dp1_th);
##  
##  Incert1 = sqrt(Vx);
##  
##  errorbar(cbins1, dp1_th, Incert1, '-*');
##  
##  title(sprintf("Densité Probabilité X_1 (M={%d})", M));
##  xlabel("Valeur");
##  ylabel("Probabilité");
##  legend("Empirique","Théorique");
##  grid on;
##end

% correction du filtrage ex1trême
N = 1e5;

% Variation du paramètre B

B = 5; %Hz
fc = B;

% On charche dx optimal (on ne précise donc pas M)
[X1, X2, X3, Ac, Bc] = synthesize(N, B, m, s);

% Affichage
figure(3);
subplot(2,4,1);
x = 0 : 1/Fs : (length(X1)-1)/Fs;
plot(x, X1, 'x');
title("Echantillons X_1");
xlabel("t (s)");
grid on;

subplot(2,4,2);
x = 0 : 1/Fs : (length(X2)-1)/Fs;
plot(x, X2, 'x');
title("Echantillons X_2");
xlabel("t (s)");
grid on;

subplot(2,4,3);
x = 0 : 1/Fs : (length(X3)-1)/Fs;
plot(x, X3, 'x');
title("Echantillons X_3");
xlabel("t (s)");
grid on;

subplot(2,4,4);
[h,f] = freqz(Bc, Ac, N, Fs);
plot(f, 20*log(abs(h)));
title(sprintf("Gain du filtre (fc=%fHz)", fc));
grid on;
xlabel("\nu (Hz)");
ylabel("Gain (dB)");

% Gaussienne
gauss = @(x, mu, sig) (1/(sig*sqrt(2*pi)) * exp( -(x-mu).^2/(2*sig^2) ));

subplot(2,4,5);
[dp1, cbins1] = drawhist(X1);
plot(cbins1, gauss(cbins1, 0, 1));
legend('Estimée','Théorique');
grid on;

subplot(2,4,6);
[dp2, cbins2] = drawhist(X2);
plot(cbins2, gauss(cbins2, 0, 1));
legend('Estimée','Théorique');
grid on;

subplot(2,4,7);
[dp3, cbins3] = drawhist(X3);
plot(cbins3, gauss(cbins3, m, 2));
legend('Estimée','Théorique');
grid on;

kurtosis(X2)