clc
clear
close all

% Dati covid
opts = detectImportOptions('Daticovid.csv');
opts.SelectedVariableNames = {'totale_positivi'};
dati = table2array(readtable('Daticovid.csv', opts));

toss = 120; % Tempo di osservazione

% Valori iniziali per i modelli SIR/SEIRS/SVEIRS
S0 = 1000000; % Numero iniziale di suscettibili
V0 = 0; % Numero iniziale di vaccinati
E0 = 0; % Numero iniziale di esposti
I0 = 200; % Numero iniziale di infetti
R0 = 0;  % Numero iniziale di recuperati
% N = S0 + V0 + E0 + I0 + R0 Campione popolazione

% Parametri dei modelli SIR/SEIRS/SVEIRS
beta = 0.26; % Tasso di contagio
sigma = 1/5.1; % Tasso di conversione da esposto ad infetto
gamma = 1/14; % Tasso di conversione da infetto a recuperato
xi = 1/90; % Tasso di conversione da recuperato a suscettibile
v = 0.025; % Tasso di vaccinazione

parSIR = [S0 I0 beta gamma];

parSEIRS = [S0 50000 0.25 sigma 1/19.1 xi];

parSVEIRS = [S0 400000 0.22 sigma 1/19.1 xi v];

[S1_SIR, I1_SIR, R1_SIR] = modelloSIR(parSIR, toss);
% Plot dei risultati SIR
figure(1);
plot(1:toss, S1_SIR, 'b', 1:toss, I1_SIR,'r', 1:toss, R1_SIR, 'g');
xlabel('Tempo (giorni)');
ylabel('Popolazione');
legend('Suscettibili','Infetti','Recuperati');
title('Modello SIR');
axis tight;

[S1_SEIRS, E1_SEIRS, I1_SEIRS, R1_SEIRS] = modelloSEIRS(parSEIRS, toss);
% Plot dei risultati SEIRS
figure(2);
plot(1:toss, S1_SEIRS, 'b', 1:toss, E1_SEIRS, 'k', 1:toss, I1_SEIRS, 'r', 1:toss, R1_SEIRS, 'g');
xlabel('Tempo (giorni)');
ylabel('Popolazione');
legend('Suscettibili','Esposti','Infetti','Recuperati');
title('Modello SEIRS');
axis tight;

[S1_SVEIRS, V1_SEIRS, E1_SVEIRS, I1_SVEIRS, R1_SVEIRS] = modelloSVEIRS(parSVEIRS, toss);
% Plot dei risultati SVEIRS
figure(3);
plot(1:toss, S1_SVEIRS, 'b', 1:toss, V1_SEIRS, 'c', 1:toss, E1_SVEIRS, 'k', 1:toss, I1_SVEIRS, 'r', 1:toss, R1_SVEIRS, 'g');
xlabel('Tempo (giorni)');
ylabel('Popolazione');
legend('Suscettibili','Vaccinati','Esposti','Infetti','Recuperati');
title('Modello SVEIRS');
axis tight;

%Confronto infetti SIR con dati veri
figure(4); 
plot(1:toss, I1_SIR);
hold on;
plot(dati(1:120), '*');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati', 'dati reali');
title('Modello SIR');
axis tight;

%Confronto infetti SEIRS con dati veri
figure(5); 
plot(1:toss, I1_SEIRS);
hold on;
plot(dati(220:340), '*');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati', 'dati reali');
title('Modello SEIRS');
axis tight;

%Confronto infetti SVEIRS con dati veri
figure(6); 
plot(1:toss, I1_SVEIRS);
hold on;
plot(dati(360:480), '*');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati', 'dati reali');
title('Modello SVEIRS');
axis tight;

% Stime migliorate SIR
[guessMigliorataSIR, ~] = fminsearch(@(g)errore(g,dati(1:120)), parSIR);
[S2_SIR, I2_SIR, R2_SIR] = modelloSIR(guessMigliorataSIR, toss);
figure(7);
plot(1:toss, I2_SIR);
hold on;
plot(dati(1:120), '*');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ', 'dati reali');
title('Modello SIR');
axis tight;

% Stime migliorate SEIRS
[guessMigliorataSEIRS, ~] = fminsearch(@(g)errore(g, dati(220:340)), parSEIRS);
[S2_SEIRS, E2_SEIRS, I2_SEIRS, R2_SEIRS] = modelloSEIRS(guessMigliorataSEIRS, toss);
figure(8);
plot(1:toss, I2_SEIRS);
hold on;
plot(dati(220:340), '*');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ', 'dati reali');
title('Modello SEIRS');
axis tight;


%Stime migliorate SVEIRS
[guessMigliorataSVEIRS, ~] = fminsearch(@(g)errore(g,dati(360:480)), parSVEIRS);
[S2_SVEIRS, V2_SVEIRS, E2_SVEIRS, I2_SVEIRS, R2_SVEIRS] = modelloSVEIRS(guessMigliorataSVEIRS, toss);
figure(9);
plot(1:toss, I2_SVEIRS);
hold on;
plot(dati(360:480), '*');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ', 'dati reali');
title('Modello SVEIRS');
axis tight;

%Predizione 30/60/90 giorni SIR
%30 Giorni
[guessPredettaSIR30GG, ~] = fminsearch(@(g)errore(g,dati(1:30)), parSIR);
[S3_SIR, I3_SIR, R3_SIR] = modelloSIR(guessPredettaSIR30GG, toss);
figure(10);
plot(1:toss, I3_SIR);
hold on;
plot(dati(1:120), '*');
hold on;
y = ylim;
plot([30 30], [y(1) y(2)], 'k--');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ (30 Giorni)', 'dati reali', 'cutoff (30 Giorni)');
title('Modello SIR');
axis tight;

