function [S, V, E, I, R]=modelloSVEIRS(par, toss)

% Tempo simulazione
t0 = 1; % Inizio
tf = toss; % Fine
dt = 1; % Passo d'integrazione
t = t0:dt:tf; % Vettore tempo

% Preallocamento memoria variabili
S = zeros(1,length(t));
V = zeros(1,length(t));
E = zeros(1,length(t));
I = zeros(1,length(t));
R = zeros(1,length(t));

% Valori iniziali
S(1) = par(1);
V(1) = 0;
E(1) = 0;
I(1) = par(2);
R(1) = 0;
beta = par(3);
sigma = par(4);
gamma = par(5);
xi = par(6);
v = par(7);
mu = 1/(365*76);
alpha = 0;
theta = 1/210;
N = S(1) + V(1) + E(1) + I(1) + R(1);

% Iterazione tramite il metodo di Eulero esplicito
for i = 1:(length(t)-1)
    
    dSdt = mu*N - mu*S(i) - v*S(i) + theta*V(i) - beta*S(i)*I(i)/N + xi*R(i);
    dVdt = v*S(i) - theta*V(i) - mu*V(i);
    dEdt = (beta*S(i)*I(i))/N - sigma*E(i) - mu*E(i);
    dIdt = sigma*E(i) - gamma*I(i) - (mu + alpha)*I(i);
    dRdt = gamma*I(i) - xi*R(i) - mu*R(i);
    
    S(i+1) = S(i) + dSdt*dt;
    V(i+1) = V(i) + dVdt*dt;
    E(i+1) = E(i) + dEdt*dt;
    I(i+1) = I(i) + dIdt*dt;
    R(i+1) = R(i) + dRdt*dt;
end
end
