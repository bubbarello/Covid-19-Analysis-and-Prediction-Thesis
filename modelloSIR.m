function [S, I, R] = modelloSIR(par, toss)

% Tempo simulazione
t0 = 1; % Inizio
tf = toss; % Fine
dt = 1; % Passo d'integrazione
t = t0:dt:tf; % Vettore tempo

% Preallocamento memoria variabili
S = zeros(1,length(t));
I = zeros(1,length(t));
R = zeros(1,length(t));

% Valori iniziali
S(1) = par(1);
I(1) = par(2);
R(1) = 0;
beta = par(3);
gamma = par(4);
N = S(1) + I(1) + R(1);

% Iterazione tramite il metodo di Eulero esplicito
for i = 1:(length(t)-1)
    
    dSdt = - beta*S(i)*I(i)/N;
    dIdt = beta*S(i)*I(i)/N - gamma*I(i);
    dRdt = gamma*I(i);
    
    S(i+1) = S(i) + dSdt*dt;
    I(i+1) = I(i) + dIdt*dt;
    R(i+1) = R(i) + dRdt*dt;
end
end