%60 Giorni
[guessPredettaSIR60GG, ~] = fminsearch(@(g)errore(g,dati(1:60)), parSIR);
[S4_SIR, I4_SIR, R4_SIR] = modelloSIR(guessPredettaSIR60GG, toss);
figure(11);
plot(1:toss, I4_SIR);
hold on;
plot(dati(1:120), '*');
hold on;
y = ylim;
plot([60 60], [y(1) y(2)], 'k--');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ (60 Giorni)', 'dati reali', 'cutoff (60 Giorni)');
title('Modello SIR');
axis tight;

%90 Giorni
[guessPredettaSIR90GG, ~] = fminsearch(@(g)errore(g,dati(1:90)), parSIR);
[S5_SIR, I5_SIR, R5_SIR] = modelloSIR(guessPredettaSIR90GG, toss);
figure(12);
plot(1:toss, I5_SIR);
hold on;
plot(dati(1:120), '*');
hold on;
y = ylim;
plot([90 90], [y(1) y(2)], 'k--');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ (90 Giorni)', 'dati reali', 'cutoff (90 Giorni)');
title('Modello SIR');
axis tight;

%Predizione 30/60/90 giorni SEIRS

%30 Giorni
[guessPredettaSEIRS30GG, ~] = fminsearch(@(g)errore(g, dati(220:250)), parSEIRS);
[S3_SEIRS, E3_SEIRS, I3_SEIRS, R3_SEIRS] = modelloSEIRS(guessPredettaSEIRS30GG, toss);
figure(13);
plot(1:toss, I3_SEIRS);
hold on;
plot(dati(220:340), '*');
hold on;
y = ylim;
plot([30 30], [y(1) y(2)], 'k--');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ (30 Giorni)', 'dati reali', 'cutoff (30 Giorni)');
title('Modello SEIRS');
axis tight;

%60 Giorni
[guessPredettaSEIRS60GG, ~] = fminsearch(@(g)errore(g, dati(220:280)), parSEIRS);
[S4_SEIRS, E4_SEIRS, I4_SEIRS, R4_SEIRS] = modelloSEIRS(guessPredettaSEIRS60GG, toss);
figure(14);
plot(1:toss, I4_SEIRS);
hold on;
plot(dati(220:340), '*');
hold on;
y = ylim;
plot([60 60], [y(1) y(2)], 'k--');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ (60 Giorni)', 'dati reali', 'cutoff (60 Giorni)');
title('Modello SEIRS');
axis tight;

%90 Giorni
[guessPredettaSEIRS90GG, ~] = fminsearch(@(g)errore(g, dati(220:310)), parSEIRS);
[S5_SEIRS, E5_SEIRS, I5_SEIRS, R5_SEIRS] = modelloSEIRS(guessPredettaSEIRS90GG, toss);
figure(15);
plot(1:toss, I5_SEIRS);
hold on;
plot(dati(220:340), '*');
hold on;
y = ylim;
plot([90 90], [y(1) y(2)], 'k--');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ (90 Giorni)', 'dati reali', 'cutoff (90 Giorni)');
title('Modello SEIRS');
axis tight;

%Predizione 30/60/90 giorni SVEIRS

%30 Giorni
[guessPredettaSVEIRS30GG, ~] = fminsearch(@(g)errore(g,dati(360:390)), parSVEIRS);
[S3_SVEIRS, V3_SVEIRS, E3_SVEIRS, I3_SVEIRS, R3_SVEIRS] = modelloSVEIRS(guessPredettaSVEIRS30GG, toss);
figure(16);
plot(1:toss, I3_SVEIRS);
hold on;
plot(dati(360:480), '*');
hold on;
y = ylim;
plot([30 30], [y(1) y(2)], 'k--');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ (30 Giorni)', 'dati reali', 'cutoff (30 Giorni)');
title('Modello SVEIRS');
axis tight;

%60 Giorni
[guessPredettaSVEIRS60GG, ~] = fminsearch(@(g)errore(g,dati(360:420)), parSVEIRS);
[S4_SVEIRS, V4_SVEIRS, E4_SVEIRS, I4_SVEIRS, R4_SVEIRS] = modelloSVEIRS(guessPredettaSVEIRS60GG, toss);
figure(17);
plot(1:toss, I4_SVEIRS);
hold on;
plot(dati(360:480), '*');
hold on;
y = ylim;
plot([60 60], [y(1) y(2)], 'k--');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ (60 Giorni)', 'dati reali', 'cutoff (60 Giorni)');
title('Modello SVEIRS');
axis tight;

%90 Giorni
[guessPredettaSVEIRS90GG, ~] = fminsearch(@(g)errore(g,dati(360:450)), parSVEIRS);
[S5_SVEIRS, V5_SVEIRS, E5_SVEIRS, I5_SVEIRS, R5_SVEIRS] = modelloSVEIRS(guessPredettaSVEIRS90GG, toss);
figure(18);
plot(1:toss, I5_SVEIRS);
hold on;
plot(dati(360:480), '*');
hold on;
y = ylim;
plot([90 90], [y(1) y(2)], 'k--');
xlabel('Tempo (giorni)');
ylabel('Infetti');
legend('dati stimati MQ (90 Giorni)', 'dati reali', 'cutoff (90 Giorni)');
title('Modello SVEIRS');
axis tight;