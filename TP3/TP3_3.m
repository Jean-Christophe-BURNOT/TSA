close all;
clear variables;

%%3.1.1: Synnthèse des signaux

%Le bruit
Fs = 500;  % Hz (fréquence d'échantillonnage)
B = 160;   % Hz (Bande passante du bruit)
nu0 = 100; % Hz Fréquence du signal sinusoïdal
order = 6; % Ordre du filtre butterworth (butter)
T = 100;   %s Temps d'enregistrement
sigmaB = sqrt(5);

figure();
Xp = struct('sigma',sigmaB,'Fs',Fs,'B',B,'T',T) ;[X,Xp] = CGN(Xp) ;

% Synthèse du binaire
figure();
Sp = struct('Fs',Fs,'A',1,'Fc',nu0,'FM',0.05,'Phi',2*pi*rand(1),'T',T,'W',[]);
[S,Sp,M] = OOK(Sp);


% Synthèse du signal complet
% S = AddSig(X,S)
X.data = X.data + S.data;
figure()
plot(X.time, X.data)


% %Synthèse du signal final
dnu = 16;
figure();
Fp = struct('Fs', Fs,'F0', nu0,'Dnu', dnu,'order', order,'class', 'bandpass');
[Y, Fp] = BPF(X, Fp);
%%%%%%%%%%%%%%%%%% 1.3 Filtrage passe bande %%%%%%%%%%%%%%%%%%%

Z = struct('data', Y.data.^2, 'time', Y.time, 'Fs', Y.Fs);

product = 20;
RC = product/dnu;

figure()
RCFp = struct('Fs', Fs, 'RC', RC);
[W, RCFp] = RCF(Z, RCFp);

ind = W.time > round(RC*5);
WC = struct('time', W.time(ind), 'data', W.data(ind));

signal = WC.data > mean(WC.data);



figure();
plot(WC.time, signal);

%% Affichage en subplot
close all;
figure()
subplot(4,1,1);
plot(S.time,S.data);
title("S(t)");


subplot(4,1,2);
plot(X.time,X.data);
title("X(t)");


subplot(4,1,3);
plot(WC.time,WC.data);
%hold on;
%plot(WC.time, mean(WC.data)*ones(size(WC.time)));

title("W(t)");


subplot(4,1,4);
plot(WC.time, signal);
title("Signal détecté");
ylim([0, 1.5]);

load 
