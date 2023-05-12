function Err=errore(par,dati)

T=length(dati);
switch length(par)
    case 4
        [~, I , ~]=modelloSIR(par, T); 
    case 6
        [~, ~ , I, ~] = modelloSEIRS(par, T); 
    case 7
        [~, ~, ~, I, ~] = modelloSVEIRS(par, T); 
    otherwise
        error('modello non supportato');
end
e=I'-dati;
Err=e'*e/T;
end